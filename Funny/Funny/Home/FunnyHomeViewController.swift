//
//  FunnyHomeViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/4/13.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

private let reuseIdentifier = "HomeAppCell"
//ios
private let HSTOPH: CGFloat = 146

class FunnyHomeViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var appIcons: [UIImage]!
    private var appTitles: [String]!
    private var headerView: HomeHeaderView!
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.alwaysBounceVertical = true
        let layout = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: 60, height: 95)
        layout.minimumInteritemSpacing = (FWIDTH - 240) / 5
        appIcons = [#imageLiteral(resourceName: "now"), #imageLiteral(resourceName: "hotsoon"), #imageLiteral(resourceName: "gifshow"), #imageLiteral(resourceName: "budejie"), #imageLiteral(resourceName: "drawPicture"), #imageLiteral(resourceName: "note"), #imageLiteral(resourceName: "QR"), #imageLiteral(resourceName: "meipai")]
        appTitles = ["9158", "火山", "快手", "不得姐", "画图", "记事本", "二维码", "美拍"]

        let headerH = collectionView!.bounds.size.height
        headerView = HomeHeaderView(frame: CGRect(x: 0, y: -headerH, width: collectionView!.frame.size.width, height: headerH))
        headerView.delegate = self
        collectionView?.addSubview(headerView)
    }

   
    
    
    public func widgetIntoViewController(_ tag: Int) {
        if let presentedVC = presentedViewController {
            presentedVC.dismiss(animated: true, completion: nil)
        }else if (navigationController!.viewControllers.count > 1) {
            navigationController?.popToRootViewController(animated: true)
        }
        enterHeaderApp(tag)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appIcons.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! HomeAppCell
        cell.appIcon.image = appIcons[indexPath.row]
        cell.titleLabel.text = appTitles[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let space = (FWIDTH - 240) / 5
        return UIEdgeInsets(top: 0, left: space, bottom: 0, right: space)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        enterHeaderApp(indexPath.row + 500)
    }
    
}

extension FunnyHomeViewController: HomeHeaderProtocol {
    func enterHeaderApp(_ index: Int) {
        performSegue(withIdentifier: FunnyApp[index]!, sender: nil)
    }
}

extension FunnyHomeViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //悬停之后，恢复的时候不做三点的动画
        if scrollView.contentInset.top == HSTOPH && scrollView.contentOffset.y > -(HSTOPH + 64) {
            return
        }
        headerView.getOffsetY(scrollView.contentOffset.y)
    }
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        var inset = scrollView.contentInset
        let offsetY = scrollView.contentOffset.y
        if offsetY < -140 {
            inset.top = HSTOPH
        } else if inset.top == HSTOPH && offsetY >= -100  {//保证字体被遮住才可以恢复
            inset.top = 0
        }
        UIView.animate(withDuration: 0.25) {
            scrollView.contentInset = inset
        }
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentInset.top != HSTOPH {
            headerView.backToIdentity()
        }
    }
}
