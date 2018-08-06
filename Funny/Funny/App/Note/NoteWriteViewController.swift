//
//  NoteWriteViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/5/4.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class NoteWriteViewController: UIViewController {

    public var note: FunnyNote?
    public weak var addVc: NoteAddViewController!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet private weak var textBottomConstraint: NSLayoutConstraint!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "笔记"
        textView.text = note?.content
        textView.becomeFirstResponder()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: .plain, target: self, action: #selector(saveNote))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboartChanged(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboartChanged(_:)), name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboartChanged(_:)), name: .UIKeyboardDidChangeFrame, object: nil)
    }

    @objc private func keyboartChanged(_ note: Notification) {
        let keyboardFrame = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: 0.25) {
            self.textBottomConstraint.constant = FHEIGHT - keyboardFrame.origin.y
        }
    }
    
    @objc private func saveNote() {
        if textView.text.isEmpty {
            let alert = UIAlertController(title: "提示", message: "输入内容为空，请重新输入", preferredStyle: .alert)
            let action = UIAlertAction(title: "确定", style: .default, handler: { (action) in
                
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        if note != nil {
            note?.content = textView.text
            FSQLite.update(note!)
            addVc.addNewNote(false, note: nil)
        } else {
            note = FunnyNote()
            note?.time = Int64(Date().timeIntervalSince1970)
            note?.content = textView.text
            FSQLite.insert(note!)
            addVc.addNewNote(true, note: note)
        }
        navigationController?.popViewController(animated: true)
    }
}
