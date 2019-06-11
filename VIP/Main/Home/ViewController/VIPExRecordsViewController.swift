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
    
    var vm = VIPPropertyVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedString(key: "Home")
        
        
        self.tableView.separatorStyle = .none
        //self.tableView.rowHeight = 135
        self.tableView.register(UINib(nibName: "VIPExchangeListCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: 1)
        })
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.page += 1
            self.request(page: self.page)
        })
        self.tableView.mj_header.beginRefreshing()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    
    override func request(page: Int) {
        
        self.vm.exchangeList(page: page) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.tableView.reloadData()
            if isSuc == true && self.vm.exchangeListEntity.list.count > 0 {
                self.tableView.isHidden = false
            } else {
                
                self.defaultView.backgroundColor = UIColor.clear
                self.defaultView.subviews.forEach({ (v) in
                    v.backgroundColor = UIColor.clear
                    if let l = v as? UILabel {
                        l.textColor = JXGrayTextColor
                    }
                })
                self.defaultInfo = ["imageName":"noneImage","content":"暂无相关数据"]
                self.setUpDefaultView()
                self.defaultView.frame = self.tableView.frame
            }
        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.exchangeListEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! VIPExchangeListCell
        let entity = self.vm.exchangeListEntity.list[indexPath.row]
        cell.entity = entity
      
        return cell
        
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "exRecordsDetail") as! VIPExRecordsDetailController
        let entity = self.vm.exchangeListEntity.list[indexPath.row]
        vc.entity = entity
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
