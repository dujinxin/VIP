//
//  VIPSettingViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPSettingViewController: VIPTableViewController{
    
    var actionArray = [LocalizedString(key: "My_languageChoice"),LocalizedString(key: "My_feedback"),LocalizedString(key: "My_aboutUs"),LocalizedString(key: "My_version")]
    
    var isModify: Bool = false
    
    lazy var maskView: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        v.backgroundColor = UIColor.rgbColor(rgbValue: 0x000000, alpha: 0.4)
        return v
    }()
    
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
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 15)
        v.backgroundColor = JXEeeeeeColor//JXViewBgColor
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
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
        
        if indexPath.section == 3 {
            cell.selectLabel.text = "\(Bundle.main.version)"
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "My", bundle: nil)
        let title = actionArray[indexPath.section]
        if indexPath.section == 0 {
            let vc = VIPLanguageViewController()
            vc.title = title
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 1{
            let vc = storyboard.instantiateViewController(withIdentifier: "feedBack") as! VIPFeedBackViewController
            vc.title = title
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            let vc = storyboard.instantiateViewController(withIdentifier: "aboutUs") as! VIPAboutUsViewController
            vc.title = title
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
         
            self.showMBProgressHUD()
            let v = VIPVersionVM()
            v.version { (_, msg, isSuc) in
                self.hideMBProgressHUD()
                if isSuc && v.versionEntity.ios_version != Bundle.main.version {
                    let vc = storyboard.instantiateViewController(withIdentifier: "versionAlert") as! VIPVersionAlertController
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    vc.title = title
                    vc.entity = v.versionEntity
                    
                    vc.callBackBlock = { isDownload in
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
                    
                    self.view.addSubview(self.maskView)
                    self.present(vc, animated: true, completion:{
                        //self.maskView.alpha = 1
                    })
                    
                } else {
                    ViewManager.showNotice(LocalizedString(key: "Notice_version"))
                }
            }
            
            
        }
        
    }
}
