//
//  HotsoonLiveCell.swift
//  Funny
//
//  Created by yanzhen on 2018/4/21.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class HotsoonLiveCell: UITableViewCell {

    @IBOutlet private weak var gpsLabel: UILabel!
    @IBOutlet private weak var nicknameLabel: UILabel!
    @IBOutlet private weak var coverImgView: UIImageView!
    public func configure(_ live: HotsoonLive) {
        let author = live.owner
        let url_list = author?.avatar_jpg["url_list"] as! [String]
        nicknameLabel.text = author?.nickname
        gpsLabel.text = author?.city == "" ? "未知火山" : author?.city
        coverImgView.kf.setImage(with: URL(string: url_list[0]), placeholder: #imageLiteral(resourceName: "live_default"))
        coverImgView.kf.setImage(with: URL(string: url_list[0]))
    }
}
