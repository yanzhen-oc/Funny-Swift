//
//  FLivePlayViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/4/30.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

typealias LiveInfo = (imgUrl: String, flvUrl: String)

class FLivePlayViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private var lives = [LiveInfo]()
    private var playIndexPath = IndexPath(item: 0, section: 0)
    private var willDisIP = IndexPath(item: -1, section: 0)
    required init(_ lives: [LiveInfo], playIndexPath: IndexPath) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size
        super.init(collectionViewLayout: layout)
        self.lives += lives
        self.playIndexPath = playIndexPath
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        }
        collectionView?.isPagingEnabled = true
        collectionView?.register(UINib.init(nibName: "FLivePlayCell", bundle: nil), forCellWithReuseIdentifier: "FLivePlayCell")
        
        collectionView?.scrollToItem(at: playIndexPath, at: .top, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lives.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FLivePlayCell", for: indexPath) as! FLivePlayCell
        cell.configure(lives[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //播放点击进来那一个item
        if willDisIP.row == -1 && playIndexPath.row == indexPath.row {
            (cell as! FLivePlayCell).play(lives[indexPath.row].flvUrl)
            willDisIP = indexPath
        } else {
            willDisIP = indexPath
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //play结束
        if willDisIP.row == indexPath.row { return }
        (cell as! FLivePlayCell).endPlay()
    }
}

extension FLivePlayViewController {
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.y / FHEIGHT
        if Int(index) != willDisIP.item { return }
        if let cell = collectionView?.cellForItem(at: willDisIP) as? FLivePlayCell {
            cell.play(lives[willDisIP.row].flvUrl)
        }
    }
}
