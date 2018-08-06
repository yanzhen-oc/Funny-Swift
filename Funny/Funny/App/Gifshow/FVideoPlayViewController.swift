//
//  FVideoPlayViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/4/30.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

protocol FVideoPlayVCProtocol: class {
    func getMoreVideoData()
}

typealias VideoInfo = (imgUrl: String, videoUrl: String)

class FVideoPlayViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    public weak var delegate: FVideoPlayVCProtocol?
    private var videos = [VideoInfo]()
    private var refreshing = false
    private var reloadData = false
    private var originFrame: CGRect = .zero
    private var playIndexPath = IndexPath(item: 0, section: 0)
    private var willDisIP = IndexPath(item: -1, section: 0)
    required init(_ videos: [VideoInfo], playIndexPath: IndexPath, frame: CGRect) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size
        super.init(collectionViewLayout: layout)
        self.videos += videos
        self.playIndexPath = playIndexPath
        self.originFrame = frame
    }
    
    public func showMoreVideo(_ videos: [VideoInfo]) {
        self.videos += videos
        reloadData = true
        print("video more", self.videos.count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            collectionView?.contentInsetAdjustmentBehavior = .never
        }
        collectionView?.isPagingEnabled = true
        collectionView?.register(UINib.init(nibName: "FVideoPlayCell", bundle: nil), forCellWithReuseIdentifier: "FVideoPlayCell")
        
        collectionView?.scrollToItem(at: playIndexPath, at: .top, animated: false)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FVideoPlayCell", for: indexPath) as! FVideoPlayCell
        cell.configure(videos[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //播放点击进来那一个item
        if willDisIP.row == -1 && playIndexPath.row == indexPath.row {
            (cell as! FVideoPlayCell).animate(originFrame)
            willDisIP = indexPath
        } else {
            willDisIP = indexPath
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if willDisIP.row == indexPath.row { return }
        (cell as! FVideoPlayCell).playEnd()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FVideoPlayViewController {
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = scrollView.contentOffset.y / FHEIGHT
        if Int(index) != willDisIP.item { return }
        let cell = collectionView?.cellForItem(at: willDisIP) as? FVideoPlayCell
        if cell == nil { return }
        if !reloadData {
            cell!.playVideo()
            return
        }
        reloadData = false
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
            //保证reloadData完成
            DispatchQueue.main.async {
                self.refreshing = false
                //reloadData完成cell发生变化
                if let playCell = self.collectionView?.cellForItem(at: self.willDisIP) as? FVideoPlayCell {
                    playCell.playVideo()
                }
            }
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if refreshing { return }
        let offsetY = scrollView.contentOffset.y
        if (offsetY + FHEIGHT) / scrollView.contentSize.height > 0.6 {
            refreshing = true
            delegate?.getMoreVideoData()
        }
    }
}
