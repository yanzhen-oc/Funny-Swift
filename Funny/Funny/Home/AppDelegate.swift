//
//  AppDelegate.swift
//  Funny
//
//  Created by yanzhen on 2018/4/13.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
//com.v2tech.BCYZ
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let navigationBar = UINavigationBar.appearance()
        navigationBar.tintColor = FunnyColor
        configure3DTouch()
        return true
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        FunnyManager.clearCache()
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        widgetIntoVC(Int(shortcutItem.type)!)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "Funny" {
            let subStrings = url.absoluteString.components(separatedBy: "//")
            widgetIntoVC(Int(subStrings[1])!)
        }
        return true
    }
}

private extension AppDelegate {
    
    private func widgetIntoVC(_ tag: Int) {
        let rootNVC = self.window?.rootViewController as! UINavigationController
        //程序未启动通过3DTouch---使用storyBoard这里会崩溃？？？
        let rootVC = rootNVC.viewControllers.first as! FunnyHomeViewController
        ///程序直接通过-3DTouch-或者-Widget-启动--viewDidLoad()没有被调用，需要手动调用一下
        rootVC.view.isHidden = false
        rootVC.widgetIntoViewController(tag)
    }
    
    func configure3DTouch() {
        let types = ["507","502","500"]
        let titles = ["美拍","快手","9158"]
        let icons: [UIApplicationShortcutIconType] = [.captureVideo,.play,.love]
        var items = [UIApplicationShortcutItem]()
        for i in 0...2 {
            let icon = UIApplicationShortcutIcon(type: icons[i])
            let item = UIApplicationShortcutItem(type: types[i], localizedTitle: titles[i], localizedSubtitle: nil, icon: icon, userInfo: nil)
            items.append(item)
        }
        UIApplication.shared.shortcutItems = items
    }
}
