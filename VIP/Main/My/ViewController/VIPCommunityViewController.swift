//
//  VIPCommunityViewController.swift
//  VIP
//
//  Created by 飞亦 on 6/4/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import MJRefresh

class VIPCommunityViewController: VIPTableViewController{
    
    @IBOutlet weak var mainScrollView: UIScrollView!{
        didSet{
            self.mainScrollView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight
        }
    }
    
    @IBOutlet weak var communityValueLabel: UILabel!
    @IBOutlet weak var availalbeAccountLabel: UILabel!
    @IBOutlet weak var communityRewardLabel: UILabel!
    @IBOutlet weak var normalRewardLabel: UILabel!

    var entity : VIPCommunityModel!
    var vm = VIPCommunityVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
    
        self.tableView.register(UINib(nibName: "VIPCommunityHeadCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierHeadCell")
        self.tableView.register(UINib(nibName: "VIPCommunityListCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierListCell")

        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = JXViewBgColor
        
        self.tableView.removeFromSuperview()
        self.contentView.addSubview(self.tableView)
        //self.tableView.isHidden = true
        
        self.tableView.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
      
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: 1)
        })
        self.updateValues()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func updateValues() {
        if self.entity.list.count > 0 {
            
//            self.communityValueLabel.text = "\(self.entity.memberEntity.team_market_value )"
//            self.availalbeAccountLabel.text = "\(self.entity.memberEntity.valid_count )"
//            self.communityRewardLabel.text = "\(self.entity.memberEntity.team_price )"
//            self.normalRewardLabel.text = "\(self.entity.memberEntity.level_price )"
//            self.tableView.isHidden = false
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
            
            self.defaultView.frame = CGRect(x: 0, y: kNavStatusHeight + 180 + 40, width: kScreenWidth, height: kScreenHeight - 180 - 40 - kNavStatusHeight)
        }
    }
    override func request(page: Int) {
        
        self.vm.community { (_, msg, isSuc) in
            self.tableView.mj_header.endRefreshing()
            if isSuc {
                self.updateValues()
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entity.list.count + 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierHeadCell", for: indexPath) as! VIPCommunityHeadCell
            cell.entity = self.entity.memberEntity
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierListCell", for: indexPath) as! VIPCommunityListCell
            let entity = self.entity.list[indexPath.row - 1]
            cell.entity = entity
            return cell
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
