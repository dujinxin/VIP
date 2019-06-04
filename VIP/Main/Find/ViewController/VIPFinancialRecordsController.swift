//
//  VIPFinancialRecordsController.swift
//  VIP
//
//  Created by 飞亦 on 6/3/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation
import MJRefresh

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"

class VIPFinancialRecordsController: VIPTableViewController {
    
    
    var vm = VIPPropertyVM()
    var currencyId = 0  //币种
    var currencyType = 0 //0全部 1收款 2转账 3理财 4兑换
    
    var topBar : JXBarView!
    var horizontalView : JXHorizontalView?
    
    lazy var maskView: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        v.backgroundColor = UIColor.rgbColor(rgbValue: 0x000000, alpha: 0.4)
        return v
    }()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.customNavigationBar.backgroundColor = JXFfffffColor
        self.customNavigationItem.titleView = ({

            let tabBgView = UIView(frame: CGRect(x: 20, y: 0 + 70, width: 75 * 3 + 24, height: 44))
            
          
            let names = ["普通账户","黄金账户","白金账户"]
            for i in 0..<3 {
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: (12 + 75) * CGFloat(i), y: 10, width: 75, height: 24)
               
                button.setTitle(names[i], for: .normal)
                button.setTitleColor(JXBlueColor, for: .selected)
                button.setTitleColor(JXGrayTextColor, for: .normal)
                button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                button.layer.borderWidth = 1
                
                button.tag = i
                button.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
                if i == 0 {
                    button.backgroundColor = JXFfffffColor
                    button.isSelected = true
                    button.layer.borderColor = JXBlueColor.cgColor
                } else {
                    button.backgroundColor = JXViewBgColor
                    button.isSelected = false
                    button.layer.borderColor = JXViewBgColor.cgColor
                }

                tabBgView.addSubview(button)
            }
            return tabBgView

        })()
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-back"), style: .plain, target: self, action: #selector(back))
        
        
        let topBar = JXBarView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight, width: view.bounds.width , height: 48), titles: ["Play A","Play B","Play C","Play D"])
        topBar.delegate = self
        
        let att = JXAttribute()

        att.selectedColor = JXBlueColor
        att.normalColor = JXBlackTextColor
        att.font = UIFont.systemFont(ofSize: 17)
        topBar.attribute = att
        
        topBar.backgroundColor = JXFfffffColor
        topBar.bottomLineSize = CGSize(width: 45, height: 3)
        topBar.bottomLineView.backgroundColor = JXMainColor
        topBar.isBottomLineEnabled = true

        
        self.topBar = topBar
        self.view.addSubview(self.topBar)
        
        
        
        self.tableView.frame = CGRect.init(x: 0, y: kNavStatusHeight + 48, width: view.bounds.width, height: UIScreen.main.bounds.height - kNavStatusHeight - 48)
        self.tableView.register(UINib(nibName: "VIPFinancialRecordsCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        self.tableView.rowHeight = 190
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        switch segue.identifier {
        //        case "invite":
        //            if let vc = segue.destination as? InviteViewController, let inviteEntity = sender as? InviteEntity {
        //                vc.inviteEntity = inviteEntity
        //            }
        //        default:
        //            print("123456")
        //        }
    }
    override func request(page: Int) {
        
        self.vm.propertyDetail(currencyId: self.currencyId, queryType: self.currencyType, page: self.page) { (_, msg, isSuc) in
            //self.hideMBProgressHUD()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.tableView.reloadData()
        }
    }
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func action(button: UIButton) {
        
        self.customNavigationItem.titleView?.subviews.forEach({ (v) in
            if let b = v as? UIButton {
                if b.tag == button.tag {
                    b.backgroundColor = JXFfffffColor
                    b.isSelected = true
                    b.layer.borderColor = JXBlueColor.cgColor
                } else {
                    b.backgroundColor = JXViewBgColor
                    b.isSelected = false
                    b.layer.borderColor = JXViewBgColor.cgColor
                }
            }
        })
        
        //        self.showMBProgressHUD()
        //        self.vm.getQuickPayType(amount: num, completion: { (_, msg, isSuc) in
        //            self.hideMBProgressHUD()
        //            if isSuc{
        //                self.amount = num
        //                self.statusBottomView.customView = self.customViewInit(number: text)
        //                self.statusBottomView.show()
        //            } else {
        //                ViewManager.showNotice("暂不支持此购买金额")
        //            }
        //        })
        
    }
}
//MARK:UIScrollViewDelegate
extension VIPFinancialRecordsController {
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
extension VIPFinancialRecordsController : JXBarViewDelegate {
    
    func jxBarView(barView: JXBarView, didClick index: Int) {
        self.currencyType = index
        self.tableView.mj_header.beginRefreshing()
    }
}
// MARK: - Table view data source
extension VIPFinancialRecordsController {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! VIPFinancialRecordsCell
        //cell.entity = self.vm.tradeDetailEntity
        //cell.setEntity(self.vm.tradeDetailEntity, type: self.type)
        cell.releaseBlock = {
            let storyboard = UIStoryboard(name: "Find", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "financialRecordsAlert") as! VIPFinancialRecordsAlertController
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.backBlock = {
                if let _ = self.maskView.superview {
                    self.maskView.removeFromSuperview()
                }
            }
            self.view.addSubview(self.maskView)
            self.present(vc, animated: true, completion:{
                //self.maskView.alpha = 1
            })
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "propertyDetail") as! VIPProDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
