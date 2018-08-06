//
//  FunnyExtension.swift
//  Funny
//
//  Created by yanzhen on 2018/4/13.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
import AVFoundation

extension UIColor {
    convenience init(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }
}

extension UIView {
    
    public var x: CGFloat{
        get{
            return frame.origin.x
        }
        set{
            var setframe = frame
            setframe.origin.x = newValue
            frame = setframe
        }
    }
    
    public var y: CGFloat{
        get{
            return frame.origin.y
        }
        set{
            var setframe = frame
            setframe.origin.y = newValue
            frame = setframe
        }
    }
    
    public var width: CGFloat{
        get{
            return frame.size.width
        }
        set{
            var setframe = frame
            setframe.size.width = newValue
            frame = setframe
        }
    }
    
    public var height: CGFloat{
        get{
            return frame.size.height
        }
        set{
            var setframe = self.frame
            setframe.size.height = newValue
            frame = setframe
        }
    }
    
    public var centerX: CGFloat{
        get{
            return center.x
        }
        set{
            center = CGPoint(x: newValue, y: center.y)
        }
    }
    
    public var centerY: CGFloat{
        get{
            return center.y
        }
        set{
            center = CGPoint(x: center.x, y: newValue)
        }
    }
    
    public var size: CGSize{
        get{
            return frame.size;
        }
        set{
            var setframe = frame
            setframe.size = newValue
            frame = setframe
        }
    }
    //MARK: UIView XIB属性
    @IBInspectable var borderWidth: CGFloat{
        get {
            return 0.0;
        }
        set{
            layer.borderWidth = newValue;
        }
    }
    
    @IBInspectable var borderColor: UIColor{
        get {
            return UIColor();
        }
        set{
            layer.borderColor = newValue.cgColor;
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat{
        get {
            return 0.0;
        }
        set{
            layer.masksToBounds = true;
            layer.cornerRadius = newValue;
        }
    }
    //MARK: UIView 只读属性
    public var maxX: CGFloat{
        get{
            return frame.maxX
        }
    }
    
    public var maxY: CGFloat{
        get{
            return frame.maxY
        }
    }
    //MARK: UIView--Method
    func corner() {
        layoutIfNeeded();
        layer.masksToBounds = true
        layer.cornerRadius  = frame.size.width / 2
    }
    
    public func getRenderImage() ->UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        layer.render(in: context!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    public func snapshotScreenInView() -> UIImage {
        let size = bounds.size
        let rect = frame
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        drawHierarchy(in: rect, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

extension String {
    public var isURL: Bool {
        get{
            let regulaStr = "(((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?))'>((?!<\\/a>).)*<\\/a>|(((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%@^&*+?:_/=<>]*)?))"
            let range = self.range(of: regulaStr, options: .regularExpression, range: nil, locale: nil)
            return range != nil
        }
    }
}

private var AVSTATUSKEY: UInt8 = 103
extension AVPlayer {
    var isRemoveStatus: Bool {
        get {
            guard let status = objc_getAssociatedObject(self, &AVSTATUSKEY) else {
                return false
            }
            return status as! Bool
        }
        set {
            willChangeValue(forKey: "isRemoveStatus")
            objc_setAssociatedObject(self, &AVSTATUSKEY, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            didChangeValue(forKey: "isRemoveStatus")
        }
    }
}
