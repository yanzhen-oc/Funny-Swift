//
//  Funny.swift
//  Funny
//
//  Created by yanzhen on 2018/4/13.
//  Copyright © 2018年 yanzhen. All rights reserved.
//
import UIKit

let FWIDTH  = UIScreen.main.bounds.size.width
let FHEIGHT = UIScreen.main.bounds.size.height;
let FunnyColor = UIColor(red: 1.0, green: 133 / 255.0, blue: 25 / 255.0, alpha: 1.0)

let FunnyApp: [Int : String] = [
    100 : "LivePlay",
    101 : "VideoPlay",
    500 : "9158Live",
    501 : "Hotsoon",
    502 : "Gifshow",
    503 : "Budejie",
    504 : "DrawPicture",
    505 : "Note",
    506 : "QR",
    507 : "Meipai"
]


func YZLog<T>(_ items: T,file: String = #file,line: Int = #line,method: String = #function) {
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)] \([method]) \(items)")
    #endif
}
