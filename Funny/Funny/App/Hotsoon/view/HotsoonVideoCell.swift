//
//  HotsoonVideoCell.swift
//  Funny
//
//  Created by yanzhen on 2018/4/21.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class HotsoonVideoCell: UICollectionViewCell {
    @IBOutlet private weak var coverImgView: UIImageView!
    public func configrure(_ video: HotsoonVideo) {
        let url_list = video.author.avatar_jpg["url_list"] as! [String]
        coverImgView.kf.setImage(with: URL(string: url_list[0]))
    }
}
