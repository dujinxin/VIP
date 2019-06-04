//
//  VIPQuotesViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

private let reuseIdentifierHeader = "reuseIdentifierHeader"
private let reuseIdentifierCell = "reuseIdentifierCell"

class VIPQuotesViewController: VIPTableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedString(key: "Quotes")
        
        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: ({ () -> UIButton in
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 68, height: 30))
            button.backgroundColor = JXCyanColor
            button.setTitle("兑换", for: .normal)
            button.setImage(UIImage(named: "exchange"), for: .normal)
            button.setTitleColor(JXBlueColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2.5, bottom: 0, right: 2.5)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2.5, bottom: 0, right: -2.5)
            button.layer.cornerRadius = 4
            button.addTarget(self, action: #selector(exchange(button:)), for: .touchUpInside)
            return button
            }()))
        
        self.tableView.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - kTabBarHeight)
        
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 86
        self.tableView.rowHeight = UITableView.automaticDimension
        
        //self.tableView.register(UINib(nibName: "VIPHomeHeaderCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierHeader)
        self.tableView.register(UINib(nibName: "VIPQuotesListCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierCell)
        
            
        
        self.requestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func exchange(button: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "exchange") as! VIPExchangeViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func requestData() {
        //        self.vm.tradeDetail(type: self.type, bizId: self.bizId) { (_, msg, isSuc) in
        //            if isSuc {
        //                self.tableView?.reloadData()
        //            } else {
        //                ViewManager.showNotice(msg)
        //            }
        //        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierHeader, for: indexPath) as! VIPHomeHeaderCell
//            //cell.entity = self.vm.tradeDetailEntity
//            //cell.setEntity(self.vm.tradeDetailEntity, type: self.type)
//            cell.financialManagementBlock = {
//                let storyboard = UIStoryboard(name: "Find", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "financialManagement") as! VIPFinancialManagementController
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//            cell.superNodeBlock = {
//
//            }
//            return cell
//        } else {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCell, for: indexPath) as! VIPQuotesListCell
            //cell.addressLabel.text = self.vm.tradeDetailEntity.account
            //cell.nameLabel.text = dict["title"]
            //            cell.showCodeImage = {
            //                self.showNoticeView2()
            //            }
            return cell
            
//        }
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < 2 {
            let vc  = VIPPropertyViewController()
            vc.title = "vip"
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
