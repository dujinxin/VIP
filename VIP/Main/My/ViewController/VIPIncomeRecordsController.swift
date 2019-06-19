//
//  VIPIncomeRecordsController.swift
//  VIP
//
//  Created by 飞亦 on 6/12/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import MJRefresh


private let reuseIdentifier = "reuseIdentifier"

class VIPIncomeRecordsController: VIPTableViewController {
    
    var vm = VIPIncomeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedString(key: "My_incomeDetail")
        
        
        self.tableView.separatorStyle = .none
        //self.tableView.rowHeight = 135
        self.tableView.register(UINib(nibName: "VIPIncomRecordsCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
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
        
        self.vm.incomeRecords(page: page) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.tableView.reloadData()
            if isSuc == true && self.vm.incomeListEntity.list.count > 0 {
                self.tableView.isHidden = false
            } else {
                
                self.defaultView.backgroundColor = UIColor.clear
                self.defaultView.subviews.forEach({ (v) in
                    v.backgroundColor = UIColor.clear
                    if let l = v as? UILabel {
                        l.textColor = JXGrayTextColor
                    }
                })
                self.defaultInfo = ["imageName":"noneImage","content":LocalizedString(key: "No relevant data available")]
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
        return self.vm.incomeListEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! VIPIncomRecordsCell
        let entity = self.vm.incomeListEntity.list[indexPath.row]
        cell.entity = entity
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
