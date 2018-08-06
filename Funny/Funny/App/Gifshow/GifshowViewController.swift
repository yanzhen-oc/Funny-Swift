//
//  GifshowViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/4/28.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class GifshowViewController: FSViewController {
    
    private var videoVC: FVideoPlayViewController?
    private var videos = [GifshowVideo]()
    private var refresh = false
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.alwaysBounceVertical = true
        self.collectionView.yz_header = FunnyRefreshHeader({ [weak self] in
            self?.refresh(true)
        })
        
        collectionView.yz_header?.beginRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoVC = nil
    }
    
    private func refresh(_ header: Bool) {
        FunnyHttpTool.post(.Gifshow) { (result) in
            if let response = result.value {
                let feeds = response["feeds"] as! Array<[String : Any]>
                if header {
                    self.videos.removeAll()
                    self.videos += feeds.map({GifshowVideo($0)})
                    self.collectionView.yz_header?.endRefreshing()
                } else {
                    let moreVideos = feeds.map {GifshowVideo($0)}
                    self.videos += moreVideos
                    self.videoVC?.showMoreVideo(moreVideos.map {VideoInfo($0.thumbnail_url, $0.main_mv_url)} )
                    self.collectionView.yz_footer?.endRefreshing()
                }
                self.refresh = false
                self.collectionView.reloadData()
            } else {
                YZLog(result.error!)
            }
        }
    }
}

extension GifshowViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GifshowCell", for: indexPath) as! GifshowCell
        cell.configure(videos[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width / 2 - 1
        return CGSize(width: width, height: width * 5 / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        var rect = collectionView.convert(cell!.frame, to: collectionView.superview)
        rect.origin.y += 64
        let videoInfos = videos.map({VideoInfo($0.thumbnail_url, $0.main_mv_url)})
        videoVC = FVideoPlayViewController(videoInfos, playIndexPath: indexPath, frame: rect)
        videoVC?.delegate = self
        navigationController?.pushViewController(videoVC!, animated: false)
    }
}

extension GifshowViewController: FVideoPlayVCProtocol {
    func getMoreVideoData() {
        refresh(false)
    }
}

extension GifshowViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if refresh { return }
        let offsetY = scrollView.contentOffset.y
        if (offsetY + FHEIGHT) / scrollView.contentSize.height > 0.6 {
            refresh = true
            refresh(false)
        }
    }
}
