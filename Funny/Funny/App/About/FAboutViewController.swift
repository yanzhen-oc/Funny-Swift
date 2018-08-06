//
//  FAboutViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/5/7.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class FAboutViewController: UITableViewController {

    private var headImageView: UIImageView!
    private let dataSource = ["清除缓存","设置","声明","关于"]
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我的"
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(#imageLiteral(resourceName: "clear"), for: .default)
        self.navigationController?.navigationBar.shadowImage = #imageLiteral(resourceName: "clear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "FAboutViewController")
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "FAboutViewController")
            cell?.accessoryType = .disclosureIndicator
            cell?.detailTextLabel?.textColor = UIColor(255, 133, 25)
        }
        if indexPath.row == 0 {
            FunnyManager.getDiskCacheSize(handler: { (size) in
                cell?.detailTextLabel?.text = String(format: "%.2fMB", CGFloat(size) / 1000 / 1000.0)
            })
        }
        cell?.textLabel?.text = dataSource[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            FunnyManager.clearDisk({
                tableView.reloadData()
            })
        }else if indexPath.row == 1 {
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        }else if indexPath.row == 2 {
            performSegue(withIdentifier: "Declaration", sender: nil)
        }else {
            performSegue(withIdentifier: "AboutAbout", sender: nil)
        }
        
    }

}

extension FAboutViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0 {
            let scale = 1 - offsetY / 290
            headImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
            var rect = headImageView.frame
            rect.origin.y = offsetY
            headImageView.frame = rect
        }
    }
}

private extension FAboutViewController {
    func configureUI() {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: FWIDTH, height: 290))
        headImageView = UIImageView(frame: headView.bounds)
        headImageView.contentMode = .scaleAspectFill
        headImageView.clipsToBounds = true
        headImageView.image = #imageLiteral(resourceName: "Ais")
        headView.addSubview(headImageView)
        tableView.tableHeaderView = headView
        
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: FWIDTH, height: 60))
        footerView.backgroundColor = UIColor.clear
        
        let exitBtn = UIButton(frame: CGRect(x: 0, y: 10, width: FWIDTH, height: 50))
        exitBtn.backgroundColor = UIColor.white
        exitBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        exitBtn.setTitle("退出", for: .normal)
        exitBtn.setTitleColor(UIColor(255, 133, 25), for: .normal)
        exitBtn.addTarget(self, action: #selector(exitVC), for: .touchUpInside)
        footerView.addSubview(exitBtn)
        tableView.tableFooterView = footerView
    }
    
    @objc func exitVC() {
        exit(0)
    }
}
