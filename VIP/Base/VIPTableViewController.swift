//
//  VIPTableViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation
import MJRefresh
import MBProgressHUD

class VIPTableViewController: JXTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = JXViewBgColor
        
        self.customNavigationBar.isTranslucent = true
        self.customNavigationBar.barStyle = .default
        self.customNavigationBar.tintColor = JXBlackTextColor //item图片文字颜色
        let font = UIFont(name: "PingFangSC-Semibold", size: 17) ?? UIFont.systemFont(ofSize: 17)
        self.customNavigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: JXBlackTextColor,NSAttributedString.Key.font:font]//标题设置
        self.customNavigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: UIBarMetrics.default)
        
        self.tableView.backgroundColor = UIColor.clear
        
    }
    

    open func showMBProgressHUD() {
        let _ = MBProgressHUD.showAdded(to: self.view, animated: true)
        //        hud.backgroundView.color = UIColor.black
        //        hud.contentColor = UIColor.black
        //        hud.bezelView.backgroundColor = UIColor.black
        //        hud.label.text = "加载中..."
        
    }
    open func hideMBProgressHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }

}
