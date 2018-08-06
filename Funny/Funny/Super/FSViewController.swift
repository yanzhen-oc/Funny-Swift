//
//  FSViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/4/20.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
import YZKit

class FSViewController: UIViewController {

    private lazy var sheet: YZActionSheet = { 
        let titleItem = YZActionSheetItem(title: "退出程序", titleColor: UIColor.gray)
        let item = YZActionSheetItem(title: "确定")
        return YZActionSheet(titleItem: titleItem, delegate: self, actions: [item])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = YZCircularItem(image: #imageLiteral(resourceName: "menu_bg"), contentImage: #imageLiteral(resourceName: "shotPart"))
        let item2 = YZCircularItem(image: #imageLiteral(resourceName: "menu_bg"), contentImage: #imageLiteral(resourceName: "menu_home"))
        let item3 = YZCircularItem(image: #imageLiteral(resourceName: "menu_bg"), contentImage: #imageLiteral(resourceName: "exit"))
        let item4 = YZCircularItem(image: #imageLiteral(resourceName: "menu_bg"), contentImage: #imageLiteral(resourceName: "my"))
        
        let menuItems = [item1, item2, item3, item4]
        let startItem = YZCircularItem(image: #imageLiteral(resourceName: "menu"), contentImage: #imageLiteral(resourceName: "plus"), highlightedContentImage: #imageLiteral(resourceName: "plusHL"))
        let menu = YZCircular(frame: CGRect(x: 0, y: FHEIGHT - 200 - 49, width: 200, height: 200), startItem: startItem, startPoint: CGPoint(x: 20, y: 180), menuWholeAngle: Double.pi / 2, items: menuItems)
        menu.delegate = self
        menu.memu.alpha = 0.5
        view.addSubview(menu.memu)
    }

}

extension FSViewController: YZCircularMenuDelegate {
    func yz_CircularMenu(_ menu: UIView, didSelect index: Int) {
        menu.alpha = 0.5
        if index == 0 {
            
        } else if index == 1 {
            dismiss(animated: true, completion: nil)
        } else if index == 2 {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            self.sheet.showInView(appDelegate.window)
        } else if index == 3 {
            let storyboard = UIStoryboard(name: "About", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "FunnyAbout")
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func yz_CircularMenuWillAnimateOpen(menu: UIView) {
        menu.alpha = 1
    }
    
    func yz_CircularMenuWillAnimateClose(menu: UIView) {
        menu.alpha = 0.5
    }
}

extension FSViewController: YZActionSheetDelegate {
    func yz_actionSheet(_ actionSheet: YZActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {
            exit(0)
        }
    }
}
