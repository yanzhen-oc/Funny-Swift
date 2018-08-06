//
//  FunnyScrollView.swift
//  test
//
//  Created by yanzhen on 2018/4/16.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

private var FunnyHeaderKey: UInt8 = 101
private var FunnyFooterKey: UInt8 = 202

extension UIScrollView {
    var yz_header: FunnyRefreshView? {
        get {
            return objc_getAssociatedObject(self, &FunnyHeaderKey) as? FunnyRefreshView
        }
        set {
            if let headerView = newValue {
                headerView.removeFromSuperview()
                addSubview(headerView)
            }
            
            willChangeValue(forKey: "yz_header")
            objc_setAssociatedObject(self, &FunnyHeaderKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            didChangeValue(forKey: "yz_header")
        }
    }
    
    var yz_footer: FunnyRefreshView? {
        get {
            return objc_getAssociatedObject(self, &FunnyFooterKey) as? FunnyRefreshView
        }
        set {
            if let headerView = newValue {
                headerView.removeFromSuperview()
                addSubview(headerView)
            }
            
            willChangeValue(forKey: "yz_footer")
            objc_setAssociatedObject(self, &FunnyFooterKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            didChangeValue(forKey: "yz_footer")
        }
    }
    
    var yz_inset: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return adjustedContentInset
            } else {
                return contentInset
            }
        }
    }
    
    var yz_insetTop: CGFloat {
        set {
            var inset = contentInset
            inset.top = newValue
            if #available(iOS 11.0, *) {
                inset.top -= (adjustedContentInset.top - contentInset.top)
            }
            contentInset = inset
        }
        get {
            return yz_inset.top
        }
    }
    
    var yz_insetBottom: CGFloat {
        set {
            var inset = contentInset
            inset.bottom = newValue
            if #available(iOS 11.0, *) {
                inset.bottom -= (adjustedContentInset.bottom - contentInset.bottom)
            }
            contentInset = inset
        }
        get {
            return yz_inset.bottom
        }
    }
}
