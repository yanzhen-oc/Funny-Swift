//
//  MeipaiViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/5/4.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
import LFLiveKit

private let MPSETHEIGHT: CGFloat = 100

class MeipaiViewController: FSViewController {

    private var session: LFLiveSession!
    @IBOutlet weak var photoView: UIImageView!
    private lazy var settingView: MeipaiSettingView = { 
        let settingView = MeipaiSettingView(frame: CGRect(x: 0, y: -MPSETHEIGHT, width: self.view.width, height: MPSETHEIGHT))
        settingView.delegate = self
        self.view.addSubview(settingView)
        return settingView
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        session = LFLiveSession(audioConfiguration: LFLiveAudioConfiguration.default(), videoConfiguration: LFLiveVideoConfiguration.defaultConfiguration(for: .medium3))
        session.showDebugInfo = false
        session.preView = photoView
        session.beautyLevel = 0.5
        session.brightLevel = 0.5
        session.running = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
        
    }

    @IBAction func switchCamera(_ sender: Any) {
        if session.captureDevicePosition == .front {
            session.captureDevicePosition = .back
        }else{
            session.captureDevicePosition = .front
        }
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        let image = photoView.snapshotScreenInView()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func close(_ sender: Any) {
        session.running = false
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0.25) {
            var frame = self.settingView.frame
            if frame.origin.y == 0 {
                frame.origin.y = -MPSETHEIGHT
            }else{
                frame.origin.y = 0
            }
            self.settingView.frame = frame
        }
    }
}

extension MeipaiViewController: MeipaiSettingViewProtocol {
    func beautyValueChanged(value: CGFloat) {
        session.beautyLevel = value
    }
    
    func brightValueChanged(value: CGFloat) {
        session.brightLevel = value
    }
}

private extension MeipaiViewController {
    @objc func didEnterBackground() {
        session.running = false
    }
    
    @objc func didBecomeActive() {
        session.running = true
    }
    
    @objc func image(_ image: UIImage,didFinishSavingWithError error: NSError?, contextInfo: AnyObject){
        if error != nil {
            showToast("保存失败")
        } else {
            showToast("保存成功")
        }
    }
}
