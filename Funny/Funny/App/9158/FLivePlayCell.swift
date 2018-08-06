//
//  FLivePlayCell.swift
//  Funny
//
//  Created by yanzhen on 2018/4/30.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
import TTTPlayerKit

class FLivePlayCell: UICollectionViewCell {

    private var player: TTTPlayer?
    @IBOutlet private weak var coverImgView: UIImageView!
    public func configure(_ liveInfo: LiveInfo) {
        endPlay()
        coverImgView.kf.setImage(with: URL(string: liveInfo.imgUrl), placeholder: #imageLiteral(resourceName: "live_default"))
    }
    
    public func play(_ flv: String) {
        if player != nil { return }
        let option = TTTPlayerOptions.default()
        option.movieScalingMode = .aspectFill
        player = TTTPlayer.init(url: URL(string: flv), options: option)
        player!.playerView?.frame = bounds
        addSubview(player!.playerView!)
        player!.play()
    }
    
    public func endPlay() {
        player?.playerView?.removeFromSuperview()
        player?.stop()
        player = nil
    }
    
    deinit {
        endPlay()
    }

}
