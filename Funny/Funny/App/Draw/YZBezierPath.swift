//
//  YZBezierPath.swift
//  Funny
//
//  Created by yanzhen on 2018/5/1.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class YZBezierPath: UIBezierPath {

    public var color = UIColor.red
    required init(_ pathLineWidth: CGFloat, pathColor: UIColor, startPoint: CGPoint) {
        super.init()
        self.lineWidth = pathLineWidth
        self.color = pathColor
        self.move(to: startPoint)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
