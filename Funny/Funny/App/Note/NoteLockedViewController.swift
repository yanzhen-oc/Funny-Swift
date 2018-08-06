//
//  NoteLockedViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/5/1.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class NoteLockedViewController: FSViewController {

    @IBOutlet private weak var lockedView: YZLockedView!
    override func viewDidLoad() {
        super.viewDidLoad()

        lockedView.delegate = self
        FunnyManager.authentication(failed: nil) { [weak self] in
            self?.showNote()
        }
    }
    
    private func showNote() {
        performSegue(withIdentifier: "NoteShow", sender: nil)
    }
}

extension NoteLockedViewController: YZLockedViewDelegate {
    func passwordIsRight(password: String) -> Bool {
        if password == "1234" || password == "5250" {
            showNote()
            return true
        }
        return false
    }
}
