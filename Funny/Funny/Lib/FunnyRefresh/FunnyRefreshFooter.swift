//
//  FunnyRefreshFooter.swift
//  test
//
//  Created by yanzhen on 2018/4/16.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class FunnyRefreshFooter: FunnyRefreshView {

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        if keyPath! != "contentSize" { return }
        let scrollViewH = scrollView.frame.size.height - initInset.top - initInset.bottom
        let originY = max(scrollViewH, scrollView.contentSize.height)
        frame = CGRect(x: 0, y: originY, width: frame.size.width, height: frame.size.height)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        superview?.removeObserver(self, forKeyPath: "contentSize", context: nil)
        guard let newView = newSuperview else { return }
        newView.addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
    }
    
    override var refreshType: FunnyRefreshType {
        return .Footer
    }

    //开始上拉的零界点
    override func getRefreshY() -> CGFloat {
        let scrollH = scrollView.frame.size.height - initInset.bottom - initInset.top
        let height = scrollView.contentSize.height - scrollH
        return height > 0 ? height - initInset.top : -initInset.top
    }
    
    override func keepAnimation() {
        var bottom = FRHEIGHT + initInset.bottom
        let scrollH = scrollView.frame.size.height - initInset.bottom - initInset.top
        let deltaH = scrollView.contentSize.height - scrollH
        if deltaH < 0 {
            bottom -= deltaH
        }
        UIView.animate(withDuration: 0.25) {
            self.scrollView.yz_insetBottom = bottom
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x, y: self.getRefreshY() + FRHEIGHT), animated: false)
        }
    }
    
    override func backToIdentity() {
        UIView.animate(withDuration: 0.25) {
            self.scrollView.yz_insetBottom = self.initInset.bottom
        }
    }
}
