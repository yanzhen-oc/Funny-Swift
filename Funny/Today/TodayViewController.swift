//
//  TodayViewController.swift
//  Today
//
//  Created by yanzhen on 2018/5/4.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit
import NotificationCenter
import YZIPhoneDevice

typealias TodayInfo = (String, String, Int32)

class TodayViewController: UIViewController, NCWidgetProviding {
    
    private var timer: Timer?
    private var cpu: YZCPU!
    private var network: YZNetwork!
    @IBOutlet private weak var cpuView: TodayView!
    @IBOutlet private weak var memoryView: TodayView!
    @IBOutlet private weak var netWorkView: TodayView!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var apps = [TodayInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        let maximumSize = extensionContext?.widgetMaximumSize(for: .expanded)
        layout.itemSize = CGSize(width: (maximumSize!.width - 50) / 4, height: 110)
        apps.append(("9158", "9158", 500))
        apps.append(("快手", "gifshow", 502))
        apps.append(("记事本", "note", 505))
        apps.append(("美拍", "meipai", 507))
        //
        cpuView.configure(("CPU", "0.0%"))
        memoryView.configure(("内存", "0G/0G"))
        netWorkView.configure(("无网络", "0B/s"))
        
        cpu = YZCPU()
        cpu.startMonitorCPUUsage(withTimeInterval: 1.0) { [weak self] (usage) in
            let subTitle = String(format: "%.1f", usage * 100) + "%"
            self?.cpuView.setProgress(usage, subTitle: subTitle)
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] (timer) in
            let availableSize = YZDevice.getAvailableDiskSize()
            let totalSize = YZDevice.getTotalDiskSize()
            let subTitle = String(format: "%.1fG/%.1fG", CGFloat(availableSize) / 1024.0 / 1024 / 1024,CGFloat(totalSize) / 1024.0 / 1024 / 1024)
            self?.memoryView.setProgress(1 - CGFloat(availableSize) / CGFloat(totalSize), subTitle: subTitle)
        })
        RunLoop.current.add(timer!, forMode: .commonModes)
        
        network = YZNetwork()
        network.getCurrentNetSpeed { [weak self] (netWorkFlux) in
            let titles = ["无网络","Wifi","4G","3G","2G"]
            self?.netWorkView.setTitle(titles[Int(netWorkFlux!.netStatus.rawValue)])
            self?.netWorkView.setProgress(0, subTitle: self?.stringFromBytes(received: netWorkFlux!.received))
        }
        
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let height: CGFloat = activeDisplayMode == .compact ? 110 : 220
        preferredContentSize = CGSize(width: 0, height: height)
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
}

private extension TodayViewController {
    private func stringFromBytes(received: Float) ->String {
        let KB: Float = 1024.0;
        let MB = KB * 1024;
        let GB = MB * 1024;
        var speed = "0B/s";
        
        if received >= GB {
            speed = String(format: "%.1fG/s", received / GB);
        }else if received >= MB {
            speed = String(format: "%.1fM/s", received / MB);
        }else if received >= KB {
            speed = String(format: "%.1fKB/s", received / KB);
        }else{
            speed = String(format: "%.0fB/s", received);
        }
        return speed;
    }
}

extension TodayViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodayCell", for: indexPath) as! TodayCell
        cell.configure(apps[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = URL(string: "Funny://" + apps[indexPath.row].2.description);
        extensionContext?.open(url!, completionHandler: nil)
    }
}
