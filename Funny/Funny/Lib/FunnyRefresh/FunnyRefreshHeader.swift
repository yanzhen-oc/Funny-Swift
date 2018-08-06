//
//  FunnyRefreshHeader.swift
//  test
//
//  Created by yanzhen on 2018/4/16.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class FunnyRefreshHeader: FunnyRefreshView {
    
    override var refreshType: FunnyRefreshType {
        return .Header
    }

    override func getRefreshY() -> CGFloat {
        return initInset.top
    }
    
    override func keepAnimation() {
        let insetTop = initInset.top + FRHEIGHT
        UIView.animate(withDuration: 0.25) {
            self.scrollView.yz_insetTop = insetTop
            self.scrollView.setContentOffset(CGPoint(x: self.scrollView.contentOffset.x, y: -insetTop), animated: false)//scroll must contain ios11 adjustedContentInset.top
        }
    }
    
    override func backToIdentity() {
        UIView.animate(withDuration: 0.25) {
            self.scrollView.yz_insetTop = self.initInset.top
        }
    }
}
