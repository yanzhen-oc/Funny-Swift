//
//  FHotsoonVideoViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/4/21.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class FHotsoonVideoViewController: UICollectionViewController {

    private var videoVC: FVideoPlayViewController?
    private var videos = [HotsoonVideo]()
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = UIScreen.main.bounds.size.width
        let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.itemSize = CGSize(width: width / 2, height: width * 2 / 3)
        collectionView?.yz_header = FunnyRefreshHeader({ [weak self] in
            self?.refresh(true)
        })
        collectionView?.yz_header?.beginRefreshing()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoVC = nil
    }
    
    public func refresh(_ new: Bool) {
        FunnyHttpTool.get(.Hotsoon(.Video)) { (result) in
            if let response = result.value {
                let data = response["data"] as! Array<[String : Any]>
                if new {
                    self.videos.removeAll()
                }
                let newVideos = data.map({HotsoonVideo($0["data"] as! [String : Any])})
                let videoInfos = newVideos.map { (video) -> VideoInfo in
                    let url_list = video.author.avatar_jpg["url_list"] as! [String]
                    return (url_list[0], video.video.url_list[0])
                }
                self.videoVC?.showMoreVideo(videoInfos)
                self.videos.append(contentsOf: newVideos)
                self.collectionView?.yz_header?.endRefreshing()
                self.collectionView?.reloadData()
            } else {
                YZLog(result.error!.localizedDescription)
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HotsoonVideoCell", for: indexPath) as! HotsoonVideoCell
        cell.configrure(videos[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        var rect = collectionView.convert(cell!.frame, to: collectionView.superview)
        rect.origin.y += 64
        let videoInfos = videos.map { (video) -> VideoInfo in
            let url_list = video.author.avatar_jpg["url_list"] as! [String]
            return (url_list[0], video.video.url_list[0])
        }
        videoVC = FVideoPlayViewController(videoInfos, playIndexPath: indexPath, frame: rect)
        videoVC?.delegate = self
        navigationController?.pushViewController(videoVC!, animated: false)
    }

}

extension FHotsoonVideoViewController: FVideoPlayVCProtocol {
    func getMoreVideoData() {
        refresh(false)
    }
}

extension FHotsoonVideoViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if (offsetY + FHEIGHT) / scrollView.contentSize.height > 0.6 {
            refresh(false)
        }
    }
}
