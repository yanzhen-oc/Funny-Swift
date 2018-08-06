//
//  FVersionViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/5/7.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class FVersionViewController: UIViewController {

    @IBOutlet private weak var versionLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "关于"
        versionLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        registerForPreviewing(with: self, sourceView: view)
    }
}

extension FVersionViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let storyboard = UIStoryboard(name: "About", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "VersionInfo")
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: nil)
    }
    
    
}
