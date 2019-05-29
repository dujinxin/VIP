//
//  VIPMyViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPMyViewController: VIPTableViewController{
    
    var actionArray = [
        [
            ["image":"promotion","title":"我的推广"],
            ["image":"community","title":"我的社区"],
            ["image":"income","title":"我的收益"]
        ],
        [
            ["image":"safety","title":"安全中心"],
            ["image":"notification","title":"通知中心"],
            ["image":"setting","title":"设置"]
        ]
    ]
    
    //var vm = LoginVM()
   
    var textField : UITextField!
    
    var nickName = ""
    
    var isModify: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar.removeFromSuperview()
        
        self.tableView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kTabBarHeight)
        self.tableView.register(UINib(nibName: "VIPMyListCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierCell")
        self.tableView.register(UINib(nibName: "VIPMyHeadCell", bundle: nil), forCellReuseIdentifier: "reuseIdentifierHeader")
        self.tableView.estimatedRowHeight = 64
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.isScrollEnabled = false
        self.tableView.separatorStyle = .none

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
//        if !UserManager.manager.isLogin {
//            let storyboard = UIStoryboard(name: "Login", bundle: nil)
//            let login = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
//            let loginVC = UINavigationController.init(rootViewController: login)
//            self.navigationController?.present(loginVC, animated: false, completion: nil)
//        } else {
//            self.requestData()
//        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barStyle = .default
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "accound" {
            
        }
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return true
    }
    override func requestData() {
//        self.vm.personInfo { (data, msg, isSuccess) in
//            if isSuccess == true {
//                self.tableView.reloadData()
//                if self.isModify == true {
//                    UserManager.manager.updateAvatar(self.vm.profileInfoEntity?.headImg ?? "")
//                    self.isModify = false
//                }
//            } else {
//                ViewManager.showNotice(msg)
//            }
//        }
    }
    @IBAction func edit(_ sender: UIButton) {
        
        //        let alertVC = UIAlertController(title: "修改昵称", message: nil, preferredStyle: .alert)
        //        //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
        //        alertVC.addTextField(configurationHandler: { (textField) in
        //            textField.text = self.vm.profileInfoEntity?.nickname
        //            textField.delegate = self
        //            //textField.addTarget(self, action: #selector(self.valueChanged(textField:)), for: .editingChanged)
        //        })
        //        alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
        //
        //            if
        //                let textField = alertVC.textFields?[0],
        //                let text = textField.text,
        //                text.isEmpty == false,
        //                text != self.vm.profileInfoEntity?.nickname{
        //
        //                self.showMBProgressHUD()
        //                self.vm.modify(nickName: text, completion: { (_, msg, isSuccess) in
        //                    self.hideMBProgressHUD()
        //                    if isSuccess == false {
        //                        ViewManager.showNotice(msg)
        //                    } else {
        //                        self.vm.profileInfoEntity?.nickname = text
        //                        UserManager.manager.updateNickName(text)
        //                        self.tableView.reloadData()
        //                    }
        //                })
        //            }
        //        }))
        //        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        //        }))
        //        self.present(alertVC, animated: true, completion: nil)
    }
    @objc func logout(button: UIButton) {
        
    }
    @objc func valueChanged(textField:UITextField) {
        let maxLength = 12
        
        guard let string = textField.text as NSString? else {
            return
        }
        //当前输入框语言
        let lang = textField.textInputMode?.primaryLanguage
        //系统语言
        //let lang = UIApplication.shared.textInputMode?.primaryLanguage
        if lang == "zh-Hans" {
            guard
                let selectedRange = textField.markedTextRange,
                let position = textField.position(from: selectedRange.start, offset: 0) else{
                    return
            }
            print(position)
            if string.length > maxLength {
                let rangeIndex = string.rangeOfComposedCharacterSequence(at: maxLength)
                if rangeIndex.length == 1 {
                    textField.text = string.substring(to: maxLength)
                } else {
                    let range = string.rangeOfComposedCharacterSequences(for: NSRange.init(location: 0, length: maxLength))
                    textField.text = string.substring(with: range)
                }
            }
        } else {
            if string.length > maxLength {
                print(string.length)
                let rangeIndex = string.rangeOfComposedCharacterSequence(at: maxLength)
                if rangeIndex.length == 1 {
                    textField.text = string.substring(to: maxLength)
                } else {
                    let range = string.rangeOfComposedCharacterSequences(for: NSRange.init(location: 0, length: maxLength))
                    textField.text = string.substring(with: range)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 15)
        v.backgroundColor = JXEeeeeeColor//JXViewBgColor
        return v
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 2 {
            return 15
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 2 {
            let v = UIView()
            v.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 120)
            
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 30 , y: 35, width: kScreenWidth - 60, height: 50)
            button.setTitle("退出登录", for: .normal)
            button.setTitleColor(JXBlueColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.addTarget(self, action: #selector(logout(button:)), for: .touchUpInside)
            button.layer.borderColor = JXGrayTextColor.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 6
            
            v.addSubview(button)
            return v
        }
        return UIView()
    }
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 120
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return (actionArray[section - 1] as AnyObject).count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //return UITableViewAutomaticDimension
        if indexPath.section == 0 {
            return 124 + 20 + kNavStatusHeight
        } else {
            return 50
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierHeader", for: indexPath) as! VIPMyHeadCell
//
//            if let str = self.vm.profileInfoEntity?.headImg {
//                let url = URL.init(string:str)
//                cell.userImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "defaultImage"), options: [], completed: nil)
//                //cell.userImageView.sd_setImage(with: url, completed: nil)
//            }
//            cell.nickNameLabel.text = self.vm.profileInfoEntity?.nickname
//            cell.editButton.addTarget(self, action: #selector(edit(_:)), for: .touchUpInside)
//            cell.rankLabel.text = self.vm.profileInfoEntity?.mobile
//            cell.modifyBlock = {
//                let storyboard = UIStoryboard(name: "Task", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "ModifyImageVC") as! ModifyImageController
//                vc.hidesBottomBarWhenPushed = true
//                vc.avatar = self.vm.profileInfoEntity?.headImg
//                vc.backBlock = {
//                    self.isModify = true
//                    self.requestData()
//                }
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifierCell", for: indexPath) as! VIPMyListCell
            let dict = actionArray[indexPath.section - 1][indexPath.row]
            
            cell.iconView.image = UIImage(named: dict["image"]!)
            cell.titleView.text = dict["title"]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            
            
            
            
            //performSegue(withIdentifier: "property", sender: nil)
//            if UserManager.manager.userEntity.user.safePwdInit != 0 {
//                if UserManager.manager.userEntity.realName.isEmpty == false {
//                    let vc = PayListController()
//                    vc.hidesBottomBarWhenPushed = true
//                    self.navigationController?.pushViewController(vc, animated: true)
//                } else {
//                    let storyboard = UIStoryboard(name: "My", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "nameSet") as! NameSetController
//                    vc.hidesBottomBarWhenPushed = true
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            } else {
//                self.showNoticeView()
//            }
            
        } else {
            let storyboard = UIStoryboard(name: "My", bundle: nil)
            let dict = actionArray[indexPath.section - 1][indexPath.row]
            if indexPath.section == 1 {
                if indexPath.row == 0 {
                    let vc = storyboard.instantiateViewController(withIdentifier: "promotion") as! VIPPromotionViewController
                    vc.title = dict["title"]
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if indexPath.row == 1{
                    let vc = storyboard.instantiateViewController(withIdentifier: "promotion") as! VIPPromotionViewController
                    vc.title = dict["title"]
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = storyboard.instantiateViewController(withIdentifier: "promotion") as! VIPPromotionViewController
                    vc.title = dict["title"]
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            } else {
                if indexPath.row == 0 {
                    let vc = VIPSafetyViewController()
                    vc.title = dict["title"]
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else if indexPath.row == 1{
                    let vc = VIPNotificationViewController()
                    vc.title = dict["title"]
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = VIPSettingViewController()
                    vc.title = dict["title"]
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    }
}
extension VIPMyViewController : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if range.location > 11 {
            //let s = textField.text! as NSString
            //let str = s.substring(to: 10)
            //textField.text = str
            //ViewManager.showNotice(notice: "字符个数为11位")
            return false
        }
        return true
    }
}
