//
//  VIPProRecordsContorller.swift
//  VIP
//
//  Created by 飞亦 on 6/10/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import UIKit
import JXFoundation
import MJRefresh

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class VIPProRecordsContorller: VIPTableViewController {
    
    
    var vm = VIPPropertyVM()

    var type = 0 //0全部 1收款 2转账 3理财 4兑换
    var entity : VIPCoinPropertyEntity!
    
    lazy var formater: DateFormatter = {
        let formater = DateFormatter()
        return formater
    }()
    var refreshBlock: ((_ vm: VIPPropertyVM) -> ())?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let headViewHeight : CGFloat = 100 + 15 + 50 + 30 + 40 + 30 + 10 + 44
        let rect = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - headViewHeight)
        self.tableView.frame = rect
        self.tableView.register(UINib(nibName: "VIPPropertyCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        self.tableView.rowHeight = 135
        
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
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    override func request(page: Int) {
        
        self.vm.propertyDetail(currencyId: self.entity!.id, queryType: self.type, page: self.page) { (_, msg, isSuc) in
           
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
  
            self.tableView.reloadData()
            if let block = self.refreshBlock {
                block(self.vm)
            }
            if isSuc == true && self.vm.propertyEntity.recordList.count > 0 {
                self.tableView.isHidden = false
            } else {
                self.tableView.isHidden = true
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

}

// MARK: - Table view data source
extension VIPProRecordsContorller {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.propertyEntity.recordList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! VIPPropertyCell
        let entity = self.vm.propertyEntity.recordList[indexPath.row]
        cell.tradeRecords = entity
        
        formater.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let date = formater.date(from: entity.create_time ?? "0")
        formater.dateFormat = "HH:mm MM/dd"
        if let date = date {
            let dateStr = formater.string(from: date)
            cell.timeLabel.text = dateStr
        } else {
            cell.timeLabel.text = entity.create_time
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "propertyDetail") as! VIPProDetailViewController
        let entity = self.vm.propertyEntity.recordList[indexPath.row]
        vc.entity = entity
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
