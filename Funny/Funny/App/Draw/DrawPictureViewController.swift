//
//  DrawPictureViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/5/1.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class DrawPictureViewController: FSViewController {

    @IBOutlet private weak var paintingView: YZPaintingView!
    private var dpImageView: YZPaintingImageView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func undo(_ sender: Any) {
        paintingView.undo()
    }
    
    @IBAction private func clear(_ sender: Any) {
        paintingView.clearScreen()
    }
    
    @IBAction private func eraser(_ sender: Any) {
        paintingView.lineColor = UIColor.white
    }
    
    @IBAction private func photo(_ sender: Any) {
        paintingView.clearScreen()
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction private func startMark(_ sender: Any) {
        dpImageView?.startDrawPicture()
    }
    
    @IBAction private func save(_ sender: Any) {
        if !paintingView.isDrawInView() {
            return
        }
        let image = paintingView.getRenderImage()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    
    @IBAction private func slider(_ sender: UISlider) {
        paintingView.lineWidth = CGFloat(sender.value)
    }
    
    @IBAction private func colorBtnClick(_ sender: UIButton) {
        paintingView.lineColor = sender.backgroundColor!
    }
}

extension DrawPictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dpImageView = YZPaintingImageView(frame: paintingView.frame)
        dpImageView?.delegate = self
        dpImageView?.image = image
        view.addSubview(dpImageView!)
        paintingView.lineColor = UIColor.black
        dismiss(animated: true, completion: nil)
    }
}

extension DrawPictureViewController: YZPaintingImageViewProtocol {
    func drawImage(_ image: UIImage) {
        paintingView.image = image
    }
}
