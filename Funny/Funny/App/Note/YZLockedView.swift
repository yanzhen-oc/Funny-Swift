//
//  YZLockedView.swift
//  Funny
//
//  Created by yanzhen on 2018/5/1.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

protocol YZLockedViewDelegate: class {
    func passwordIsRight(password: String) ->Bool
}

class YZLockedView: UIView {

    public weak var delegate: YZLockedViewDelegate?
    private var titleLabel: UILabel!
    private var topView: UIView!
    private var lockView: UIView!
    private var cancelBtn: UIButton!
    private var password = ""
    private var views = [UIView]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureUI()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 25)
        titleLabel.center = CGPoint(x: self.width * 0.5, y: 40)
        //
        let space: CGFloat = 25
        let viewWH: CGFloat = 15;
        let topW = viewWH * 4 + space * 5
        let topH = viewWH + 5 * 2
        topView.frame = CGRect(x: 0, y: 0, width: topW, height: topH)
        topView.center = CGPoint(x: self.width * 0.5, y: titleLabel.maxY + 35)
        for view in topView.subviews {
            view.frame = CGRect(x: space + (space + viewWH) * CGFloat(view.tag - 100), y: 5, width: viewWH, height: viewWH)
        }
        
        let lockBtnWH: CGFloat = 75
        let lockSpace: CGFloat = 25
        let lockW = lockBtnWH * 3 + lockSpace * 4
        let lockH = lockBtnWH * 4 + lockSpace * 5
        ///
        lockView.frame = CGRect(x: 0, y: 0, width: lockW, height: lockH)
        lockView.center = CGPoint(x: self.width * 0.5, y: self.height * 0.5 + (lockBtnWH + lockSpace) * 0.5 - 25)
        for btn in lockView.subviews {
            let row = btn.tag / 3
            let col = btn.tag % 3
            if btn.tag == 9 {
                btn.frame = CGRect(x: 0, y: lockSpace + (lockBtnWH + lockSpace) * CGFloat(row), width: lockBtnWH, height: lockBtnWH)
                btn.centerX = lockView.width * 0.5
            }else{
                btn.frame = CGRect(x: lockSpace + (lockBtnWH + lockSpace) * CGFloat(col), y: lockSpace + (lockBtnWH + lockSpace) * CGFloat(row), width: lockBtnWH, height: lockBtnWH)
            }
        }
        ///
        
        cancelBtn.frame = CGRect(x: 0, y: 0, width: lockBtnWH, height: lockBtnWH)
        cancelBtn.center = CGPoint(x: self.width * 0.5 + lockBtnWH + lockSpace, y: lockView.subviews.last!.centerY + 113)
    }
}

private extension YZLockedView {
    func configureUI() {
        titleLabel = UILabel()
        titleLabel.text = "输入密码"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor.white
        addSubview(titleLabel)
        ///
        topView = UIView()
        topView.backgroundColor = UIColor.clear
        for i in 0...3 {
            let view = UIView()
            view.tag = 100 + i
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 7.5
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(43, 134, 182).cgColor
            topView.addSubview(view)
        }
        addSubview(topView)
        ///
        lockView = UIView()
        lockView.backgroundColor = UIColor.clear
        let lockBtnWH: CGFloat = 75
        for i in 0...9 {
            let btn = UIButton()
            btn.tag = i
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = lockBtnWH / 2
            btn.layer.borderWidth = 2
            btn.layer.borderColor = UIColor(43, 134, 182).cgColor
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 27)
            if i == 9 {
                btn.setTitle("0", for: .normal)
            }else{
                btn.setTitle(String(i+1), for: .normal)
            }
            btn.addTarget(self, action: #selector(lockBtnClick(btn:)), for: .touchUpInside)
            lockView.addSubview(btn)
        }
        addSubview(lockView)
        ///
        cancelBtn = UIButton()
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        addSubview(cancelBtn)
    }
    
    @objc func lockBtnClick(btn: UIButton) {
        UIView.animate(withDuration: 0.05, animations: {
            btn.backgroundColor = UIColor(43, 134, 182)
        }) { (finished) in
            btn.backgroundColor = UIColor.clear
        }
        addCode(btn.titleLabel!.text!)
    }
    
    private func addCode(_ code: String) {
        if views.count == 4 {
            return
        }
        
        let view = topView.viewWithTag(views.count + 100)
        view?.backgroundColor = UIColor(43, 134, 182)
        password = password + code
        views.append(view!)
        if views.count == 4 {
            guard let delegate = delegate else { return }
            if !delegate.passwordIsRight(password: password) {
                UIView.animate(withDuration: 0.1, animations: {
                    self.topView.transform = self.topView.transform.translatedBy(x: 20, y: 0)
                }, completion: { (finish) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.topView.transform = self.topView.transform.translatedBy(x: -40, y: 0)
                    }, completion: { (finished) in
                        self.topView.transform = .identity
                    })
                })
            }
            resetAll()
        }
    }
    
    private func resetAll() {
        password = ""
        views.forEach({$0.backgroundColor = UIColor.clear})
        views.removeAll()
    }
    
    @objc func cancelBtnClick() {
        if views.isEmpty { return }
        let view = views.last
        view?.backgroundColor = UIColor.clear
        views.removeLast()
        password.removeLast(1)
    }
}
