//
//  F9158TableViewCell.swift
//  Funny
//
//  Created by yanzhen on 2018/4/20.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
import Kingfisher

class F9158TableViewCell: UITableViewCell {

    @IBOutlet private weak var headImgView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var gpsLabel: UILabel!
    @IBOutlet private weak var watchLabel: UILabel!
    @IBOutlet private weak var coverImgView: UIImageView!
    
    public func configure(_ user: F9158Live) {
        coverImgView.kf.setImage(with: URL(string: user.bigpic), placeholder: #imageLiteral(resourceName: "live_default"))
        headImgView.kf.setImage(with: URL(string: user.smallpic))
        nameLabel.text = user.myname
        gpsLabel.text = user.gps
        watchLabel.text = user.allnum.description
    }

}
