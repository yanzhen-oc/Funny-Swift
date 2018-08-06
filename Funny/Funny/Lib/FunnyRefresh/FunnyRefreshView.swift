//
//  FunnyRefreshView.swift
//  test
//
//  Created by yanzhen on 2018/4/16.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

enum FunnyRefreshType: CGFloat {
    case Header = -1
    case Footer = 1
}

enum FunnyRefreshState {
    case Normal
    case Pulling
    case Refreshing
    case WillRefreshing
}

private let GIFWIDTH: CGFloat = 31.5
private let GIFHEIGHT: CGFloat = 42.5
public let FRHEIGHT: CGFloat = 64

class FunnyRefreshView: UIView {

    public var refreshType: FunnyRefreshType {
        get {
            return .Header
        }
    }
    public var initInset = UIEdgeInsets.zero
    public weak var scrollView: UIScrollView!
    private var state = FunnyRefreshState.Normal
    private var refreshBlock: (() -> Void)?
    private var gifImgView = UIImageView()
    private var gifDefault = "meituan_1"
    private var gifWill = "meituan_1"
    init(_ block: (() -> Void)?) {
        super.init(frame: CGRect.zero)
        refreshBlock = block
        autoresizingMask = [.flexibleWidth]
        backgroundColor = UIColor.clear
        gifImgView.frame = CGRect(x: 0, y: 0, width: GIFWIDTH, height: GIFHEIGHT)
        gifImgView.contentMode = .scaleAspectFill
        gifImgView.image = UIImage(named: gifDefault)
        addSubview(gifImgView)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        superview?.removeObserver(self, forKeyPath: "contentOffset", context: nil)
        guard let newView = newSuperview else { return }
        scrollView = newView as! UIScrollView
        initInset = scrollView.yz_inset
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
        let originY = refreshType == .Header ? -FRHEIGHT : scrollView.frame.size.height - 64
        frame = CGRect(x: 0, y: originY, width: scrollView.frame.size.width, height: FRHEIGHT)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath! != "contentOffset" || state == .Refreshing { return }
        if state != .Refreshing {//保证footer在取initInset时候top正确
            initInset = scrollView.yz_inset
        }
        if scrollView.isDragging {
            let offsetY = scrollView.contentOffset.y * refreshType.rawValue
            let calOffset = FRHEIGHT + getRefreshY()
            if state == .Normal && offsetY >= calOffset {
                setRefreshState(.Pulling)
            } else if state == .Pulling && offsetY < calOffset {
                setRefreshState(.Normal)
            }
        } else {
            if state == .Pulling {
                setRefreshState(.Refreshing)
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if state == .WillRefreshing {
            setRefreshState(.Refreshing)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gifImgView.center = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getRefreshY() -> CGFloat {
        return 0
    }
    
    public func keepAnimation() {}
    public func backToIdentity() {}
}

extension FunnyRefreshView {
    public func beginRefreshing() {
        if state == .Refreshing { return }
        if self.window != nil {
            setRefreshState(.Refreshing)
            return
        }
        /*在viewDidLoad直接使用beginRefresh，window==nil
        下面保证渲染成功，否则iOS11时，scrollView.adjustedContentInset.top此时=0
         渲染成功之后，获取调整成功的adjustedContentInset
        */
        setRefreshState(.WillRefreshing)
        setNeedsDisplay()
    }
    
    public func endRefreshing() {
        setRefreshState(.Normal)
    }
}

private extension FunnyRefreshView {
    func setRefreshState(_ newState: FunnyRefreshState) {
        if state == newState { return }
        state = newState
        if state == .Normal {
            if gifImgView.isAnimating {
                gifImgView.stopAnimating()
            }
            backToIdentity()
        }else if state == .WillRefreshing {
            gifImgView.image = UIImage(named: gifWill)
        }else if state == .Refreshing {
            gifImgView.animationImages = [1, 2, 3, 4].map({ UIImage(named: "meituan_" + $0.description)! })
            gifImgView.animationDuration = 0.5
            gifImgView.startAnimating()
            keepAnimation()
            refreshBlock?()
        }
    }
}
