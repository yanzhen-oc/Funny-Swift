//
//  FunnyVideoViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/4/14.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

private let AVDefault = ""

class FunnyVideoViewController: UIViewController {
    
    private var player: FunnyVideoPlayer!
    @IBOutlet private weak var pauseBtn: UIButton!
    @IBOutlet private weak var currentProgress: UIProgressView!
    @IBOutlet private weak var loadProgressView: UIProgressView!
    @IBOutlet private weak var effectView: UIVisualEffectView!
    @IBOutlet private weak var videoUrlTF: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置bar黑色，状态栏白色，第二个设置纯黑色
        //navigationController?.navigationBar.barStyle = .black
        //navigationController?.navigationBar.isTranslucent = false
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.gray]
        let attributedPlaceholder = NSAttributedString(string: "请输入视频地址", attributes: attributes)
        videoUrlTF.attributedPlaceholder = attributedPlaceholder
        videoUrlTF.text = AVDefault
        player = FunnyVideoPlayer()
        player.delegate = self
    }

    @IBAction func playVideo(_ sender: Any) {
        guard let url = videoUrlTF.text else {return}
        pauseBtn.isHidden = true
        currentProgress.setProgress(0, animated: false)
        loadProgressView.setProgress(0, animated: false)
        player.palyAV(url, videoView: effectView)
        FunnyHud.showHud(view, message: "正在加载")
    }
    
    @IBAction func end(_ sender: Any) {
        player.reset()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        sender.isHidden = true
        player.play()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if player.isPlaying {
            player.pause()
            pauseBtn.isHidden = false
        }
    }
    
}

extension FunnyVideoViewController: FunnyVideoPlayerProtocol {
    func funny_updateStatus(current: Float64, load: Float64, total: Float64) {
        loadProgressView.setProgress(Float(load / total), animated: true)
        currentProgress.setProgress(Float(current / total), animated: true)
    }
    
    func funny_playEnd() {
        currentProgress.setProgress(0, animated: false)
        loadProgressView.setProgress(0, animated: false)
        showToast("视频已结束")
    }
    
    func funny_playBegin() {
        FunnyHud.hideHud(for: effectView)
    }
    
    func funny_playFail() {
        FunnyHud.hideHud(for: effectView)
        showToast("加载失败")
    }
}
