//
//  VIPTableViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation
import MJRefresh
import MBProgressHUD

let reuseIdentifierNormal = "reuseIdentifierNormal"

open class VIPTableViewController: JXBaseViewController{
    
    //tableview
    public lazy var tableView : UITableView = {
        let table = UITableView(frame: CGRect())
        
        table.backgroundColor = UIColor.clear
        table.separatorStyle = .singleLine
        //table.separatorColor = JXSeparatorColor
        table.delegate = self
        table.dataSource = self
        table.estimatedSectionHeaderHeight = 0
        table.estimatedSectionFooterHeight = 0
        table.estimatedRowHeight = 44
        table.rowHeight = UITableView.automaticDimension
        table.sectionHeaderHeight = UITableView.automaticDimension
        table.sectionFooterHeight = UITableView.automaticDimension
        
        return table
    }()
    //refreshControl
    public var refreshControl : UIRefreshControl?
    //data array
    public var dataArray : Array<Any>!
    public var page : Int = 1
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.view.backgroundColor = JXViewBgColor
        
        self.customNavigationBar.isTranslucent = true
        self.customNavigationBar.barStyle = .default
        self.customNavigationBar.tintColor = JXBlackTextColor //item图片文字颜色
        let font = UIFont(name: "PingFangSC-Semibold", size: 17) ?? UIFont.systemFont(ofSize: 17)
        self.customNavigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: JXBlackTextColor,NSAttributedString.Key.font:font]//标题设置
        self.customNavigationBar.setBackgroundImage(UIImage.imageWithColor(UIColor.white), for: UIBarMetrics.default)
        
        self.tableView.backgroundColor = UIColor.clear
    }
    
    @objc override open func setUpMainView() {
        setUpTableView()
    }
    
    open func setUpTableView(){
        let y = self.isCustomNavigationBarUsed() ? kNavStatusHeight : 0
        let height = self.isCustomNavigationBarUsed() ? (view.bounds.height - kNavStatusHeight) : view.bounds.height
        
        self.tableView.frame = CGRect(x: 0, y: y, width: view.bounds.width, height: height)
        self.view.addSubview(self.tableView)
        
        //        refreshControl = UIRefreshControl()
        //        refreshControl?.addTarget(self, action: #selector(requestData), for: UIControlEvents.valueChanged)
        //        self.tableView?.addSubview(refreshControl!)
    }
    /// request data
    ///
    /// - Parameter page: load data for page,
    open func request(page:Int) {}
    
    open func showMBProgressHUD() {
        let _ = MBProgressHUD.showAdded(to: self.view, animated: true)
        //        hud.backgroundView.color = UIColor.black
        //        hud.contentColor = UIColor.black
        //        hud.bezelView.backgroundColor = UIColor.black
        //        hud.label.text = "加载中..."
        
    }
    open func hideMBProgressHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
}
extension VIPTableViewController : UITableViewDataSource{
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}
extension VIPTableViewController : UITableViewDelegate {
    open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    open func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
