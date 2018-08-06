//
//  FHotsoonTopView.swift
//  Funny
//
//  Created by yanzhen on 2018/4/21.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

protocol HotsoonTopViewProtocol: class {
    func topViewSelected(_ index: Int)
}

class FHotsoonTopView: UIView {

    public weak var delegate: HotsoonTopViewProtocol?
    private var selectedBtn: UIButton!
    private var bottomView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        let btnW = bounds.size.width / 2
        
        let btnBlock = { (tag :Int, title: String) -> UIButton in
            let btn = UIButton(type: .custom)
            btn.frame = CGRect(x: btnW * CGFloat(tag - 100), y: 0, width: btnW, height: self.bounds.size.height)
            btn.tag = tag
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(UIColor.gray, for: .normal)
            btn.setTitleColor(UIColor.black, for: .selected)
            btn.addTarget(self, action: #selector(self.topBtnAction(_:)), for: .touchUpInside)
            self.addSubview(btn)
            return btn
        }
        
        _ = btnBlock(100, "直播")
        selectedBtn = btnBlock(101, "视频")
        selectedBtn.isSelected = true
        
        bottomView = UIView(frame: CGRect(x: frame.size.width * 0.75 - 10, y: 34, width: 20, height: 5))
        bottomView.backgroundColor = UIColor.red
        bottomView.layer.cornerRadius = 2.5
        addSubview(bottomView)
    }
    
    public func scrollToTopView(_ index: Int) {
        let sender = viewWithTag(index + 100) as! UIButton
        if sender.isSelected { return }
        sender.isSelected = true
        selectedBtn.isSelected = false
        selectedBtn = sender
        var bCenter = bottomView.center
        bCenter.x = sender.center.x
        UIView.animate(withDuration: 0.25) {
            self.bottomView.center = bCenter
        }
    }
    
    @objc func topBtnAction(_ sender: UIButton) {
        if sender.isSelected { return }
        scrollToTopView(sender.tag - 100)
        delegate?.topViewSelected(sender.tag - 100)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
