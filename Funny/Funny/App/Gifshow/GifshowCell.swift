//
//  GifshowCell.swift
//  Funny
//
//  Created by yanzhen on 2018/4/28.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class GifshowCell: UICollectionViewCell {
    
    @IBOutlet private weak var coverimgView: UIImageView!
    public func configure(_ video: GifshowVideo) {
        coverimgView.kf.setImage(with: URL(string: video.thumbnail_url), placeholder: #imageLiteral(resourceName: "live_default"))
    }
}
