//
//  NoteCell.swift
//  Funny
//
//  Created by yanzhen on 2018/5/4.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

protocol NoteCellProtocol: class {
    func closeNote(_ cell: UICollectionViewCell)
}

class NoteCell: UICollectionViewCell {
    public weak var delegate: NoteCellProtocol?
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var contentTextView: UITextView!
    @IBOutlet private weak var closeBtn: UIButton!
    public func configure(_ note: FunnyNote, edit: Bool) {
        closeBtn.isHidden = !edit
        contentTextView.text = note.content
        timeLabel.text = FSQLite.dateString(note.time)
    }
    
    @IBAction private func closeAction(_ sender: UIButton) {
        delegate?.closeNote(self)
    }
    
}
