//
//  VIPHomeViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import MJRefresh
import JXFoundation

private let reuseIdentifierHeader = "reuseIdentifierHeader"
private let reuseIdentifierCell = "reuseIdentifierCell"

class VIPHomeViewController: VIPTableViewController {

    var vm = VIPHomeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedString(key: "Home")
        
        self.tableView.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - kTabBarHeight)
        
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 83
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.register(UINib(nibName: "VIPHomeHeaderCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierHeader)
        self.tableView.register(UINib(nibName: "VIPHomeCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierCell)
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestData()
        })
        
        //self.requestData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserManager.manager.isLogin {
            self.tableView.mj_header.beginRefreshing()
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "login") as! VIPLoginViewController
            let loginVC = VIPNavigationController.init(rootViewController: login)
            
            self.present(loginVC, animated: false, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func requestData() {
        self.vm.home { (_, msg, isSuc) in
            self.tableView.mj_header.endRefreshing()
            if isSuc {
                self.tableView.reloadData()
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.homeEntity.list.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierHeader, for: indexPath) as! VIPHomeHeaderCell
            cell.totalPropertyLabel.text = "\(self.vm.homeEntity.total_number)"
            cell.todayIncomeLabel.text = "今日收益：\(self.vm.homeEntity.today_vit_number) XXX"
           
            cell.financialManagementBlock = {
                let storyboard = UIStoryboard(name: "Find", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "financialManagement") as! VIPFinancialManagementController
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            cell.superNodeBlock = {
                
            }
            cell.noticeBlock = {
                
            }
            cell.moreBlock = {
                let vc = VIPNotificationViewController()
                vc.title = LocalizedString(key: "Notification")
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCell, for: indexPath) as! VIPHomeCell
            let entity = self.vm.homeEntity.list[indexPath.row - 1]
            cell.coinTitleLabel.text = entity.short_name
            cell.coinNumLabel.text = "\(entity.available_qty)"
            cell.coinValueLabel.text = "$\(entity.price)"
            cell.numValueLabel.text = "$\(entity.price * entity.available_qty)"
            if let s = entity.icon,let url = URL(string: kBaseUrl + s) {
                print(url)
                cell.coinImageView.setImageWith(url, placeholderImage: nil)
            }
            
            return cell
          
        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            let entity = self.vm.homeEntity.list[indexPath.row - 1]
            
            let vc  = VIPPropertyViewController()
            vc.title = entity.short_name
            vc.currencyType = 0
            vc.entity = entity
            
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! VIPLoginViewController
            let nvc = VIPNavigationController(rootViewController: vc)
            self.present(nvc, animated: true, completion: nil)
        }
        
    }

}
