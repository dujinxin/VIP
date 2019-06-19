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
    
    var titleArray : Array<VIPFinancialListEntity>?
    
    var vm = VIPFinancialVM()
    
    var select_row = 0  //账户类型(以列来表示)
    var contract_id = 0  //计划ID
    var programIndex = 0 //当前理财计划
    
    lazy var dropListView: JXDropListView = {
        let sel = JXDropListView(frame: CGRect(x: kScreenWidth - 168, y: kNavStatusHeight, width: 168, height: 204), style: .list)
        sel.delegate = self
        sel.dataSource = self
        sel.backgroundColor = JXFfffffColor
        return sel
    }()
    
    lazy var topBar : JXXBarView = {
        
        let topBar = JXXBarView.init(frame: CGRect.init(x: 0, y: kNavStatusHeight, width: view.bounds.width , height: 48), titles: [""])
        topBar.delegate = self
        
        let att = JXAttribute()
        
        att.selectedColor = JXBlueColor
        att.normalColor = JXBlackTextColor
        att.font = UIFont.systemFont(ofSize: 17)
        topBar.attribute = att
        
        topBar.backgroundColor = JXFfffffColor
        topBar.bottomLineSize = CGSize(width: 45, height: 3)
        topBar.bottomLineView.backgroundColor = JXMainColor
        topBar.isBottomLineEnabled = false
        
        return topBar
    }()
    var horizontalView : JXHorizontalView?
    
    lazy var maskView: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        v.backgroundColor = UIColor.rgbColor(rgbValue: 0x000000, alpha: 0.4)
        return v
    }()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.customNavigationBar.backgroundColor = JXFfffffColor
        self.title = self.titleArray?[0].level_name
        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: ({ () -> UIButton in
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 88, height: 30))
            //button.backgroundColor = UIColor.lightGray
            button.setTitle(LocalizedString(key: "Find_selectAaccounts"), for: .normal)
            button.setImage(UIImage(named: "selectAccount"), for: .normal)
            button.setTitleColor(JXBlueColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            //button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2.5, bottom: 0, right: 2.5)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
            button.layer.cornerRadius = 4
            button.addTarget(self, action: #selector(selectAccount(button:)), for: .touchUpInside)
            return button
            }()))


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
        self.requestData()
    }
    override func requestData() {
        self.showMBProgressHUD()
        self.vm.financialPrograms_Records { (_, msg, isSuc) in
            if isSuc {
                //self.topBar.titles =
                self.select_row = 0
                self.programIndex = 0
                self.topBar.titles.removeAll()
                self.topBar.titles = self.vm.programRecordsEntity.list[0].titles
                self.topBar.isBottomLineEnabled = true
                self.topBar.containerView.reloadData()
                
    
                self.contract_id = self.vm.programRecordsEntity.list[0].list[0].id
                self.request(page: self.page)
            } else {
                self.hideMBProgressHUD()
                ViewManager.showNotice(msg)
            }
        }
    }
    override func request(page: Int) {
//        self.vm.recordsEntity.list.removeAll()
//        self.tableView.reloadData()
        
        self.vm.financialRecords(contract_id: self.contract_id, page: self.page) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
           
            
            if self.vm.recordsEntity.list.count > 0 {
                self.defaultView.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            } else {
                self.tableView.isHidden = true
                self.defaultView.isHidden = false
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
        }
    }
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func selectAccount(button: UIButton) {
        
        self.dropListView.show()
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
extension VIPFinancialRecordsController : JXXBarViewDelegate {
    
    func jxxBarView(barView: JXXBarView, didClick index: Int) {
        self.programIndex = index
        self.contract_id = self.vm.programRecordsEntity.list[self.select_row].list[index].id
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
        return self.vm.recordsEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! VIPFinancialRecordsCell
        let entity = self.vm.recordsEntity.list[indexPath.row]
        cell.entity = entity
        cell.releaseBlock = {
            
            let storyboard = UIStoryboard(name: "Find", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "financialRecordsAlert") as! VIPFinancialRecordsAlertController
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.entity = entity
            if self.vm.programRecordsEntity.list.count > 0 {
                let arr = self.vm.programRecordsEntity.list[self.select_row].titles
                if arr.count > 0 {
                    vc.titleStr = arr[self.programIndex]
                }
            }
            vc.callBackBlock = { isRefresh in
                if let _ = self.maskView.superview {
                    self.maskView.removeFromSuperview()
                }
                if isRefresh {
                    self.tableView.mj_header.beginRefreshing()
                }

            }
            self.view.addSubview(self.maskView)
            self.present(vc, animated: true, completion:{
                //self.maskView.alpha = 1
            })
        }
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
// MARK: JXDropListViewDelegate & JXDropListViewDataSource
extension VIPFinancialRecordsController : JXDropListViewDelegate,JXDropListViewDataSource {
    func dropListView(listView: JXDropListView, didSelectRowAt row: Int, inSection section: Int) {
        guard let entity = self.titleArray?[row], let title = entity.level_name else {
            return
        }
        self.title = title
        self.select_row = row
        self.topBar.titles = self.vm.programRecordsEntity.list[row].titles
        self.topBar.containerView.reloadData()
        
        self.contract_id = self.vm.programRecordsEntity.list[row].list[0].id
        self.tableView.mj_header.beginRefreshing()
    }
    func dropListView(listView: JXDropListView, numberOfRowsInSection section: Int) -> Int {
        return self.titleArray?.count ?? 0
    }
    
    func dropListView(listView: JXDropListView, heightForRowAt row: Int) -> CGFloat {
        return 60
    }
    
    func dropListView(listView: JXDropListView, contentForRow row: Int, InSection section: Int) -> String {
        guard let entity = self.titleArray?[row], let title = entity.level_name else {
            return ""
        }
        return title
    }
    
    
}
