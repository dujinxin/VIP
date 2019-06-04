//
//  VIPCommunityViewController.swift
//  VIP
//
//  Created by 飞亦 on 6/4/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import MJRefresh

class VIPCommunityViewController: VIPTableViewController{
    
    var vm = VIPNotificationVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        self.tableView.register(UINib(nibName: "VIPCommunityHeadCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierHeadCell")
        self.tableView.register(UINib(nibName: "VIPCommunityListCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierListCell")
        
        self.tableView.estimatedRowHeight = 140
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        
//        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//            self.page = 1
//            self.request(page: 1)
//        })
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.page += 1
            self.request(page: self.page)
        })
        self.request(page: 1)
        //self.tableView.mj_header.beginRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func request(page: Int) {
        
        self.vm.noticeList(page: self.page) { (_, msg, isSuc) in
            //self.hideMBProgressHUD()
            //self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.noticeListEntity.list.count  + 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierHeadCell", for: indexPath) as! VIPCommunityHeadCell
//            let entity = self.vm.noticeListEntity.list[indexPath.row]
//            cell.titleLabel.text = entity.title_zh
//            cell.contentLabel.text = entity.content_zh
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierListCell", for: indexPath) as! VIPCommunityListCell
//            let entity = self.vm.noticeListEntity.list[indexPath.row]
//            cell.titleLabel.text = entity.title_zh
//            cell.contentLabel.text = entity.content_zh
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "My", bundle: nil)
        let entity = self.vm.noticeListEntity.list[indexPath.row]
        
        let vc = storyboard.instantiateViewController(withIdentifier: "export") as! VIPExportViewController
        vc.title = entity.title_zh
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
