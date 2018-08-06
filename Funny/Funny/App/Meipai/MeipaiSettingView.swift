//
//  MeipaiSettingView.swift
//  Funny
//
//  Created by yanzhen on 2018/5/4.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

protocol MeipaiSettingViewProtocol : class {
    func beautyValueChanged(value: CGFloat)
    func brightValueChanged(value: CGFloat)
}

class MeipaiSettingView: UIView {

    public weak var delegate: MeipaiSettingViewProtocol?
    private var beautyLevel: UISlider!
    private var brightLevel: UISlider!
    override init(frame: CGRect) {
        super.init(frame: frame)
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        effectView.frame = self.bounds
        self.addSubview(effectView)
        
        beautyLevel = UISlider(frame: CGRect(x: 0, y: 20, width: frame.size.width, height: 30))
        beautyLevel.value = 0.5
        beautyLevel.setMinimumTrackImage(#imageLiteral(resourceName: "mp_slider_background"), for: .normal)
        beautyLevel.addTarget(self, action: #selector(beautyLevelValueChanged(_:)), for: .valueChanged)
        self.addSubview(beautyLevel)
        
        brightLevel = UISlider(frame: CGRect(x: 0, y: 60, width: frame.size.width, height: 30))
        brightLevel.value = 0.5
        brightLevel.setMinimumTrackImage(#imageLiteral(resourceName: "mp_slider_background"), for: .normal)
        brightLevel.addTarget(self, action: #selector(brightLevelValueChanged(_:)), for: .valueChanged)
        self.addSubview(brightLevel)
        
    }
    
    @objc func beautyLevelValueChanged(_ slider: UISlider) {
        delegate?.beautyValueChanged(value: CGFloat(slider.value))
    }
    
    @objc private func brightLevelValueChanged(_ slider: UISlider) {
        delegate?.brightValueChanged(value: CGFloat(slider.value))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
