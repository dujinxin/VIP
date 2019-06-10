//
//  VIPPropertyViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation
import MJRefresh

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class VIPPropertyViewController: VIPTableViewController {
    
    
    var vm = VIPPropertyVM()
    var financialVM = VIPFinancialVM()
    var currencyType = 0 //0全部 1收款 2转账 3理财 4兑换
    var entity : VIPCoinPropertyEntity!
    
    lazy var scrollView: UIScrollView = {
        let s = UIScrollView(frame: CGRect(x: 0, y: kStatusBarHeight, width: kScreenWidth, height: kScreenHeight - kStatusBarHeight))
        s.delegate = self
        s.scrollIndicatorInsets = UIEdgeInsets.init(top: headViewHeight, left: 0, bottom: 0, right: 0)
        s.contentSize = CGSize(width: 0, height: kScreenHeight * 2)
        return s
    }()
    
    var headViewHeight : CGFloat = 100 + 15 + 50 + 30 + 40 + 30 + 10 + 44
    
    lazy var headView: UIView = {
        let headView = UIView(frame: CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: headViewHeight))
        headView.backgroundColor = JXFfffffColor
        //资产相关
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 100))
        topView.backgroundColor = JXEeeeeeColor
        headView.addSubview(topView)
        
        let leftLabel = UILabel(frame: CGRect(x: 30, y: 30, width: 60, height: 30))
        leftLabel.textColor = JXBlackTextColor
        leftLabel.font = UIFont.systemFont(ofSize: 24)
        leftLabel.textAlignment = .left
        topView.addSubview(leftLabel)
        leftLabel.center = CGPoint(x: leftLabel.center.x, y: topView.jxHeight / 2)
        
        let centerLabel1 = UILabel(frame: CGRect(x: 30, y: 20, width: 150, height: 30))
        centerLabel1.textColor = JXBlackTextColor
        centerLabel1.font = UIFont.systemFont(ofSize: 24)
        centerLabel1.textAlignment = .center
        topView.addSubview(centerLabel1)
        centerLabel1.center = CGPoint(x: topView.center.x, y: centerLabel1.center.y)
        
        let centerLabel2 = UILabel(frame: CGRect(x: 30, y: centerLabel1.jxBottom + 5, width: 150, height: 20))
        centerLabel2.textColor = JXGrayTextColor
        centerLabel2.font = UIFont.systemFont(ofSize: 14)
        centerLabel2.textAlignment = .center
        topView.addSubview(centerLabel2)
        centerLabel2.center = CGPoint(x: topView.center.x, y: centerLabel2.center.y)
        
        self.coinNameLabel = leftLabel
        self.coinNumLabel = centerLabel1
        self.coinValueLabel = centerLabel2
        
        //地址相关
        let textFieldBgView = UIView(frame: CGRect(x: 30, y: topView.jxBottom + 15, width: headView.jxWidth - 30 * 2, height: 50))
        textFieldBgView.backgroundColor = JXEeeeeeColor
        headView.addSubview(textFieldBgView)
        
        let addressLabel = UILabel(frame: CGRect(x: 15, y: 5, width: textFieldBgView.jxWidth - 15 - 44, height: 40))
        addressLabel.textColor = JXBlackTextColor
        addressLabel.font = UIFont.systemFont(ofSize: 12)
        addressLabel.textAlignment = .left
        addressLabel.numberOfLines = 0
        textFieldBgView.addSubview(addressLabel)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: addressLabel.jxRight, y: 5, width: 44, height: 40)
        button.setImage(UIImage(named: "copy"), for: .normal)
        
        button.addTarget(self, action: #selector(copyAddress), for: .touchUpInside)
        
        textFieldBgView.addSubview(button)
        
        self.addressLabel = addressLabel
        
        let space = (kScreenWidth - 30 - 90 * 3) / 2
        let names = ["转账","收款","兑换"]
        let icons = ["transfer","receip","exchange"]
        for i in 0..<3 {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 15 + (space + 90) * CGFloat(i), y: textFieldBgView.jxBottom + 30, width: 90, height: 40)
            button.setImage(UIImage(named: icons[i]), for: .normal)
            button.setTitle(names[i], for: .normal)
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2.5, bottom: 0, right: 2.5)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2.5, bottom: 0, right: -2.5)
            button.tag = i
            button.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
            if i == 0 {
                button.backgroundColor = JXBlueColor
            } else if i == 1 {
                button.backgroundColor = JXGreenColor
            } else {
                button.backgroundColor = JXCyanColor
                button.setTitleColor(JXBlueColor, for: .normal)
            }
            headView.addSubview(button)
        }
        
        //地址相关
        let tabBgView = UIView(frame: CGRect(x: 0, y: textFieldBgView.jxBottom + 30 + 70, width: headView.jxWidth, height: 54))
        tabBgView.backgroundColor = JXEeeeeeColor
        headView.addSubview(tabBgView)
        
        let topBar = JXBarView.init(frame: CGRect.init(x: 0, y: 10, width: view.bounds.width , height: 44), titles: ["全部","转账","收款","理财","兑换"])
        topBar.delegate = self
        
        let att = JXAttribute()
        att.normalColor = JXBlackTextColor
        att.selectedColor = JXBlueColor
        att.font = UIFont.systemFont(ofSize: 17)
        topBar.attribute = att
        
        topBar.backgroundColor = JXFfffffColor
        topBar.bottomLineSize = CGSize(width: 36, height: 4)
        topBar.bottomLineView.backgroundColor = JXMainColor
        topBar.isBottomLineEnabled = true
        
        tabBgView.addSubview(topBar)
        
        self.topBar = topBar
        
        return headView
    }()
    
    var coinNameLabel : UILabel!
    var coinNumLabel : UILabel!
    var coinValueLabel : UILabel!
    
    var addressLabel : UILabel!
    
    var topBar : JXBarView!
    var horizontalView : JXHorizontalView?
    
    
    lazy var keyboard: JXKeyboardToolBar = {
        let bar = JXKeyboardToolBar(frame: CGRect())
        bar.showBlock = { (view, value) in
            print(view,value)
        }
        bar.closeBlock = {
            //self.textField.text = ""
        }
        bar.tintColor = JXFfffffColor
        bar.toolBar.barTintColor = JXViewBgColor
        bar.backgroundColor = JXViewBgColor
        return bar
    }()
    
    lazy var date: Date = {
        let d = Date()
        d.formatter.dateFormat = "HH:mm MM/dd"
        return d
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //self.view.insertSubview(self.headView, belowSubview: self.customNavigationBar)
        self.view.addSubview(self.headView)
        
        
        self.tableView.frame = CGRect.init(x: 0, y: kNavStatusHeight + headViewHeight, width: view.bounds.width, height: UIScreen.main.bounds.height - kNavStatusHeight - headViewHeight)
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
        
        //设置默认值，真实数据以钱包结果为准
        self.coinNameLabel.text = "\(self.entity.short_name ?? "")"
        self.coinNumLabel.text = "\(self.entity.available_qty)"
        self.coinValueLabel.text = "$\(self.entity.available_qty * self.entity.price)"
        self.addressLabel.text = self.entity.address
    }
    
    override func requestData() {
        self.financialVM.walletList { (_, msg, isSuc) in
            
        }
    }
    override func request(page: Int) {
        
        self.vm.propertyDetail(currencyId: self.entity!.id, queryType: self.currencyType, page: self.page) { (_, msg, isSuc) in
            //self.hideMBProgressHUD()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            
            //self.serviceTotal = String(format:"%.2f",numDouble * (self.sellInfoEntity?.saleRate ?? 0)) + " \(configuration_coinName)"
            
            self.coinNameLabel.text = "\(self.vm.propertyEntity.coinEntity?.short_name ?? "")"
            self.coinNumLabel.text = "\(self.vm.propertyEntity.walletEntity?.available_qty ?? 0)"
            if let num = self.vm.propertyEntity.walletEntity?.available_qty, let prise = self.vm.propertyEntity.coinEntity?.price {
                self.coinValueLabel.text = "$\(num * prise)"
            }
            self.addressLabel.text = self.vm.propertyEntity.coinEntity?.deposit_address
            //self.addressLabel.text = self.entity.address
            self.tableView.reloadData()
        }
    }
    @objc func copyAddress() {
        let pals = UIPasteboard.general
        pals.string = self.addressLabel.text
        ViewManager.showNotice("已复制")
    }
    @objc func action(button: UIButton) {
       
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if button.tag == 0 {
            let vc = storyboard.instantiateViewController(withIdentifier: "transfer") as! VIPTransferViewController
            vc.entity = self.vm.propertyEntity
            vc.backBlock = {
                self.tableView.mj_header.beginRefreshing()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else if button.tag == 1 {
            let vc = storyboard.instantiateViewController(withIdentifier: "receipt") as! VIPReceiptViewController
            vc.receiptStr = self.vm.propertyEntity.walletEntity?.address ?? ""
            vc.tokenName = self.vm.propertyEntity.coinEntity?.short_name ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
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
}
//MARK:UIScrollViewDelegate
extension VIPPropertyViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = self.scrollView.contentOffset.y
//        if (offsetY <= 0.0) {
//            var frame = self.headView.frame
//            frame.origin.y = offsetY
//
//            var tFrame = self.tableView.frame
//            tFrame.origin.y = offsetY + headViewHeight
//            self.tableView.frame = tFrame
//            if !self.tableView.mj_header.isRefreshing {
//                self.tableView.contentOffset = CGPoint(x: 0, y: offsetY)
//            }
//        }
    }
}
//MARK:JXBarViewDelegate
extension VIPPropertyViewController : JXBarViewDelegate {
    
    func jxBarView(barView: JXBarView, didClick index: Int) {
        self.currencyType = index
        self.tableView.mj_header.beginRefreshing()
    }
}
// MARK: - Table view data source
extension VIPPropertyViewController {
    
    
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
