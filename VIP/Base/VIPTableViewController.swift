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
        self.tableView.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
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
