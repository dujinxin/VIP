//
//  VIPFindViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPFindViewController: VIPTableViewController{
    
    //var vm = LoginVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedString(key: "Find")
        
        self.tableView.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kTabBarHeight - kNavStatusHeight)
        self.tableView.register(UINib(nibName: "VIPMyListCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCell")
        self.tableView.register(UINib(nibName: "VIPFindHeadCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierHeader")
        self.tableView.estimatedRowHeight = 64
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func requestData() {
        //        self.vm.personInfo { (data, msg, isSuccess) in
        //            if isSuccess == true {
        //                self.tableView.reloadData()
        //                if self.isModify == true {
        //                    UserManager.manager.updateAvatar(self.vm.profileInfoEntity?.headImg ?? "")
        //                    self.isModify = false
        //                }
        //            } else {
        //                ViewManager.showNotice(msg)
        //            }
        //        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierHeader", for: indexPath) as! VIPFindHeadCell
            
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
