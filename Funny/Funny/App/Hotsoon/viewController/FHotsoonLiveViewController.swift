//
//  FHotsoonLiveViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/4/21.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class FHotsoonLiveViewController: UITableViewController {

    private var lives = [HotsoonLive]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.yz_header = FunnyRefreshHeader({ [weak self] in
            self?.refresh(true)
        })
        tableView.yz_header?.beginRefreshing()
    }
    
    private func refresh(_ new: Bool) {
        FunnyHttpTool.get(.Hotsoon(.Live)) { (result) in
            if let response = result.value {
                let data = response["data"] as! Array<[String : Any]>
                if new {
                    self.lives.removeAll()
                }
                data.forEach {self.lives.append(HotsoonLive($0["data"] as! [String : Any]))}
                self.tableView.yz_header?.endRefreshing()
                self.tableView.reloadData()
            } else {
                YZLog(result.error!.localizedDescription)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lives.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HotsoonLiveCell", for: indexPath) as! HotsoonLiveCell
        cell.configure(lives[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let liveInfos = lives.map { (live) -> (String, String) in
            let url_list = live.owner.avatar_jpg["url_list"] as! [String]
            return (url_list[0], live.stream_url.rtmp_pull_url)
        }
        let liveVC = FLivePlayViewController(liveInfos, playIndexPath: indexPath)
        navigationController?.pushViewController(liveVC, animated: true)
    }
}

extension FHotsoonLiveViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if (offsetY + FHEIGHT) / scrollView.contentSize.height > 0.6 {
            refresh(false)
        }
    }
}
