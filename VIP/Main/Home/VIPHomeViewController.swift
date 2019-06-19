//
//  VIPHomeViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import MJRefresh
import JXFoundation
import SDCycleScrollView

private let reuseIdentifierHeader = "reuseIdentifierHeader"
private let reuseIdentifierCell = "reuseIdentifierCell"

class VIPHomeViewController: VIPTableViewController, SDCycleScrollViewDelegate {

    @IBOutlet weak var titleView: UILabel!{
        didSet{
            self.titleView.text = LocalizedString(key: "Home")
        }
    }
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight + 15
        }
    }
    @IBOutlet weak var propertyBgView: UIView!{
        didSet{
            self.propertyBgView.backgroundColor = JXBlueColor
            
//            propertyBgView.layer.cornerRadius = 4
//            propertyBgView.layer.shadowOpacity = 1
//            propertyBgView.layer.shadowRadius = 7
//            propertyBgView.layer.shadowColor = JXBlueShadow.cgColor
//            propertyBgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
    @IBOutlet weak var totalTitleLabel: UILabel!{
        didSet{
            self.totalTitleLabel.textColor = JXFfffffColor
        }
    }
    @IBOutlet weak var totalPropertyLabel: UILabel!{
        didSet{
            self.totalPropertyLabel.textColor = JXFfffffColor
        }
    }
    @IBOutlet weak var todayIncomeLabel: UILabel!{
        didSet{
            self.todayIncomeLabel.textColor = JXFfffffColor
        }
    }
    @IBOutlet weak var manageButton: UIButton!{
        didSet{
            self.manageButton.backgroundColor = JXFfffffColor
            self.manageButton.setTitleColor(JXBlueColor, for: .normal)
            self.manageButton.setTitle(LocalizedString(key: "Finance"), for: .normal)
            
            manageButton.layer.cornerRadius = 4
            manageButton.layer.borderColor = JXFfffffColor.cgColor
            manageButton.layer.borderWidth = 1
            
        }
    }
    @IBOutlet weak var superNodeButton: UIButton!{
        didSet{
            self.superNodeButton.backgroundColor = JXBlueColor
            self.superNodeButton.setTitleColor(JXFfffffColor, for: .normal)
            self.superNodeButton.setTitle(LocalizedString(key: "SuperNode"), for: .normal)
            
            superNodeButton.layer.cornerRadius = 4
            superNodeButton.layer.borderColor = JXFfffffColor.cgColor
            superNodeButton.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var noticeBgView: UIView!
    @IBOutlet weak var cycleScrollView: SDCycleScrollView!{
        didSet{
            self.cycleScrollView.isHidden = true
            self.cycleScrollView.delegate = self
          
            self.cycleScrollView.showPageControl = false
            
            self.cycleScrollView.autoScroll = true
            self.cycleScrollView.autoScrollTimeInterval = 3
            self.cycleScrollView.infiniteLoop = true
            
            self.cycleScrollView.scrollDirection = .vertical
            self.cycleScrollView.onlyDisplayText = true
            self.cycleScrollView.titleLabelTextColor = JXGrayTextColor
            self.cycleScrollView.titleLabelTextFont = UIFont.systemFont(ofSize: 15)
            self.cycleScrollView.titleLabelBackgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var noticeLabel: UILabel!{
        didSet{
            self.noticeLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(noticeAction(_:))))
        }
    }
    @IBOutlet weak var moreButton: UIButton!
    
    
    
    var financialManagementBlock : (()->())?
    var superNodeBlock : (()->())?
    var noticeBlock : (()->())?
    var moreBlock : (()->())?
    
    @IBAction func financialManagementAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Find", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "financialManagement") as! VIPFinancialManagementController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func superNodeAction(_ sender: Any) {
        ViewManager.showNotice(LocalizedString(key: "To be developed, please look forward"))
    }
    @IBAction func moreAction(_ sender: Any) {
        let vc = VIPNotificationViewController()
        vc.title = LocalizedString(key: "Notification")
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func noticeAction(_ sender: Any) {
        if let block = noticeBlock {
            block()
        }
    }
    
    lazy var maskView: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        v.backgroundColor = UIColor.rgbColor(rgbValue: 0x000000, alpha: 0.4)
        return v
    }()
    
    var vm = VIPHomeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cycleScrollView.titleLabelBackgroundColor = UIColor.clear
        
        self.tableView.frame = CGRect(x: 0, y: kNavStatusHeight + 183, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - kTabBarHeight - 183)
        
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 83
        self.tableView.rowHeight = UITableView.automaticDimension
        
        //self.tableView.register(UINib(nibName: "VIPHomeHeaderCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierHeader)
        self.tableView.register(UINib(nibName: "VIPHomeCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierCell)
        
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestData()
        })
        
        if UserManager.manager.isLogin {
            let v = VIPVersionVM()
            v.version { (_, msg, isSuc) in
                
                if isSuc && v.versionEntity.ios_version != Bundle.main.version {
                    let storyboard = UIStoryboard(name: "My", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "versionAlert") as! VIPVersionAlertController
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    vc.entity = v.versionEntity
                    
                    let window = UIWindow()
                    window.frame = UIScreen.main.bounds
                    window.windowLevel = UIWindow.Level.alert + 1
                    window.backgroundColor = UIColor.clear
                    window.isHidden = false
                    let root = UIViewController()
                    root.view.backgroundColor = UIColor.clear
                    window.rootViewController = root
                    
                    vc.callBackBlock = { isDownload in
                        window.isHidden = true
                        if let _ = self.maskView.superview {
                            self.maskView.removeFromSuperview()
                        }
                        if isDownload {
                            guard
                                let text = v.versionEntity.ios_url,
                                let url = URL(string: text) else {
                                    return
                            }
                            if UIApplication.shared.canOpenURL(url) {
                                if #available(iOS 10.0, *) {
                                    UIApplication.shared.open(url, options: [:]) { (isTrue) in
                                        
                                    }
                                } else {
                                    UIApplication.shared.openURL(url)
                                }
                            }
                        }
                        
                    }
                    
                    window.rootViewController?.view.addSubview(self.maskView)
                    window.rootViewController?.present(vc, animated: true, completion:{
                        //self.maskView.alpha = 1
                    })
                    
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserManager.manager.isLogin {
            self.tableView.mj_header.beginRefreshing()
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "login") as! VIPLoginViewController
            let loginVC = VIPNavigationController.init(rootViewController: login)
            
            self.present(loginVC, animated: false, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    override func requestData() {
        self.vm.home { (_, msg, isSuc) in
            self.tableView.mj_header.endRefreshing()
            if isSuc {
                self.totalPropertyLabel.text = String(format: "%.2f", self.vm.homeEntity.total_number)
                self.todayIncomeLabel.text = String(format: "\(LocalizedString(key: "Home_earningsToday"))：%.8f VIT", self.vm.homeEntity.today_vit_number)
                
                
                self.cycleScrollView.isHidden = false
                self.cycleScrollView.autoScrollTimeInterval = 3
                self.cycleScrollView.scrollDirection = .vertical
                self.cycleScrollView.onlyDisplayText = true
                self.cycleScrollView.titleLabelTextColor = JXGrayTextColor
                self.cycleScrollView.titleLabelTextFont = UIFont.systemFont(ofSize: 15)
                self.cycleScrollView.titleLabelBackgroundColor = UIColor.clear
                self.cycleScrollView.titlesGroup = self.vm.homeEntity.contentList
                
                self.tableView.reloadData()
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
    // MARK: - SDCycleScrollViewDelegate
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        print(index)
        let entity = self.vm.homeEntity.noticeList[index]

        if entity.content_type == 1 {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "notification_text") as! VIPNotificationTextController
            vc.entity = entity
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = VIPWebViewController()
            vc.title = entity.title
            vc.urlStr = entity.link
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.homeEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCell, for: indexPath) as! VIPHomeCell
        let entity = self.vm.homeEntity.list[indexPath.row]
        cell.coinTitleLabel.text = entity.short_name
        cell.coinNumLabel.text = String(format: "%.8f", entity.available_qty)
        cell.coinValueLabel.text = "$\(entity.price)"
        cell.numValueLabel.text = String(format: "$%.8f", entity.price * entity.available_qty)
        if let s = entity.icon,let url = URL(string: kBaseUrl + s) {
            print(url)
            cell.coinImageView.setImageWith(url, placeholderImage: UIImage(named: "coin"))
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let entity = self.vm.homeEntity.list[indexPath.row]

        let vc  = VIPPropertyViewController()
        vc.title = entity.short_name
        vc.entity = entity

        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    
    }

}
