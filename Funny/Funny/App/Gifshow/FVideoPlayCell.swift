//
//  FVideoPlayCell.swift
//  Funny
//
//  Created by yanzhen on 2018/4/30.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
import AVFoundation

class FVideoPlayCell: UICollectionViewCell {

    private var playerObserver: Any?
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var videoUrl = ""
    //
    @IBOutlet private weak var coverImgView: UIImageView!
    @IBOutlet private weak var loadProgress: UIProgressView!
    @IBOutlet private weak var currentProgress: UIProgressView!
    deinit {
        playEnd()
    }
    
    public func configure(_ video: VideoInfo) {
        playEnd()
        videoUrl = video.videoUrl
        print(video.videoUrl)
        coverImgView.kf.setImage(with: URL(string: video.imgUrl))
    }
    
    public func playVideo() {
        if player != nil { return }
        let playerItem = AVPlayerItem(url: URL(string: videoUrl)!)
        player = AVPlayer(playerItem: playerItem)
        player?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspect
        playerLayer?.backgroundColor = UIColor.clear.cgColor
        playerLayer?.frame = coverImgView.bounds
        coverImgView.layer.addSublayer(playerLayer!)
        addObserver()
        player?.play()
    }
    
    public func playEnd() {
        if let observer = playerObserver {
            player?.removeTimeObserver(observer)
        }
        
        if let player = player {
            //避免快速滑动
            if !player.isRemoveStatus {
                player.removeObserver(self, forKeyPath: "status")
            }
        }
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        NotificationCenter.default.removeObserver(self)
        loadProgress.setProgress(0, animated: false)
        currentProgress.setProgress(0, animated: false)
    }
    
    public func animate(_ cellFrame: CGRect) {
        coverImgView.frame = cellFrame
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.coverImgView.frame = self.bounds
        }) { (finished) in
            self.playVideo()
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let player = player {
            if player.status == .readyToPlay {
                startPlayVideo()
                playerLayer?.backgroundColor = UIColor.black.cgColor
            } else if player.status == .failed {
                print("play fail")
            }
            player.removeObserver(self, forKeyPath: "status")
            player.isRemoveStatus = true
        }
    }
}

private extension FVideoPlayCell {
    func startPlayVideo() {
        let time = CMTimeMake(1, 2)
        playerObserver = player?.addPeriodicTimeObserver(forInterval: time, queue: DispatchQueue.main, using: { [weak self] (time) in
            self?.updatePlayerStatus()
        })
    }
    
    func updatePlayerStatus() {
        guard let player = player else { return }
        let totalTime = CMTimeGetSeconds(player.currentItem!.duration)
        let currentTime = CMTimeGetSeconds(player.currentTime())
        var loadTime: Float64 = 0
        if player.currentItem!.loadedTimeRanges.count > 0 {
            let timeRange = player.currentItem!.loadedTimeRanges[0].timeRangeValue
            loadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration)
        }
        loadProgress.setProgress(Float(loadTime / totalTime), animated: true)
        currentProgress.setProgress(Float(currentTime / totalTime), animated: true)
    }
}
//observer
private extension FVideoPlayCell {
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playAVEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func playAVEnd() {
        playEnd()
        playVideo()
    }
    
    @objc func didEnterBackground() {
        player?.pause()
    }
    
    @objc func didBecomeActive() {
        player?.play()
    }
}
