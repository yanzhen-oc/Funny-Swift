//
//  QRScanningViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/5/4.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
import AVFoundation

class QRScanningViewController: UIViewController {

    public var scanVC: QRScanViewController!
    private var session: AVCaptureSession?
    @IBOutlet private weak var scanImgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let scanWH: CGFloat = 300
        let layer = createMaskLayer(CGRect(x: (FWIDTH - scanWH) * 0.5, y: (FHEIGHT - scanWH) * 0.5, width: scanWH, height: scanWH))
        layer.fillColor = UIColor(white: 0, alpha: 0.5).cgColor
        view.layer.addSublayer(layer)
        
        let scanNetIV = UIImageView(frame: CGRect(x: 0, y: -scanWH, width: scanWH, height: scanWH))
        scanNetIV.image = #imageLiteral(resourceName: "scan_net")
        let scanNetAnimation = CABasicAnimation()
        scanNetAnimation.keyPath = "transform.translation.y"
        scanNetAnimation.byValue = scanWH
        scanNetAnimation.duration = 1.0
        scanNetAnimation.repeatCount = MAXFLOAT
        scanNetAnimation.fillMode = kCAFillModeForwards
        scanNetAnimation.isRemovedOnCompletion = false
        scanNetIV.layer.add(scanNetAnimation, forKey: nil)
        scanImgView.addSubview(scanNetIV)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startScanning()
    }
    
    @IBAction func close(_ sender: UIButton) {
        session?.stopRunning()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choseFromPhotos(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.delegate = self
        self.present(imagePicker, animated: true) {
            FunnyHud.showHud(self.view, message: "正在识别")
        }
    }
    
}

extension QRScanningViewController: UINavigationControllerDelegate,  UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated: true) {
            self.readQR(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        FunnyHud.hideHud(for: view)
        dismiss(animated: true, completion: nil)
    }
}

extension QRScanningViewController: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.count > 0 {
            let obj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            scanVC.scanningDone(obj.stringValue!)
            session?.stopRunning()
            dismiss(animated: true, completion: nil)
        }
    }
}

private extension QRScanningViewController {
    func readQR(_ image: UIImage) {
        
        
//        let ciImage = CIImage(cgImage: image.cgImage!)
        let ciImage = CIImage(image: image)
        let context = CIContext(options: nil)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        FunnyHud.hideHud(for: self.view)
        //二维码和其它同时存在崩溃
        if let features = detector?.features(in: ciImage!) {
            for value in features {
                if value is CIQRCodeFeature {
                    let feature = value as! CIQRCodeFeature
                    scanVC.scanningDone(feature.messageString!)
                    session?.stopRunning()
                    dismiss(animated: true, completion: nil)
                    return
                }
            }
        }
        
        let alert = UIAlertController(title: "提示", message: "无法识别您选中的图片", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func startScanning() {
        if session != nil { return }
        let device = AVCaptureDevice.default(for: AVMediaType.video)
        let input = try! AVCaptureDeviceInput(device: device!)
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        ///限制扫描区域
        ///http://www.jianshu.com/p/4772d3cb6a43
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let scanWH: CGFloat = 300
        let scanX = (height - scanWH) / 2 / height
        let scanY = (width - scanWH) / 2 / width
        output.rectOfInterest = CGRect(x: scanX, y: scanY, width: scanWH / height + scanX, height: scanWH / width + scanY)
        ///
        session = AVCaptureSession()
        session?.sessionPreset = AVCaptureSession.Preset.high
        if session!.canAddInput(input) {
            session?.addInput(input)
        }
        if session!.canAddOutput(output) {
            session?.addOutput(output)
        }
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        let previewLayer = AVCaptureVideoPreviewLayer(session: session!)
        previewLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.insertSublayer(previewLayer, at: 0)
        session?.startRunning()
    }
    
    private func createMaskLayer(_ exceptRect: CGRect) -> CAShapeLayer {
        let shapeLayer = CAShapeLayer()
        let exceptX = exceptRect.origin.x
        let exceptY = exceptRect.origin.y
        let exceptW = exceptRect.size.width
        let exceptH = exceptRect.size.height
        
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: FWIDTH, height: exceptY))
        path.append(UIBezierPath(rect: CGRect(x: 0, y: exceptY, width: exceptX, height: exceptH)))
        path.append(UIBezierPath(rect: CGRect(x: 0, y: exceptY + exceptH, width: FWIDTH, height: exceptY)))
        path.append(UIBezierPath(rect: CGRect(x: exceptX + exceptW, y: exceptY, width: exceptX, height: exceptH)))
        shapeLayer.path = path.cgPath
        return shapeLayer
    }
}
