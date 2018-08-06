//
//  HotsoonLive.swift
//  Funny
//
//  Created by yanzhen on 2018/4/21.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class HotsoonLive: FunnyObject {
    
    var cell_style = 0
    var client_version = 0
    var common_label_list: String?
    var cover: [String : Any]?
    var enable_room_perspective = false
    var feed_room_label: [String : Any] = [:] //obj
    var finish_time = 0
    var id_str = ""
    var luckymoney_num = 0
    var mosaic_status = 0
    var os_type = 0
    var owner: HotsoonLiveOwner!
    var share_url = ""
    var stats: [String : Any] = [:]
    var status = 0
    var stream_id_str = ""
    var stream_url: HotsoonLiveStream_url!
    var title: String?
    var user_count = 0
    var with_linkmic = false
    
    override var replaceCS: [String : AnyClass] {
        return ["owner" : HotsoonLiveOwner.self, "stream_url" : HotsoonLiveStream_url.self]
    }
}

class HotsoonLiveOwner: FunnyObject {
    var avatar_jpg: [String : Any] = [:] //Array-url_list
    var birthday = 0
    var city: String?
    var constellation = ""
    var fan_ticket_count = 0
    var gender = 0
    var id_str = ""
    var nickname = ""
    var pay_grade: [String : Any] = [:] //??
    var short_id = 0
    var signature = ""
}

class HotsoonLiveStream_url: FunnyObject {
    var candidate_resolution: [Any]?
    var default_resolution = ""
    var extra: [String : Any]?
    var flv_pull_url: [String : Any]?
    var id_str = ""
    var provider = 0
    var resolution_name: [String : Any]?
    var rtmp_pull_url = ""                     //flv
}

