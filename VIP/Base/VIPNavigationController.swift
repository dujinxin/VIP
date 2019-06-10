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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.isTranslucent = false
        self.navigationBar.barStyle = .default      //状态栏 黑色
        
    }
    // 重写这两个方法
    override var childForStatusBarHidden: UIViewController? {
        return self.visibleViewController
    }

    override var childForStatusBarStyle: UIViewController? {
        return self.visibleViewController
    }
}
