//
//  VIPFinancialManagementController.swift
//  VIP
//
//  Created by 飞亦 on 5/30/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

private let reuseIdentifierHeader = "reuseIdentifierHeader"
private let reuseIdentifierCell = "reuseIdentifierCell"

class VIPFinancialManagementController: VIPTableViewController {

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
            self.topConstraint.constant = kNavStatusHeight + 10
        }
    }
    
    @IBOutlet weak var totalNumLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    
    @IBOutlet weak var line: UIView!{
        didSet{
            self.line.layer.cornerRadius = 2
        }
    }
    var vm = VIPFinancialVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.title = LocalizedString(key: "Finance")
        
        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: ({ () -> UIButton in
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 88, height: 30))
            //button.backgroundColor = UIColor.lightGray
            button.setTitle(LocalizedString(key: "Find_financialRecords"), for: .normal)
            button.setImage(UIImage(named: "financialRecords"), for: .normal)
            button.setTitleColor(JXBlueColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            //button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2.5, bottom: 0, right: 2.5)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
            button.layer.cornerRadius = 4
            button.addTarget(self, action: #selector(record(button:)), for: .touchUpInside)
            return button
            }()))
        
        self.tableView.removeFromSuperview()
        self.contentView.addSubview(self.tableView)
        self.tableView.isHidden = true
        
        let height = (kScreenWidth - 20) * 106.0 / 355.0
        print("height ", height)
        self.tableView.frame = CGRect(x: 0, y: kNavStatusHeight + 10 + height + 40, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - 10 - height - 40)
        self.tableView.backgroundColor = JXFfffffColor
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 183
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.backgroundColor = JXViewBgColor
        
        //self.tableView.register(UINib(nibName: "VIPFinancialAccountHeadCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierHeader)
        self.tableView.register(UINib(nibName: "VIPFinancialListCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierCell)
        
        self.requestData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func record(button: UIButton) {
        let vc = VIPFinancialRecordsController()
        vc.titleArray = self.vm.financialEntity.list
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func requestData() {
        self.showMBProgressHUD()
        self.vm.financial() { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            if isSuc {
                self.contentView.isHidden = false
                self.totalNumLabel.text = "\(self.vm.financialEntity.invest_sum)"
                self.totalValueLabel.text = "\(self.vm.financialEntity.profit_sum)"
                
                if self.vm.financialEntity.list.count > 0 {
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
        }
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.financialEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCell, for: indexPath) as! VIPFinancialListCell
        let entity = self.vm.financialEntity.list[indexPath.row]
        cell.accountLabel.text = entity.level_name
        cell.limitLabel.text = "\(LocalizedString(key: "Find_amount"))($\(entity.min_money)-$\(entity.max_money))"
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard(name: "Find", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "financialAccount") as! VIPFinancialAccountController
        let entity = self.vm.financialEntity.list[indexPath.row]
        vc.accountEntity = entity
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

