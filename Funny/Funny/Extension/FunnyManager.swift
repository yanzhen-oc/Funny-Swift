//
//  FunnyManager.swift
//  Funny
//
//  Created by yanzhen on 2018/5/1.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
import LocalAuthentication
import Kingfisher

class FunnyManager: NSObject {

    class func authentication(failed: (() ->Void)?,succeed:(() ->Void)?) {
        let context = LAContext()
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Use Touch ID to Login.", reply: { (success, error) in
                if success {
                    DispatchQueue.main.async(execute: {
                        succeed?()
                    })
                }else{
                    if Int32(error!._code) == kLAErrorUserFallback {
                        YZLog("User tapped Enter Password")
                    }else if Int32(error!._code) == kLAErrorUserCancel {
                        //手动取消
                        YZLog("User tapped Cancel")
                    }else{
                        //失败
                        YZLog("Authenticated failed")
                    }
                    DispatchQueue.main.async(execute: {
                        failed?()
                    })
                }
            })
        }
    }
}

extension FunnyManager {
    class func clearCache() {
        let manager = KingfisherManager.shared
        manager.cache.clearMemoryCache()
    }
    
    class func clearDisk(_ completion: (() -> Swift.Void)?) {
        KingfisherManager.shared.cache.clearDiskCache {
            completion?()
        }
    }
    
    class func getDiskCacheSize(handler: @escaping (UInt) -> Void) {
        KingfisherManager.shared.cache.calculateDiskCacheSize { (size) in
            handler(size)
        }
    }
}
