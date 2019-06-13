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

    var entity : VIPCommunityModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        self.tableView.register(UINib(nibName: "VIPCommunityHeadCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierHeadCell")
        self.tableView.register(UINib(nibName: "VIPCommunityListCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierListCell")
        
//        self.tableView.estimatedRowHeight = 140
//        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
      
//        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//            self.page = 1
//            self.request(page: 1)
//        })
//        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
//            self.page += 1
//            self.request(page: self.page)
//        })
//        self.request(page: 1)
        //self.tableView.mj_header.beginRefreshing()
        
        
        if self.entity.list.count > 0 {
            self.tableView.isHidden = false
        } else {
//            self.tableView.isHidden = true
//            self.defaultView.backgroundColor = UIColor.clear
//            self.defaultView.subviews.forEach({ (v) in
//                v.backgroundColor = UIColor.clear
//                if let l = v as? UILabel {
//                    l.textColor = JXGrayTextColor
//                }
//            })
//            self.defaultInfo = ["imageName":"noneImage","content":"暂无相关数据"]
//            self.setUpDefaultView()
//
//            self.defaultView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - 244)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func request(page: Int) {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entity.list.count + 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierHeadCell", for: indexPath) as! VIPCommunityHeadCell
            cell.entity = self.entity.memberEntity
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierListCell", for: indexPath) as! VIPCommunityListCell
            let entity = self.entity.list[indexPath.row - 1]
            cell.entity = entity
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
