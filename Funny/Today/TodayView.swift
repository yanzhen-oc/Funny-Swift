//
//  TodayView.swift
//  Today
//
//  Created by yanzhen on 2018/5/5.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

private let CIRCLEWH: CGFloat = 90

class TodayView: UIView {

    private var progressLayer: CAShapeLayer!
    @IBOutlet private var backgroundView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibView()
        configureLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibView()
        configureLayer()
    }
}

extension TodayView {
    public func setProgress(_ progress: CGFloat, subTitle: String?) {
        subTitleLabel.text = subTitle
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn))
        CATransaction.setAnimationDuration(1.0)
        var strokeEnd = progress < 0.0 ? 0.0 : progress
        strokeEnd = progress > 1.0 ? 1.0 : progress
        progressLayer.strokeEnd = strokeEnd
        CATransaction.commit()
    }
    
    public func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    public func configure(_ info: (String, String)) {
        titleLabel.text = info.0
        subTitleLabel.text = info.1
    }
}

private extension TodayView {
    func loadNibView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "TodayView", bundle: bundle)
        backgroundView = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        backgroundView.frame = bounds
        backgroundView.backgroundColor = UIColor.clear
        addSubview(backgroundView)
        backgroundColor = UIColor.clear
        clipsToBounds = true
    }
    
    func configureLayer() {
        let circleLayer = CAShapeLayer()
        circleLayer.frame = bounds
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.gray.cgColor
        circleLayer.opacity = 0.25
        circleLayer.lineCap = kCALineCapRound
        circleLayer.lineWidth = 2
        let radius = (CIRCLEWH - 5) / 2
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: CIRCLEWH / 2, y: CIRCLEWH / 2), radius: radius, startAngle: -CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi/2) * 3, clockwise: true)
        circleLayer.path = circlePath.cgPath
        layer.addSublayer(circleLayer)
        
        progressLayer = CAShapeLayer()
        progressLayer.frame = bounds
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = UIColor(displayP3Red: 1.0, green: 133/255.0, blue: 25/255.0, alpha: 1.0).cgColor
        progressLayer.lineCap = kCAFillRuleNonZero
        progressLayer.strokeEnd = 0.0
        progressLayer.lineWidth = 2
        let progressPath = UIBezierPath(arcCenter: CGPoint(x: CIRCLEWH * 0.5, y: CIRCLEWH * 0.5), radius: radius, startAngle: -CGFloat(Double.pi/2), endAngle: CGFloat(Double.pi/2) * 3 , clockwise: true)
        progressLayer.path = progressPath.cgPath
        layer.addSublayer(progressLayer)
    }
}
