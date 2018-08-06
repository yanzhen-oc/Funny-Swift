//
//  FunnyObject.swift
//  Funny
//
//  Created by yanzhen on 2018/4/14.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

@objcMembers
class FunnyObject: NSObject {

    var replaceCS: [String : AnyClass] {
        return [:]
    }
    
    required init(_ keyValues: [String : Any]) {
        super.init()
        setValuesForKeys(keyValues)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        guard let classType = replaceCS[key] else {
            super.setValue(value, forKey: key)
            return
        }
        let cla = classType as! FunnyObject.Type
        let obj = cla.init(value as! [String : Any])
        super.setValue(obj, forKey: key)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
