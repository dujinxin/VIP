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
    
    var selectedRow : Int = 0
    var currentRow : Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-back"), style: .plain, target: self, action: #selector(back))
        self.tableView.register(UINib(nibName: "VIPSelectCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCell")
        
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.separatorStyle = .none
        
        
        if let language = UserDefaults.standard.object(forKey: "myLanguage") as? String, language.count > 0 {
            print(language)
            
            if language == LanguageType.chinese.rawValue {
                selectedRow = 0
                currentRow = 0
            } else {
                selectedRow = 1
                currentRow = 1
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func back() {
        if selectedRow == currentRow {
            self.navigationController?.popViewController(animated: true)
        } else {
            if selectedRow == 0 {
                LanaguageManager.shared.changeLanguage(.chinese)
            } else {
                LanaguageManager.shared.changeLanguage(.english)
            }
            LanaguageManager.shared.reset(nil)
            self.navigationController?.popViewController(animated: true)
        }
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
