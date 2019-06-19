//
//  VIPQuotesViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import MJRefresh

private let reuseIdentifierHeader = "reuseIdentifierHeader"
private let reuseIdentifierCell = "reuseIdentifierCell"

class VIPQuotesViewController: VIPTableViewController {
    
    var vm = VIPQuotesVM()
    var financialVM = VIPFinancialVM()
    
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedString(key: "Quotes")
        self.view.backgroundColor = JXFfffffColor
        
        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: ({ () -> UIButton in
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 88, height: 30))
            button.backgroundColor = JXCyanColor
            button.setTitle(LocalizedString(key: "Exchange"), for: .normal)
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
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestData()
        })
        //self.tableView.mj_header.beginRefreshing()
        
        self.financialVM.walletList { (_, _, _) in }
        
        self.showMBProgressHUD()
        
        if #available(iOS 10.0, *) {
            self.timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { (t) in
                self.vm.quotesList() { (_, msg, isSuc) in
                    self.hideMBProgressHUD()
                    if isSuc {
                        self.tableView.reloadData()
                    } else {
                        ViewManager.showNotice(msg)
                    }
                }
            })
        } else {
            self.timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(refreshData), userInfo: nil, repeats: true)
        }
        
        self.timer.fire()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func exchange(button: UIButton) {
        if self.financialVM.walletListEntity.list.count > 0 {
            self.showAlert(entity: self.financialVM.walletListEntity)
        } else {
            self.showMBProgressHUD()
            self.financialVM.walletList { (_, msg, isSuc) in
                self.hideMBProgressHUD()
                self.showAlert(entity: self.financialVM.walletListEntity)
            }
        }
        
    }
    func showAlert(entity: VIPWalletListEntity) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "exchange") as! VIPExchangeViewController
        vc.walletListEntity = entity
        vc.backBlock = {
            self.financialVM.walletListEntity.list.removeAll()
            self.financialVM.walletList { (_, msg, isSuc) in
                
            }
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func refreshData() {
        
        self.vm.quotesList() { (_, msg, isSuc) in
            self.tableView.mj_header.endRefreshing()
            self.hideMBProgressHUD()
            if isSuc {
                self.tableView.reloadData()
            } else {
                ViewManager.showNotice(msg)
            }
        }
        
    }
    override func requestData() {
        self.showMBProgressHUD()
        self.vm.quotesList() { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            self.tableView.mj_header.endRefreshing()
            if isSuc {
                self.tableView.reloadData()
            } else {
                ViewManager.showNotice(msg)
            }
        }
        self.financialVM.walletList { (_, msg, isSuc) in
    
        }
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 44))
        bgView.backgroundColor = JXViewBgColor

        let leftLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 100, height: 44))
        leftLabel.textColor = JXGrayTextColor
        leftLabel.textAlignment = .left
        leftLabel.text = LocalizedString(key: "Quotes_currency")
        leftLabel.font = UIFont.systemFont(ofSize: 15)
        bgView.addSubview(leftLabel)

        let rightLabel = UILabel(frame: CGRect(x: bgView.jxWidth - 130, y: 0, width: 120, height: 44))
        rightLabel.textColor = JXGrayTextColor
        rightLabel.textAlignment = .right
        rightLabel.text = LocalizedString(key: "Quotes_upAndDown")
        rightLabel.font = UIFont.systemFont(ofSize: 15)
        bgView.addSubview(rightLabel)
  
        let centerLabel = UILabel(frame: CGRect(x: leftLabel.jxRight, y: 0, width: bgView.jxWidth - 20 - leftLabel.jxWidth - rightLabel.jxWidth, height: 44))
        centerLabel.textColor = JXGrayTextColor
        centerLabel.textAlignment = .right
        centerLabel.text = LocalizedString(key: "Quotes_latestPrice")
        centerLabel.font = UIFont.systemFont(ofSize: 15)
        bgView.addSubview(centerLabel)

        return bgView

    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.quotesListEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCell, for: indexPath) as! VIPQuotesListCell
        let entity = self.vm.quotesListEntity.list[indexPath.row]
        cell.entity = entity
        //cell.addressLabel.text = self.vm.tradeDetailEntity.account
        //cell.nameLabel.text = dict["title"]
        //            cell.showCodeImage = {
        //                self.showNoticeView2()
        //            }
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.row < 2 {
//            let vc  = VIPPropertyViewController()
//            vc.title = "vip"
//            vc.hidesBottomBarWhenPushed = true
//            self.navigationController?.pushViewController(vc, animated: true)
//        } else {
//            let storyboard = UIStoryboard(name: "Login", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "login") as! VIPLoginViewController
//            let nvc = VIPNavigationController(rootViewController: vc)
//            self.present(nvc, animated: true, completion: nil)
//        }
//
    }
    
}
