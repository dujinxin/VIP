//
//  VIPFindViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import MJRefresh

class VIPFindViewController: VIPTableViewController{
    
    var vm = VIPFindVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedString(key: "Find")
        
        self.view.backgroundColor = JXFfffffColor
        
        self.tableView.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kTabBarHeight - kNavStatusHeight)
        self.tableView.register(UINib(nibName: "VIPMyListCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCell")
        self.tableView.register(UINib(nibName: "VIPFindHeadCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierHeader")
        self.tableView.estimatedRowHeight = 64
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestData()
        })
        self.tableView.mj_header.beginRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func requestData() {
        self.vm.find { (data, msg, isSuccess) in
            self.tableView.mj_header.endRefreshing()
            if isSuccess == true {
                self.tableView.reloadData()
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierHeader", for: indexPath) as! VIPFindHeadCell
            let imagesURLStrings = [
                "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
            ];
            cell.cycleScrollView.currentPageDotColor = JXBlueColor
            cell.cycleScrollView.imageURLStringsGroup = self.vm.findEntity.imageList
            cell.bannerBlock = { index in
                let entity = self.vm.findEntity.list[index]
                
                if let s = entity.click, s.hasPrefix("http") == true {
                    let vc = VIPWebViewController()
                    //vc.title = entity.title_zh//self.homeVM.homeEntity.notice.title
                    vc.urlStr = entity.click
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
            cell.financialBlock = {
                let storyboard = UIStoryboard(name: "Find", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "financialManagement") as! VIPFinancialManagementController
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.developBlock = {
                ViewManager.showNotice("待开发中，敬请期待")
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierCell", for: indexPath) as! VIPMyListCell
//            let dict = actionArray[indexPath.section - 1][indexPath.row]
//
//            cell.iconView.image = UIImage(named: dict["image"]!)
//            cell.titleView.text = LocalizedString(key: dict["title"] ?? "")
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
