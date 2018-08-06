//
//  QRViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/5/4.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class QRViewController: FSViewController {

    @IBOutlet private weak var scanView: UIView!
    @IBOutlet private weak var makeView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction private func segmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 0.15, animations: {
                self.scanView.alpha = 0
            }, completion: { (finished) in
                self.makeView.alpha = 1
            })
        }else{
            UIView.animate(withDuration: 0.15, animations: {
                self.makeView.alpha = 0
            }, completion: { (finished) in
                self.scanView.alpha = 1
            })
        }
    }
}
