//
//  VIPSafetyViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/29/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPSafetyViewController: VIPTableViewController{

    var actionArray = [LocalizedString(key: "My_exportPrivateKey"),LocalizedString(key: "My_backupMnemonics"),LocalizedString(key: "My_modifyLoginPassword"),LocalizedString(key: "My_modifyTradePassword"),LocalizedString(key: "Home_addressBook")]
    
    var vm = VIPSafetyVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "VIPSelectCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCell")
        
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 15)
        v.backgroundColor = JXViewBgColor
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return actionArray.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierCell", for: indexPath) as! VIPSelectCell
        let title = actionArray[indexPath.section]
        cell.titleLabel.text = title
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "My", bundle: nil)
        let title = actionArray[indexPath.section]
        
        if indexPath.section == 0 {
            self.showMBProgressHUD()
            self.vm.fetchPrivateKey() { (_, msg, isSuc) in
                self.hideMBProgressHUD()
                
                if isSuc == false {
                    ViewManager.showNotice(msg)
                } else {
                    let vc = storyboard.instantiateViewController(withIdentifier: "export") as! VIPExportViewController
                    vc.title = title
                    vc.privateKey = self.vm.privateKey
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        } else if indexPath.section == 1{
            self.showMBProgressHUD()
            self.vm.fetchMnemonic() { (_, msg, isSuc) in
                self.hideMBProgressHUD()
                
                if isSuc == false {
                    ViewManager.showNotice(msg)
                } else {
                    let vc = storyboard.instantiateViewController(withIdentifier: "backUp") as! VIPBackUpViewController
                    vc.title = title
                    vc.mnemonicStr = self.vm.mnemonic
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
        } else if indexPath.section == 2{
            let vc = storyboard.instantiateViewController(withIdentifier: "modify") as! VIPModifyViewController
            vc.title = title
            vc.type = .login
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 3{
            let vc = storyboard.instantiateViewController(withIdentifier: "modify") as! VIPModifyViewController
            vc.title = title
            vc.type = .trade
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = VIPAddressListController()
            vc.type = .my
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
}
