//
//  ZJBaseViewController.swift
//  RefreshTest
//
//  Created by zxd on 2019/2/19.
//  Copyright © 2019 张江. All rights reserved.
//

import UIKit

class ZJBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBar()
    }

    func configNavigationBar() {
        guard let navi = navigationController else { return }
        if navi.visibleViewController == self {
            navi.barStyle(.theme)
            navi.disablePopGesture = false
            navi.setNavigationBarHidden(false, animated: true)
            if navi.viewControllers.count > 1 {
                let button = UIButton(type: .system)
                button.setImage(UIImage(named: "nav_back_white")?.withRenderingMode(.alwaysOriginal), for: .normal)
                button.imageEdgeInsets = .zero
                button.addTarget(self, action: #selector(pressBack), for: .touchUpInside)
                button.sizeToFit()
                if button.bounds.width < 40 || button.bounds.height > 40 {
                    let width = 40 / button.bounds.height * button.bounds.width;
                    button.bounds = CGRect(x: 0, y: 0, width: width, height: 40)
                }
                self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: button)
            }
        }
    }
    
    @objc func pressBack() {
        navigationController?.popViewController(animated: true)
    }

}

extension ZJBaseViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}
