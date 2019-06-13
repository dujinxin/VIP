//
//  VIPFinancialAccountController.swift
//  VIP
//
//  Created by 飞亦 on 5/30/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit


private let reuseIdentifierHeader = "reuseIdentifierHeader"
private let reuseIdentifierCell = "reuseIdentifierCell"

class VIPFinancialAccountController: VIPTableViewController {
    
    var accountEntity : VIPFinancialListEntity?
    var vm = VIPFinancialVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = LocalizedString(key: self.accountEntity?.level_name)
        
        self.view.backgroundColor = JXFfffffColor
        
        self.tableView.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        self.tableView.isHidden = true
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 82
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.tableView.register(UINib(nibName: "VIPFinancialAccountHeadCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierHeader)
        self.tableView.register(UINib(nibName: "VIPFinancialAccountListCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierCell)
        
        
        self.requestData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.maskView.alpha = 0
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func requestData() {
        self.showMBProgressHUD()
        self.vm.financialProgram(level_id: self.accountEntity?.level ?? 0, completion: { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                self.tableView.isHidden = false
                self.tableView.reloadData()
            } else {
                ViewManager.showNotice(msg)
            }
        })
        self.vm.walletList { (_, msg, isSuc) in
            
        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.programEntity.list.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierHeader, for: indexPath) as! VIPFinancialAccountHeadCell
    
            cell.accountLabel.text = LocalizedString(key: self.accountEntity?.level_name)
            cell.accountLabel.textColor = JXBlueColor
            cell.limitLabel.text = "金额($\(self.accountEntity?.min_money ?? 0)-$\(self.accountEntity?.max_money ?? 0))"
            cell.joinNumLabel.text = "\(self.vm.programEntity.invest_money)"

            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCell, for: indexPath) as! VIPFinancialAccountListCell
            let entity = self.vm.programEntity.list[indexPath.row - 1]
            cell.planLabel.text = entity.title
            if entity.cycle_value == 0 {
                cell.dateLabel.text = "(\(LocalizedString(key: "活期")))"
            } else {
                cell.dateLabel.text = "(\(entity.cycle_value)个月)"
            }
            cell.rateLabel.text = entity.interest_range
            
            cell.buyBlock = {
                if self.vm.walletListEntity.list.count > 0 {
                    self.showAlert(entity: entity)
                } else {
                    self.showMBProgressHUD()
                    self.vm.walletList { (_, msg, isSuc) in
                        self.hideMBProgressHUD()
                        self.showAlert(entity: entity)
                    }
                }
                
            }
            return cell
            
        }
        
    }
    func showAlert(entity: VIPFinancialProgramListEntity) {
        let storyboard = UIStoryboard(name: "Find", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "financialAlert") as! VIPFinancialAlertController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        vc.walletListEntity = self.vm.walletListEntity
        vc.programEntity = entity
        vc.backBlock = {
            if let _ = self.maskView.superview {
                self.maskView.removeFromSuperview()
            }
        }
        self.present(vc, animated: true, completion:{
            //self.maskView.alpha = 1
        })
        self.view.addSubview(self.maskView)
    }
    lazy var maskView: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        v.backgroundColor = UIColor.rgbColor(rgbValue: 0x000000, alpha: 0.4)
        return v
    }()
}
