//
//  TodayCell.swift
//  Today
//
//  Created by yanzhen on 2018/5/4.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class TodayCell: UICollectionViewCell {
    @IBOutlet private weak var iconImgView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    public func configure(_ info: (String, String, Int32)) {
        iconImgView.image = UIImage(named: info.1)
        titleLabel.text = info.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        iconImgView.layer.masksToBounds = true
        iconImgView.layer.cornerRadius = 12
    }
}
