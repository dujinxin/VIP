//
//  VIPNotificationViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPNotificationViewController: VIPTableViewController{
    
    var actionArray = ["语言","意见反馈","关于我们"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        self.tableView.register(UINib(nibName: "VIPNotificationCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCell")
        
        self.tableView.estimatedRowHeight = 66
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 15)
        v.backgroundColor = JXEeeeeeColor//JXViewBgColor
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierCell", for: indexPath) as! VIPNotificationCell
        let title = actionArray[indexPath.row]
        cell.titleLabel.text = title
        cell.contentLabel.text = title
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "My", bundle: nil)
        let title = actionArray[indexPath.row]
        
        let vc = storyboard.instantiateViewController(withIdentifier: "export") as! VIPExportViewController
        vc.title = title
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
