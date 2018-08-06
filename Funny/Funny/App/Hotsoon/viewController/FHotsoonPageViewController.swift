//
//  FHotsoonPageViewController.swift
//  Funny
//
//  Created by yanzhen on 2018/4/21.
//  Copyright © 2018年 yanzhen. All rights reserved.
//

import UIKit

class FHotsoonPageViewController: UIPageViewController {

    public weak var superVC: FHotsoonViewController?
    private var vcs = [UIViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        dataSource = self
        let hotsoon = UIStoryboard.init(name: "Hotsoon", bundle: nil)
        let live = hotsoon.instantiateViewController(withIdentifier: "Live")
        let video = hotsoon.instantiateViewController(withIdentifier: "Video")
        vcs.append(live)
        vcs.append(video)
        setViewControllers([vcs[1]], direction: .reverse, animated: true, completion: nil)
    }
    
    public func topViewSelected(_ index: Int) {
        setViewControllers([vcs[index]], direction: .reverse, animated: false, completion: nil)
    }

}

extension FHotsoonPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = vcs.index(where: {viewController == $0}) else {
            return nil
        }
        return index == 0 ? nil : vcs[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = vcs.index(where: {viewController == $0}) else {
            return nil
        }
        return index == vcs.count - 1 ? nil : vcs[index + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if !completed { return }
        guard let index = vcs.index(where: {previousViewControllers[0] == $0}) else {
            return
        }
        superVC?.scrollToTopView(abs(index - 1))
    }
}
