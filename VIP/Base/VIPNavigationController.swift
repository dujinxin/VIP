//
//  VIPNavigationController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

class VIPNavigationController: JXNavigationController {

    override func awakeFromNib() {
        super.awakeFromNib()
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
//        self.navigationBar.isTranslucent = false
//        self.navigationBar.barStyle = .default      //状态栏 黑色
    }
    // 重写这两个方法
    override var childForStatusBarHidden: UIViewController? {
        return self.topViewController
    }
    override var childForStatusBarStyle: UIViewController? {
        return self.topViewController
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.visibleViewController!.preferredStatusBarStyle
    }
    override var prefersStatusBarHidden: Bool {
        return self.visibleViewController!.prefersStatusBarHidden
    }
}
