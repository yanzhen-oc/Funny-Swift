//
//  FHotsoonViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/4/21.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class FHotsoonViewController: FSViewController {

    private var hotsoonVC: FHotsoonPageViewController?
    private var titleView: FHotsoonTopView!
    @IBOutlet private weak var topView: UIVisualEffectView!
    override func viewDidLoad() {
        super.viewDidLoad()

        titleView = FHotsoonTopView(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
        titleView.center = CGPoint(x: topView.width / 2, y: 22)
        titleView.delegate = self
        topView.contentView.addSubview(titleView)
    }

    public func scrollToTopView(_ index: Int) {
        titleView.scrollToTopView(index)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let id = segue.identifier, id == "Hotsoon" else {
            return
        }
        hotsoonVC = segue.destination as? FHotsoonPageViewController
        hotsoonVC?.superVC = self
    }
}

extension FHotsoonViewController: HotsoonTopViewProtocol {
    func topViewSelected(_ index: Int) {
        hotsoonVC?.topViewSelected(index)
    }
}
