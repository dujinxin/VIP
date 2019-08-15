//
//  VIPAddressListController.swift
//  VIP
//
//  Created by 飞亦 on 7/25/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import MJRefresh

enum FromType : Int{
    case my  =  1
    case transfer  =  2
}


private let reuseIdentifier = "reuseIdentifier"

class VIPAddressListController: VIPTableViewController {
    
    var vm = VIPPropertyVM()
    var type : FromType = .my
    
    var coin_id : Int = 0
    var coin_name : String?
    
    open var selectBlock : ((_ address: String)->())?
    
    lazy var addButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizedString(key: "Home_addAddress"), for: .normal)
        button.backgroundColor = JXBlueColor
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.addTarget(self, action: #selector(addAddress), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedString(key: "Home_addressBookList")
        
        self.tableView.frame = CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - kBottomMaginHeight - 20 * 2 - 50)
        self.tableView.separatorStyle = .none
        //self.tableView.rowHeight = 135
        self.tableView.register(UINib(nibName: "VIPAddressCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.page = 1
            self.request(page: 1)
        })
        
        self.tableView.mj_header.beginRefreshing()
        
        self.addButton.frame = CGRect(x: 15, y: self.tableView.jxBottom + 20, width: kScreenWidth - 30, height: 50)
        self.view.addSubview(self.addButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func addAddress() {
        let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "add") as! VIPAddressAddController
        vc.backBlock = {
            self.tableView.mj_header.beginRefreshing()
        }
        vc.type = .add
        vc.fromType = self.type
        vc.coinId = self.coin_id
        vc.coinName = self.coin_name
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func request(page: Int) {
        
        self.vm.addressList(page: page, coin_id: self.coin_id) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            self.tableView.mj_header.endRefreshing()
            self.tableView.reloadData()
            if isSuc == true && self.vm.addressListEntity.list.count > 0 {
                self.tableView.isHidden = false
                self.defaultView.isHidden = true
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
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vm.addressListEntity.list.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! VIPAddressCell
        let entity = self.vm.addressListEntity.list[indexPath.row]
        cell.entity = entity
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let entity = self.vm.addressListEntity.list[indexPath.row]
        
        
        if self.type == .my {
            let vc = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "add") as! VIPAddressAddController
            vc.backBlock = {
                self.tableView.mj_header.beginRefreshing()
            }
            vc.type = .edit
            vc.address = entity.address
            vc.addressName = entity.address_remark
            vc.addressId = entity.id
            vc.coinName = entity.currency_name
            vc.coinId = entity.currency_id
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if entity.verify_status == 0 {
                //ViewManager.showNotice("")
                return
            }
            if let block = self.selectBlock {
                block(entity.address ?? "")
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
