//
//  VIPLanguageViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/29/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPLanguageViewController: VIPTableViewController{
    
    var actionArray = ["简体中文","English"]
    
    var selectedRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        self.tableView.register(UINib(nibName: "VIPSelectCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCell")
        
        self.tableView.estimatedRowHeight = 50
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return actionArray.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierCell", for: indexPath) as! VIPSelectCell
        let title = actionArray[indexPath.section]
        cell.titleLabel.text = title
        if indexPath.section == selectedRow {
            cell.grayArrowImageView.image = UIImage(named: "accessory")
        } else {
            cell.grayArrowImageView.image = UIImage(named: "unSelected")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedRow = indexPath.section
//        tableView.visibleCells.forEach { (cell) in
//            let cell = cell as! VIPSelectCell
//            if indexPath.section == selectedRow {
//                cell.grayArrowImageView.image = UIImage(named: "accessory")
//            } else {
//                cell.grayArrowImageView.image = UIImage(named: "unSelected")
//            }
//        }
        tableView.reloadData()
    }
}
