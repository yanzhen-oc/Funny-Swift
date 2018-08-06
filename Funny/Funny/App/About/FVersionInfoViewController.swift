//
//  FVersionInfoViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/5/7.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class FVersionInfoViewController: UIViewController {

    @IBOutlet private weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.text = "[1.0.0] 基于Swift4.1\n[1.0.1] AVPlayer.TimeObserver"
    }
    
    override var previewActionItems: [UIPreviewActionItem] {
        get{
            let action = UIPreviewAction(title: "取消", style: .default) { (previewAction, vc) in
                
            }
            return [action]
        }
    }
}
