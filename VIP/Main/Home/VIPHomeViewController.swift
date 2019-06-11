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

private let reuseIdentifierHeader = "reuseIdentifierHeader"
private let reuseIdentifierCell = "reuseIdentifierCell"

class VIPHomeViewController: VIPTableViewController {

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
            self.manageButton.setTitle("理财", for: .normal)
            
            manageButton.layer.cornerRadius = 4
            manageButton.layer.borderColor = JXFfffffColor.cgColor
            manageButton.layer.borderWidth = 1
            
        }
    }
    @IBOutlet weak var superNodeButton: UIButton!{
        didSet{
            self.superNodeButton.backgroundColor = JXBlueColor
            self.superNodeButton.setTitleColor(JXFfffffColor, for: .normal)
            self.superNodeButton.setTitle("超级节点", for: .normal)
            
            superNodeButton.layer.cornerRadius = 4
            superNodeButton.layer.borderColor = JXFfffffColor.cgColor
            superNodeButton.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var noticeBgView: UIView!
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
        if let block = superNodeBlock {
            block()
        }
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
    
    var vm = VIPHomeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.tableView.frame = CGRect(x: 0, y: kNavStatusHeight + 183, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - kTabBarHeight - 183)
        
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 83
        self.tableView.rowHeight = UITableView.automaticDimension
        
        //self.tableView.register(UINib(nibName: "VIPHomeHeaderCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierHeader)
        self.tableView.register(UINib(nibName: "VIPHomeCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierCell)
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestData()
        })
        
        //self.requestData()
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
                self.totalPropertyLabel.text = "\(self.vm.homeEntity.total_number)"
                self.todayIncomeLabel.text = "今日收益：\(self.vm.homeEntity.today_vit_number) XXX"
                self.tableView.reloadData()
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
        return self.vm.homeEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCell, for: indexPath) as! VIPHomeCell
        let entity = self.vm.homeEntity.list[indexPath.row]
        cell.coinTitleLabel.text = entity.short_name
        cell.coinNumLabel.text = "\(entity.available_qty)"
        cell.coinValueLabel.text = "$\(entity.price)"
        cell.numValueLabel.text = "$\(entity.price * entity.available_qty)"
        if let s = entity.icon,let url = URL(string: kBaseUrl + s) {
            print(url)
            cell.coinImageView.setImageWith(url, placeholderImage: nil)
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
            let entity = self.vm.homeEntity.list[indexPath.row]

            let vc  = VIPPropertyViewController()
            vc.title = entity.short_name
            vc.entity = entity

            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
    
    }

}
