//
//  FunnyLiveViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/4/14.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
import TTTPlayerKit

//rtmp://live.hkstv.hk.lxdns.com/live/hks
//http://hdl.9158.com/live/778c112ddd772ddbda16d8cc5408cdcf.flv
private let rtmpURL = "rtmp://live.hkstv.hk.lxdns.com/live/hks"

class FunnyLiveViewController: UIViewController {
    @IBOutlet private weak var rtmpPullUrlTF: UITextField!
    @IBOutlet private weak var effectView: UIVisualEffectView!
    private var player: TTTPlayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置bar黑色，状态栏白色，第二个设置纯黑色
        //navigationController?.navigationBar.barStyle = .black
        //navigationController?.navigationBar.isTranslucent = false
        let attributes = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor : UIColor.gray]
        let attributedPlaceholder = NSAttributedString(string: "请输入rtmp拉流地址", attributes: attributes)
        rtmpPullUrlTF.attributedPlaceholder = attributedPlaceholder
    }
    
    @IBAction func startPlay(_ sender: Any) {
        if rtmpPullUrlTF.text?.count == 0 {return}
        if let player = player, player.isPlaying { return }
        player = TTTPlayer.init(url: URL(string: rtmpPullUrlTF.text!), options: TTTPlayerOptions.default())
        player.delegate = self
        player.playerView?.frame = CGRect(x: 0, y: 0, width: FWIDTH, height: FHEIGHT - 64 - 44)
        view.addSubview(player.playerView!)
        player.play()
    }
    
    @IBAction func end(_ sender: UIBarButtonItem) {
        if let player = player {
            if player.isPlaying {
                player.stop()
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

extension FunnyLiveViewController: TTTPlayerDelegate {
    func player(_ player: TTTPlayer, statusDidChange playerStatus: TTTPlayerStatus) {
        print("1122" + playerStatus.rawValue.description)
    }

    func player(_ player: TTTPlayer, stoppedWithError error: Error?) {
        showToast(error?.localizedDescription ?? "error")
    }

    func player(_ player: TTTPlayer, statsInfo: TTTPlayerStatsInfo) {
        
    }

    func player(_ player: TTTPlayer, playbackH264SEI sei: String) {

    }

    func player(_ player: TTTPlayer, playbackVolInfo volInfo: [[AnyHashable : Any]]) {
        
    }
    
    func playerRenderOverlay(_ player: TTTPlayer) {

    }
}
