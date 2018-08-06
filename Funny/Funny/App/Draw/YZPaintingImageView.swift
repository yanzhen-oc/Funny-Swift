//
//  YZPaintingImageView.swift
//  Funny
//
//  Created by yanzhen on 2018/5/1.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

protocol YZPaintingImageViewProtocol : class{
    func drawImage(_ image: UIImage)
}

class YZPaintingImageView: UIImageView {
    
    public weak var delegate: YZPaintingImageViewProtocol?
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.black
        contentMode = .scaleAspectFit
        clipsToBounds = true
        isUserInteractionEnabled = true
        
        let pin = UIPinchGestureRecognizer(target: self, action: #selector(pinAction(_:)))
        pin.delegate = self
        addGestureRecognizer(pin)
        
        let rotation = UIRotationGestureRecognizer(target: self, action: #selector(rotationAction(_:)))
        rotation.delegate = self
        addGestureRecognizer(rotation)
    }
    
    public func startDrawPicture() {
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 0.3
        }) { (finish) in
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 1.0
            }, completion: { (finished) in
                let renderImage = self.getRenderImage()
                self.removeFromSuperview()
                self.delegate?.drawImage(renderImage)
            })
        }
    }
    
    //MARK: - gesture
    @objc private func pinAction(_ pin: UIPinchGestureRecognizer) {
        transform = transform.scaledBy(x: pin.scale, y: pin.scale)
        pin.scale = 1
    }
    
    @objc private func rotationAction(_ rotation: UIRotationGestureRecognizer) {
        transform = transform.rotated(by: rotation.rotation)
        rotation.rotation = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension YZPaintingImageView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
