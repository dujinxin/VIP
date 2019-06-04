//
//  VIPExRecordsViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/30/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import MJRefresh

private let reuseIdentifier = "reuseIdentifier"

class VIPExRecordsViewController: VIPTableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedString(key: "Home")
        
        
        self.tableView.separatorStyle = .none
        self.tableView.rowHeight = 135
        self.tableView.register(UINib(nibName: "VIPPropertyCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: 1)
        })
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.page += 1
            self.request(page: self.page)
        })
        //self.tableView.mj_header.beginRefreshing()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    override func request(page: Int) {
        self.tableView.mj_header.endRefreshing()
        self.tableView.mj_footer.endRefreshing()
        //        self.vm.buyList(payType: self.type, pageSize: 10, pageNo: page) { (_, msg, isSuc) in
        //            self.hideMBProgressHUD()
        //            self.collectionView?.mj_header.endRefreshing()
        //            self.collectionView?.mj_footer.endRefreshing()
        //            self.collectionView?.reloadData()
        //        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! VIPPropertyCell
        //cell.entity = self.vm.tradeDetailEntity
        //cell.setEntity(self.vm.tradeDetailEntity, type: self.type)
        return cell
        
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "exRecordsDetail") as! VIPExRecordsDetailController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
