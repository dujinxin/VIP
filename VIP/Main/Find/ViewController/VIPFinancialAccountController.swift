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
    
    @IBOutlet weak var mainScrollView: UIScrollView!{
        didSet{
            self.mainScrollView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var contentView: UIView!{
        didSet{
            self.contentView.isHidden = false
        }
    }
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight
        }
    }
    @IBOutlet weak var accountLabel: UILabel!{
        didSet{
            self.accountLabel.textColor = JXBlueColor
        }
    }
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var joinNumLabel: UILabel!
    @IBOutlet weak var joinBgView: UIView!
    @IBOutlet weak var line: UIView!{
        didSet{
            self.line.layer.cornerRadius = 2
        }
    }
    
    var accountEntity : VIPFinancialListEntity?
    var vm = VIPFinancialVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = LocalizedString(key: self.accountEntity?.level_name)
        
        self.view.backgroundColor = JXViewBgColor
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.tableView.frame = CGRect(x: 0, y: kNavStatusHeight + 124, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - 124)
        self.tableView.isHidden = true
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 182
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.backgroundColor = JXViewBgColor
        
//        self.tableView.register(UINib(nibName: "VIPFinancialAccountHeadCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierHeader)
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
        self.vm.financialProgram(level_id: self.accountEntity?.id ?? 0, completion: { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                self.accountLabel.text = LocalizedString(key: self.accountEntity?.level_name)
                self.accountLabel.textColor = JXBlueColor
                self.limitLabel.text = "\(LocalizedString(key: "Find_amount"))($\(self.accountEntity?.min_money ?? 0)-$\(self.accountEntity?.max_money ?? 0))"
                self.joinNumLabel.text = "\(self.vm.programEntity.invest_money)"
                
                if self.vm.programEntity.list.count > 0 {
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
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
        return self.vm.programEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if indexPath.row == 0 {
//            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierHeader, for: indexPath) as! VIPFinancialAccountHeadCell
//
//            cell.accountLabel.text = LocalizedString(key: self.accountEntity?.level_name)
//            cell.accountLabel.textColor = JXBlueColor
//            cell.limitLabel.text = "金额($\(self.accountEntity?.min_money ?? 0)-$\(self.accountEntity?.max_money ?? 0))"
//            cell.joinNumLabel.text = "\(self.vm.programEntity.invest_money)"
//
//            return cell
//        } else {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCell, for: indexPath) as! VIPFinancialAccountListCell
            let entity = self.vm.programEntity.list[indexPath.row]
            cell.planLabel.text = entity.title
            if entity.cycle_value == 0 {
                cell.dateLabel.text = "(\(LocalizedString(key: "Find_current")))"
            } else {
                cell.dateLabel.text = "(\(entity.cycle_value)\(LocalizedString(key: "Find_months")))"
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
            
//        }
        
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
