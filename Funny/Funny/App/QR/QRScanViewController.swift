//
//  QRScanViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/5/4.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class QRScanViewController: UIViewController {
    
    @IBOutlet private weak var openUrlBtn: UIButton!
    @IBOutlet private weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    public func scanningDone(_ result: String) {
        textView.isHidden = false
        textView.text = result
        openUrlBtn.isHidden = !result.isURL
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier, id == "Scanning" else {
            return
        }
        let destination = segue.destination as! UINavigationController
        let d = destination.topViewController as! QRScanningViewController
        d.scanVC = self
    }
    
    @IBAction private func openURL(_ sender: Any) {
        if textView.text.isEmpty { return }
        UIApplication.shared.open(URL(string: textView.text)!, options: [:], completionHandler: nil)
    }

}
