//
//  HomeHeaderView.swift
//  Funny
//
//  Created by yanzhen on 2018/4/14.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

protocol HomeHeaderProtocol: class {
    func enterHeaderApp(_ index: Int)
}

private let CollectionH: CGFloat = 85
private let CollectionBH: CGFloat = 76//collectionView distance bottom
private let CollectionXBH = CollectionH + CollectionBH

class HomeHeaderView: UIView {

    public var delegate: HomeHeaderProtocol?
    private var appIcons: [UIImage]!
    private var appTitles: [String]!
    private var collectionView: UICollectionView!
    private var leftView: UIView!
    private var middleView: UIView!
    private var rightView: UIView!
    private var tipLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        let itemW = (FWIDTH - 75) / 4
        layout.itemSize = CGSize(width: itemW, height: CollectionH)
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect(x: 0, y: frame.size.height - CollectionXBH, width: frame.size.width, height: CollectionH), collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(UINib(nibName: "HomeHeaderCell", bundle: nil), forCellWithReuseIdentifier: "HomeHeaderCell")
        addSubview(collectionView)
        //
        let tWH: CGFloat = 6
        let ty = frame.size.height - tWH
        let initView = { () -> UIView in
            let view = UIView(frame: CGRect(x: (FWIDTH - tWH) * 0.5, y: ty, width: tWH, height: tWH))
            view.layer.cornerRadius = tWH * 0.5
            view.backgroundColor = UIColor.gray
            view.transform = CGAffineTransform(scaleX: 0, y: 0)
            self.addSubview(view)
            return view
        }
        leftView = initView()
        rightView = initView()
        middleView = initView()
        
        tipLabel = UILabel(frame: CGRect(x: 0, y: bounds.size.height - 25, width: frame.size.width, height: 20))
        tipLabel.font = UIFont.systemFont(ofSize: 12)
        tipLabel.text = "不要再拉了，亲"
        tipLabel.textColor = UIColor.gray
        tipLabel.textAlignment = .center
        tipLabel.isHidden = true
        addSubview(tipLabel)
        
        appIcons = [#imageLiteral(resourceName: "live_logo"), #imageLiteral(resourceName: "video_logo")]
        appTitles = ["直播", "视频"]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension HomeHeaderView {
    public func getOffsetY(_ offsetY: CGFloat) {
        tipLabel.isHidden = true
        if offsetY >= -64 {
            middleView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
            leftView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
            rightView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
            
        } else if offsetY >= -90 {//middle scale
            let scale = (-64 - offsetY) / (26.0 / 1.5)//最大放大1.5
            middleView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
            middleView.center = CGPoint(x: middleView.center.x, y: bounds.size.height - (-64 - offsetY) / 2)
            
            leftView.center = middleView.center
            rightView.center = middleView.center
            rightView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
            leftView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        }else if offsetY >= -140 {//center change
            let scale = 1.5 - (-90 - offsetY) / 100
            middleView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
            let centerY = bounds.size.height - (-64 - offsetY) / 2
            let centerX = middleView.center.x
            middleView.center = CGPoint(x: centerX, y: centerY)
            
            let offsetX = (-90 - offsetY) / 2.5
            leftView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            rightView.transform = CGAffineTransform.init(scaleX: 1, y: 1)
            leftView.center = CGPoint(x: centerX - offsetX, y: centerY)
            rightView.center = CGPoint(x: centerX + offsetX, y: centerY)
        }else if offsetY >= -210 {
            //m,l,r centerY distance bottom = (140 - 64) / 2 = 38//radius=3
            let offset = -140 - offsetY
            var centerY = bounds.size.height - 38 + offset / 2
            let moveViewCenterY = { (view: UIView) in
                view.center = CGPoint(x: view.center.x, y: centerY)
                view.alpha = 1 - offset / 70
            }
            moveViewCenterY(middleView)
            moveViewCenterY(leftView)
            moveViewCenterY(rightView)
            //collectionview center in -210+64 center
            centerY = (frame.size.height - CollectionXBH) + CollectionH / 2//origin centerY
            //total move distance
            let moveCenterY = CollectionBH + CollectionH / 2 - (210.0 - 64) / 2
            collectionView.center = CGPoint(x: collectionView.center.x, y: centerY + moveCenterY / 70 * offset)
        }else if offsetY >= -bounds.height * 0.7 {
            var centerC = collectionView.center
            centerC.y = bounds.size.height - (-64 - offsetY) / 2
            collectionView.center = centerC
        }else {
            tipLabel.isHidden = false
        }
    }
    
    public func backToIdentity() {
        middleView.alpha = 1
        rightView.alpha = 1
        leftView.alpha = 1
        var cFrame = collectionView.frame
        cFrame.origin.y = bounds.size.height - CollectionXBH
        collectionView.frame = cFrame
    }
}

extension HomeHeaderView: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeHeaderCell", for: indexPath) as! HomeHeaderCell
        cell.appIcon.image = appIcons[indexPath.row]
        cell.titleLabel.text = appTitles[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.enterHeaderApp(indexPath.row + 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
}

