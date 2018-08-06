//
//  FunnyVideoPlayer.swift
//  Funny
//
//  Created by yanzhen on 2018/4/14.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
import AVFoundation

protocol FunnyVideoPlayerProtocol: class {
    func funny_playBegin()
    func funny_playFail()
    func funny_playEnd()
    func funny_updateStatus(current: Float64, load: Float64, total: Float64)
}

class FunnyVideoPlayer: NSObject {

    public weak var delegate: FunnyVideoPlayerProtocol?
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private var timer: Timer?
    private var avURL = ""
    private var backgroundPaused = false
    public var isPlaying: Bool {
        guard let player = player else { return false }
        return player.rate > 0
    }
    
    public func palyAV(_ videoURL: String, videoView: UIView) {
        guard let url = URL(string: videoURL) else {return}
        NotificationCenter.default.removeObserver(self)
        if player != nil {
            reset()
        }
        avURL = videoURL
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.backgroundColor = UIColor.black.cgColor
        playerLayer?.frame = videoView.bounds
        videoView.layer.addSublayer(playerLayer!)
        addObserver()
        player?.play()
    }
    
    public func pause() {
        player?.pause()
    }
    
    public func play() {
        player?.play()
    }
    
    public func reset() {
        timer?.invalidate()
        timer = nil
        NotificationCenter.default.removeObserver(self)
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            if player!.status == .readyToPlay {
                delegate?.funny_playBegin()
                startPlayVideo()
            } else if player!.status == .failed {
                delegate?.funny_playFail()
            }
            player?.removeObserver(self, forKeyPath: "status")
        }
    }
}

private extension FunnyVideoPlayer {
    func startPlayVideo() {
        timer?.invalidate()
        timer = nil
        timer = Timer.init(timeInterval: 1, repeats: true, block: { [weak self] (timer) in
            self?.updatePlayerStatus()
        })
        RunLoop.current.add(timer!, forMode: .commonModes)
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
        delegate?.funny_updateStatus(current: currentTime, load: loadTime, total: totalTime)
    }
}

//observer
private extension FunnyVideoPlayer {
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playAVEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func playAVEnd() {
        reset()
        delegate?.funny_playEnd()
    }
    
    @objc func didEnterBackground() {
        guard let player = player else { return }
        if player.rate > 0 {
            pause()
            backgroundPaused = true
        }
    }
    
    @objc func didBecomeActive() {
        if backgroundPaused {
            backgroundPaused = false
            play()
        }
    }
}
