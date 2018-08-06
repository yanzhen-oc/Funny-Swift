//
//  BudejieVideo.swift
//  Funny
//
//  Created by yanzhen on 2018/4/29.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

//http://api.budejie.com/api/api_open.php?market=xiaomi&udid=864312021030956&a=list&appname=baisibudejie&c=video&os=4.2.1&client=android&userID=&page=1&per=60&sub_flag=1&visiting=&type=41&mac=68%3Adf%3Add%3A57%3A4e%3Abe&maxtime=&ver=6.0.6
//maxtime

import UIKit

class BudejieVideo: FunnyObject {

    ///头像地址
    var profile_image = ""
    ///用户名称
    var name = ""
    ///发布时间
    var create_time = ""
    ///段子内容
    var text: String?
    ///webView网址
    var weixin_url = ""
    
    ///视频封面
    var bimageuri = ""
    ///视频高度
    var height = ""
    ///视频宽度
    var width = ""
    ///视频地址
    var videouri = ""
}
