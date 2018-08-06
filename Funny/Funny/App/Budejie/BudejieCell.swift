//
//  BudejieCell.swift
//  Funny
//
//  Created by yanzhen on 2018/4/30.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class BudejieCell: UICollectionViewCell {
    @IBOutlet weak var coverImgView: UIImageView!
    public func configure(_ video: BudejieVideo) {
        coverImgView.kf.setImage(with: URL(string: video.bimageuri), placeholder: #imageLiteral(resourceName: "live_default"))
    }
}
