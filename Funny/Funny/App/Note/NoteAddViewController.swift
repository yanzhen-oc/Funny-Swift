//
//  NoteAddViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/5/1.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class NoteAddViewController: UIViewController {

    private var notes = [FunnyNote]()
    private var editBtn: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "备忘录"
        notes += FSQLite.allNote()
        editBtn = UIButton(type: .custom)
        editBtn.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        editBtn.setTitle("编辑", for: .normal)
        editBtn.setTitle("完成", for: .selected)
        editBtn.setTitleColor(UIColor(255, 133, 25), for: .normal)
        editBtn.addTarget(self, action: #selector(editNote), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editBtn)
    }
    
    public func addNewNote(_ add: Bool, note: FunnyNote?) {
        if add {
            notes.append(note!)
        }
        collectionView.reloadData()
    }
    
    @IBAction private func addNote(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Note", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NewNote") as! NoteWriteViewController
        vc.addVc = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func editNote() {
        if notes.isEmpty { return }
        editBtn.isSelected = !editBtn.isSelected
        collectionView.reloadData()
    }
}

extension NoteAddViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoteCell", for: indexPath) as! NoteCell
        cell.configure(notes[indexPath.row], edit: editBtn.isSelected)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !editBtn.isSelected {
            let storyboard = UIStoryboard(name: "Note", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "NewNote") as! NoteWriteViewController
            vc.note = notes[indexPath.row]
            vc.addVc = self
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (FWIDTH - 15) * 0.5, height: 170)
    }
}

extension NoteAddViewController: NoteCellProtocol {
    func closeNote(_ cell: UICollectionViewCell) {
        let indexPath = collectionView.indexPath(for: cell)
        let note = notes[indexPath!.item]
        FSQLite.delete(note)
        notes.remove(at: indexPath!.row)
        collectionView.reloadData()
    }
}
