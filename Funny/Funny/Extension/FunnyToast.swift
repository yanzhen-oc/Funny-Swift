//
//  FunnyToast.swift
//  Funny
//
//  Created by yanzhen on 2018/4/14.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

enum ToastType {
    case center
    case top
    case bottom
}

private let FunnyToastAlpha: CGFloat = 0.7
private let FunnyToastTopPadding: CGFloat = 74
private let FunnyToastBottomPadding: CGFloat = 59
private let FunnyToastDefaultDuration: TimeInterval = 2.5

private let FunnyToastShadowRadius: CGFloat = 6.0
private let FunnyToastShadowOffset: CGSize = CGSize(width: 4.0, height: 4.0)
private let FunnyToastFontSize: CGFloat = 16
private let FunnyToastHorizontalPadding: CGFloat = 10
private let FunnyToastVerticalPadding: CGFloat = 10
private let FunnyToastFadeDuration: TimeInterval = 0.2
private let FunnyToastCornerRadius: CGFloat = 3.0

extension UIView {
    
    func showTopToast(_ message: String, duration: TimeInterval = FunnyToastDefaultDuration) {
        showToast(message, position: .top, duration: duration)
    }
    
    func showBottomToast(_ message: String, duration: TimeInterval = FunnyToastDefaultDuration) {
        showToast(message, position: .bottom, duration: duration)
    }
    
    func showToast(_ message: String, position: ToastType = .center, duration: TimeInterval = FunnyToastDefaultDuration, centerY: CGFloat? = nil) {
        let backView = viewForMessage(message)
        showToast(backView, duration: duration, position: position, centerY: centerY)
    }
}

extension UIView {
    fileprivate func showToast(_ toast: UIView, duration: TimeInterval, position: ToastType, centerY: CGFloat?) {
        toast.isUserInteractionEnabled = false
        makeToastCenter(toast, type: position, centerY: centerY)
        toast.alpha = 0
        addSubview(toast)
        
        UIView.animate(withDuration: FunnyToastFadeDuration, delay: 0, options: .curveEaseOut, animations: {
            toast.alpha = FunnyToastAlpha
        }) { (easeOut) in
            UIView.animate(withDuration: FunnyToastFadeDuration, delay: duration, options: .curveEaseIn, animations: {
                toast.alpha = 0
            }) { (easeOut) in
                toast.removeFromSuperview()
            }
        }
    }
    
    fileprivate func makeToastCenter(_ toast: UIView, type: ToastType, centerY: CGFloat?) {
        let centerX = bounds.size.width * 0.5
        if let centerY = centerY {
            toast.center =  CGPoint(x: centerX, y: centerY)
            return
        }
        var toastCenter = CGPoint.zero
        let halfToastH = toast.frame.size.height * 0.5
        switch type {
        case .top:
            toastCenter = CGPoint(x: centerX, y: halfToastH + FunnyToastTopPadding)
        case .bottom:
            toastCenter = CGPoint(x: centerX, y: bounds.size.height - halfToastH - FunnyToastBottomPadding)
        default:
            toastCenter = CGPoint(x: centerX, y: bounds.size.height * 0.5)
        }
        toast.center = toastCenter
    }
    
    fileprivate func viewForMessage(_ message: String) -> UIView {
        let toast = UIView()
        toast.backgroundColor = UIColor.black
        toast.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        toast.layer.cornerRadius = FunnyToastCornerRadius
        //
        toast.layer.shadowColor = UIColor.black.cgColor
        toast.layer.shadowOpacity = 1
        toast.layer.shadowRadius = FunnyToastShadowRadius
        toast.layer.shadowOffset = FunnyToastShadowOffset
        //label
        let messageLabel = UILabel()
        messageLabel.numberOfLines = 0
        let font = UIFont.systemFont(ofSize: FunnyToastFontSize)
        messageLabel.font = font
        messageLabel.textColor = UIColor.white
        messageLabel.text = message
        
        let maxSize = CGSize(width: bounds.size.width * 0.8, height: bounds.size.height * 0.8)
        let messageSize = message.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font : font], context: nil).size
        messageLabel.frame = CGRect(x: FunnyToastHorizontalPadding, y: FunnyToastVerticalPadding, width: messageSize.width, height: messageSize.height)
        toast.frame = CGRect(x: 0, y: 0, width: messageSize.width + 2 * FunnyToastHorizontalPadding, height: messageSize.height + 2 * FunnyToastVerticalPadding)
        toast.addSubview(messageLabel)
        return toast
    }
    
}

extension UIViewController {
    func showTopToast(_ message: String, duration: TimeInterval = FunnyToastDefaultDuration) {
        view.showToast(message, position: .top, duration: duration)
    }
    
    func showBottomToast(_ message: String, duration: TimeInterval = FunnyToastDefaultDuration) {
        view.showToast(message, position: .bottom, duration: duration)
    }
    
    func showToast(_ message: String, position: ToastType = .center, duration: TimeInterval = FunnyToastDefaultDuration, centerY: CGFloat? = nil) {
        view.showToast(message, position: position, duration: duration, centerY: centerY)
    }
}

