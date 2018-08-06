//
//  HotsoonVideo.swift
//  Funny
//
//  Created by yanzhen on 2018/4/21.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class HotsoonVideo: FunnyObject {
    
    var author: HotsoonVideoAuthor!
    var comment_delay = 0
    var create_time = 0
    var description_1 = ""
    var display_style = 0
    var id_str = ""
    var media_type = 0
    var share_title = ""
    var share_url = ""
    var stats: [String : Any] = [:]
    var title = ""
    var video: HotsoonVideoVideo!
    
    override var replaceCS: [String : AnyClass] {
        return ["author" : HotsoonVideoAuthor.self, "video" : HotsoonVideoVideo.self]
    }
}

class HotsoonVideoAuthor: FunnyObject {
    var avatar_jpg: [String : Any]!    //headImg_url
    var birthday = 0
    var birthday_description = ""
    var city: String?
    var constellation = ""
    var fan_ticket_count = 0
    var id_str = ""
    var nickname = ""                   //nickname
    var pay_grade: [String : Any]!
    var short_id = 0
    var signature = ""
}

class HotsoonVideoVideo: FunnyObject {
    var allow_cache = false
    var download_url: [String]!
    var duration = 0.0
    var height = 0
    var width = 0
    var preload_size = 0
    var video_id = 0
    var url_list: [String]!       //play video
}

