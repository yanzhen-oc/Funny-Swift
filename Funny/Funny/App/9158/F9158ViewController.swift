//
//  F9158ViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/4/19.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class F9158ViewController: FSViewController {
    private var page = 1
    private var lives = [F9158Live]()
    @IBOutlet private weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //for ios10.0
//        automaticallyAdjustsScrollViewInsets = false
        tableView.yz_header = FunnyRefreshHeader({ [weak self] in
            self?.page = 1
            self?.refresh()
        })
        tableView.yz_footer = FunnyRefreshFooter({ [weak self] in
            self?.page += 1
            self?.refresh()
        })
        tableView.yz_header?.beginRefreshing()
    }

    private func refresh() {
        FunnyHttpTool.get(.F9158, parameters: ["page" : page]) { (result) in
            if let response = result.value {
                let data = response["data"] as! [String : Any]
                let list = data["list"] as! Array<[String : Any]>
                if self.page == 1 {
                    self.lives.removeAll()
                }
                self.lives += list.map {F9158Live($0)}
                self.tableView.yz_header?.endRefreshing()
                self.tableView.yz_footer?.endRefreshing()
                self.tableView.reloadData()
            } else {
                self.showToast(result.error!.localizedDescription)
            }
        }
    }
}

extension F9158ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lives.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "F9158TableViewCell", for: indexPath) as! F9158TableViewCell
        cell.configure(lives[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let liveInfos = lives.map({LiveInfo($0.bigpic, $0.flv)})
        let liveVC = FLivePlayViewController(liveInfos, playIndexPath: indexPath)
        navigationController?.pushViewController(liveVC, animated: true)
    }
}
