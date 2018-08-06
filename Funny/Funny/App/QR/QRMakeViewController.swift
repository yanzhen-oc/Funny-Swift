//
//  QRMakeViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/5/4.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
import CoreGraphics

class QRMakeViewController: UIViewController {
    
    @IBOutlet private weak var qrImgView: UIImageView!
    @IBOutlet private weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction private func makeQR(_ sender: Any) {
        if textView.text.isEmpty { return }
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        let data = textView.text.data(using: .utf8, allowLossyConversion: true)
        filter?.setValue(data, forKey: "inputMessage")
        filter?.setValue("H", forKey: "inputCorrectionLevel")
        let outputImage = filter?.outputImage
        qrImgView.image = createNonInterpolatedUIImage(outputImage!, size: qrImgView.bounds.size.width)
    }
    
    private func createNonInterpolatedUIImage(_ image: CIImage, size: CGFloat) ->UIImage {
        let extent = image.extent.integral
        let scale = min(size / extent.width, size / extent.height)
        let width  = extent.width * scale
        let height = extent.height * scale
        
        let cs = CGColorSpaceCreateDeviceGray()
        let bitmapRef = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue)//kCGImageAlphaNone
        let context = CIContext(options: nil)
        let bitmapImage = context.createCGImage(image, from: extent)
        bitmapRef?.interpolationQuality = .none
        bitmapRef?.scaleBy(x: scale, y: scale)
        bitmapRef?.draw(bitmapImage!, in: extent)
        let scaleImage = bitmapRef?.makeImage()
        return UIImage(cgImage: scaleImage!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textView.resignFirstResponder()
    }

}
