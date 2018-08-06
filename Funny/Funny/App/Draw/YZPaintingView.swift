//
//  YZPaintingView.swift
//  Funny
//
//  Created by yanzhen on 2018/5/1.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class YZPaintingView: UIView {
    
    public var lineWidth: CGFloat = 2.0
    public var lineColor = UIColor.black
    public var image: UIImage! {
        didSet {
            let imgLayer = CAShapeLayer()
            imgLayer.contents = image.cgImage
            imgLayer.frame = bounds
            layer.addSublayer(imgLayer)
            layers.append(imgLayer)
        }
    }
    private var path: YZBezierPath!
    private var shapeLayer: CAShapeLayer!
    private var layers = [CAShapeLayer]()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        let startPath = YZBezierPath(lineWidth, pathColor: lineColor, startPoint: point!)
        
        let sLayer = CAShapeLayer()
        sLayer.path = startPath.cgPath
        sLayer.backgroundColor = UIColor.clear.cgColor
        sLayer.fillColor = UIColor.clear.cgColor
        sLayer.lineCap = kCALineCapRound
        sLayer.lineJoin = kCALineJoinRound
        sLayer.strokeColor = startPath.color.cgColor
        sLayer.lineWidth = startPath.lineWidth
        layer.addSublayer(sLayer)
        
        shapeLayer = sLayer
        path = startPath
        layers.append(sLayer)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first?.location(in: self)
        path.addLine(to: point!)
        shapeLayer.path = path.cgPath
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
    }
}

extension YZPaintingView {
    public func clearScreen() {
        layers.forEach { $0.removeFromSuperlayer() }
        layers.removeAll()
        setNeedsDisplay()
    }
    
    public func undo() {
        if layers.count > 0 {
            layers.last?.removeFromSuperlayer()
            layers.removeLast()
        }
    }
    
    public func isDrawInView() ->Bool{
        return layers.count > 0
    }
}

