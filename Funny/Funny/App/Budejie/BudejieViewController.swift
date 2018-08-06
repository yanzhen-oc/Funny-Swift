//
//  BudejieViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/4/30.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class BudejieViewController: FSViewController {

    private var videoVC: FVideoPlayViewController?
    private var videos = [BudejieVideo]()
    private var maxtime = ""
    private var refresh = false
    @IBOutlet private weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = FunnyWaterfallLayout(2)
        layout.delegate = self
        collectionView.collectionViewLayout = layout
        self.refresh(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        videoVC = nil
    }
    
    private func refresh(_ header: Bool) {
        FunnyHttpTool.get(.Budejie, parameters: ["maxtime" : maxtime]) { (response) in
            if let result = response.value {
                let list = result["list"] as! Array<[String : Any]>
                let info = result["info"] as! [String : Any]
                let maxtime = info["maxtime"] as! String
                self.refresh = false
                if self.maxtime == maxtime {
                    return
                }
                self.maxtime = maxtime
                let newList = list.map({BudejieVideo($0)})
                self.videoVC?.showMoreVideo(newList.map {VideoInfo($0.bimageuri, $0.videouri)} )
                self.videos += newList
                self.collectionView.reloadData()
            } else {
                YZLog(response.error!.localizedDescription)
            }
        }
    }

}

extension BudejieViewController: FunnyWaterfallLayoutProtocol, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout waterfallLayout: FunnyWaterfallLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let video = videos[indexPath.row]
        let width = collectionView.bounds.size.width / 2 - 0.5
        var ratio = atof(video.height) / atof(video.width)
        ratio = ratio > 1 ? ratio : 1
        return CGSize(width: width, height: width * CGFloat(ratio))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BudejieCell", for: indexPath) as! BudejieCell
        cell.configure(videos[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        var rect = collectionView.convert(cell!.frame, to: collectionView.superview)
        rect.origin.y += 64
        let videoInfos = videos.map({VideoInfo($0.bimageuri, $0.videouri)})
        videoVC = FVideoPlayViewController(videoInfos, playIndexPath: indexPath, frame: rect)
        videoVC?.delegate = self
        navigationController?.pushViewController(videoVC!, animated: false)
    }
    
}

extension BudejieViewController: FVideoPlayVCProtocol {
    func getMoreVideoData() {
        refresh(false)
    }
}

extension BudejieViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if refresh { return }
        let offsetY = scrollView.contentOffset.y
        if (offsetY + FHEIGHT) / scrollView.contentSize.height > 0.6 {
            refresh = true
            refresh(false)
        }
    }
}
