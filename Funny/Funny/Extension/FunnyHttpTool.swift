//
//  FunnyHttpTool.swift
//  Funny
//
//  Created by yanzhen on 2018/4/19.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
import Alamofire

typealias FHttpResult = (value: [String : Any]? ,error: Error?)

enum FHotsoon: String {
    case Live = "live"
    case Video = "video"
}

enum FunnyAppName {
    case F9158
    case Hotsoon(FHotsoon)
    case Gifshow
    case Budejie
    case None
}

class FunnyHttpTool: NSObject {

    class func get(_ app: FunnyAppName, parameters: [String : Any] = [:], result: ((FHttpResult)->Void)?) {
        let baseUrl = baseURL(app)
        var para = baseParameters(app)
        for (key, value) in parameters {
            para[key] = value
        }
        
        Alamofire.request(baseUrl, method: .get, parameters: para).responseJSON { (response) in
            result?((response.result.value as? [String : Any], response.result.error))
        }
    }
    
    class func post(_ app: FunnyAppName, parameters: [String : Any] = [:], result: ((FHttpResult)->Void)?) {
        let baseUrl = baseURL(app)
        var para = baseParameters(app)
        for (key, value) in parameters {
            para[key] = value
        }
        
        Alamofire.request(baseUrl, method: .get, parameters: para).responseJSON { (response) in
            result?((response.result.value as? [String : Any], response.result.error))
        }
    }
    
    class func baseParameters(_ app: FunnyAppName) -> [String : Any] {
        var para: [String : Any] = [:]
        switch app {
        case .Hotsoon(let type):
            para["type"] = type.rawValue
            para["count"] = 20
            para["live_sdk_version"] = 361
            para["req_from"] = "enter_auto"
            para["ts"] = Date().timeIntervalSince1970.description
        case .Gifshow:
            para["os"] = "android"
            para["client_key"] = "3c2cd3f3"
            para["last"] = 62
            para["count"] = 20
            para["token"] = ""
            para["page"] = 1
            para["pcursor"] = ""
            para["pv"] = "false"
            para["mtype"] = 2
            para["type"] = 7
            para["sig"] = "030d2819371a88871dfdcef832f8d553"
        case .Budejie:
            para["market"] = "xiaomi"
            para["udid"] = "864312021030956"
            para["a"] = "list"
            para["appname"] = "baisibudejie"
            para["c"] = "video"
            para["os"] = "4.2.1"
            para["client"] = "android"
            para["userID"] = ""
            para["page"] = 1
            para["per"] = 60//default is 20
            para["sub_flag"] = 1
            para["visiting"] = ""
            para["type"] = 41
            para["mac"] = "68%3Adf%3Add%3A57%3A4e%3Abe"
            para["ver"] = "ver=6.0.6"
        default:
            para = [:]
        }
        return para
    }
    
    class func baseURL(_ app: FunnyAppName) -> String {
        var url = ""
        switch app {
        case .F9158:
            url = "http://live.9158.com/Fans/GetHotLive"
            //http://live.9158.com/Rank/WeekRank?Random=10
        case .Hotsoon:
            url = "https://hotsoon.snssdk.com/hotsoon/feed/"
        case .Gifshow:
            url = "http://api.gifshow.com/rest/n/feed/list?type=7&lat=39.975431&lon=116.338496&ver=4.34&ud=0&sys=ANDROID_4.2.1&c=XIAOMI&net=WIFI&did=ANDROID_41099610831fa8ef&mod=Xiaomi%282013022%29&app=0&language=zh-cn&country_code=CN"
        case .Budejie:
            url = "http://api.budejie.com/api/api_open.php"
        default:
            break
        }
        return url
    }
}
