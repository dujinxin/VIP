//
//  VIPRegisterViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/29/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

class VIPRegisterViewController: VIPBaseViewController {
    
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topContentView: UIView!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight
        }
    }
    @IBOutlet weak var itemTopConstraint: NSLayoutConstraint!{
        didSet{
            self.itemTopConstraint.constant = kStatusBarHeight
        }
    }
    @IBOutlet weak var languageButton: UIButton!
 
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var loginPsdTextField: UITextField!{
        didSet{
            loginPsdTextField.rightViewMode = .always
            loginPsdTextField.rightView = {() -> UIView in
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                button.setImage(UIImage(named: "close"), for: .normal)
                button.setImage(UIImage(named: "open"), for: .selected)
                button.addTarget(self, action: #selector(switchPsd), for: .touchUpInside)
                button.isSelected = false
                button.tag = 1
                return button
            }()
        }
    }
    @IBOutlet weak var loginPsdRepeatTextField: UITextField!{
        didSet{
            
            loginPsdRepeatTextField.rightViewMode = .always
            loginPsdRepeatTextField.rightView = {() -> UIView in
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                button.setImage(UIImage(named: "close"), for: .normal)
                button.setImage(UIImage(named: "open"), for: .selected)
                button.addTarget(self, action: #selector(switchPsd), for: .touchUpInside)
                button.isSelected = false
                button.tag = 2
                return button
            }()
        }
    }
    @IBOutlet weak var tradePsdTextField: UITextField!{
        didSet{
            
            tradePsdTextField.rightViewMode = .always
            tradePsdTextField.rightView = {() -> UIView in
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                button.setImage(UIImage(named: "close"), for: .normal)
                button.setImage(UIImage(named: "open"), for: .selected)
                button.addTarget(self, action: #selector(switchPsd), for: .touchUpInside)
                button.isSelected = false
                button.tag = 3
                return button
            }()
        }
    }
    @IBOutlet weak var tradePsdRepeatTextField: UITextField!{
        didSet{
            
            tradePsdRepeatTextField.rightViewMode = .always
            tradePsdRepeatTextField.rightView = {() -> UIView in
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                button.setImage(UIImage(named: "close"), for: .normal)
                button.setImage(UIImage(named: "open"), for: .selected)
                button.addTarget(self, action: #selector(switchPsd), for: .touchUpInside)
                button.isSelected = false
                button.tag = 4
                return button
            }()
        }
    }
    @IBOutlet weak var inviteTextField: UITextField!{
        didSet{
            
//            inviteTextField.rightViewMode = .always
            inviteTextField.rightView = {() -> UIView in
                let button = UIButton(type: .custom)
                button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
                button.setImage(UIImage(named: "scan"), for: .normal)
                button.addTarget(self, action: #selector(switchPsd), for: .touchUpInside)
                
                return button
            }()
        }
    }
    @IBOutlet weak var agreeButton: UIButton!{
        didSet{
            self.agreeButton.isSelected = true
            self.agreeButton.setImage(UIImage(named: "accessory"), for: .selected)
            self.agreeButton.setImage(UIImage(named: "unSelected"), for: .normal)
        }
    }
    
    @IBOutlet weak var readLabel: UILabel!
    @IBOutlet weak var privateButton: UIButton!{
        didSet{
            
        }
    }
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            
        }
    }
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var goLoginButton: UIButton!{
        didSet{
            
        }
    }
    
    @IBOutlet weak var topConstraints: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraints: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraints: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraints: NSLayoutConstraint!
    
    var vm = VIPLoginRegisterVM()
    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.phoneTextField,self.loginPsdTextField,self.loginPsdRepeatTextField,self.tradePsdTextField,self.tradePsdRepeatTextField,self.inviteTextField])
        k.showBlock = { (height, rect) in
            print(height,rect)
        }
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.textFieldDelegate = self
        return k
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
           
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.customNavigationBar.removeFromSuperview()
        self.view.addSubview(self.keyboard)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        
        
//        self.phoneTextField.text = "123312343"
//        self.loginPsdTextField.text = "12345678"
//        self.loginPsdRepeatTextField.text = "12345678"
//        self.tradePsdTextField.text = "12345678"
//        self.tradePsdRepeatTextField.text = "12345678"
//        self.inviteTextField.text = "j09qA2"
        
        self.updateValues()
        self.updateButtonStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let controllers = self.navigationController?.viewControllers {
            if controllers.count > 1 {
                self.navigationController?.viewControllers.remove(at: 0)
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    //    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        self.view.endEditing(true)
    //    }
    
    @objc func hideKeyboard() {
        //        self.view.endEditing(true)
    }
    @IBAction func switchLanguage(_ sender: Any) {
        self.view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "languageAlert") as! VIPLanguageAlertController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        //vc.walletListEntity = self.vm.walletListEntity
        //vc.programEntity = entity
        vc.switchBlock = { isChanged in
            if let _ = self.maskView.superview {
                self.maskView.removeFromSuperview()
            }
            if isChanged {
                //
                self.updateValues()
            }
        }
        self.present(vc, animated: true, completion:{
            //self.maskView.alpha = 1
        })
        self.view.addSubview(self.maskView)
    }
    
    lazy var maskView: UIView = {
        let v = UIView(frame: UIScreen.main.bounds)
        v.backgroundColor = UIColor.rgbColor(rgbValue: 0x000000, alpha: 0.4)
        return v
    }()
    @objc func switchPsd(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.tag == 1 {
            if button.isSelected {
                self.loginPsdTextField.isSecureTextEntry = false
            }else{
                self.loginPsdTextField.isSecureTextEntry = true
            }
        } else if button.tag == 2 {
            self.loginPsdRepeatTextField.isSecureTextEntry = !button.isSelected
        } else if button.tag == 3 {
            self.tradePsdTextField.isSecureTextEntry = !button.isSelected
        } else if button.tag == 4 {
            self.tradePsdRepeatTextField.isSecureTextEntry = !button.isSelected
        } else {//扫描邀请码
            //
        }
    }
    
    @IBAction func agree(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        self.updateButtonStatus()
    }
    @IBAction func checkPrivate(_ sender: UIButton) {
        //查看协议
    }
    
    @IBAction func logAction(_ sender: Any) {
        guard let userName = self.phoneTextField.text, userName.count >= 5 else {
            ViewManager.showNotice("名称需要设置5位以上！")
            return
        }
        
        guard let login_password = self.loginPsdTextField.text, login_password.count >= 6 else {
            ViewManager.showNotice("登录密码需要设置6位以上！")
            return
        }
        guard let password_again = self.loginPsdRepeatTextField.text, password_again == login_password else {
            ViewManager.showNotice("登录密码不一致！")
            return
        }
        
        guard let trade_password = self.tradePsdTextField.text, trade_password.count == 6 else {
            ViewManager.showNotice("交易密码需设置6位数字！")
            return
        }
        guard let trade_password_again = self.tradePsdRepeatTextField.text, trade_password_again == trade_password else {
            ViewManager.showNotice("交易密码不一致！")
            return
        }
        
        if let inviteCode = self.inviteTextField.text, inviteCode.isEmpty == false {
            self.showMBProgressHUD()
            
            self.vm.register(username: userName, password: login_password, pay_password: trade_password, invitation_code: self.inviteTextField.text ?? "") { (_, msg, isSuccess) in
                self.hideMBProgressHUD()
                ViewManager.showNotice(msg)
                if isSuccess {
                    
                    let storyboard = UIStoryboard.init(name: "My", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "backUp") as! VIPBackUpViewController
                    vc.isRegister = 1
                    vc.title = "备份助记词"
                    vc.mnemonicStr = UserManager.manager.userEntity.mnemonic ?? ""
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else {
            let alertVC = UIAlertController(title: "系统提示", message: "未填写推荐码，将安排默认推荐码", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
                
                self.showMBProgressHUD()
                
                self.vm.register(username: userName, password: login_password, pay_password: trade_password, invitation_code: self.inviteTextField.text ?? "") { (_, msg, isSuccess) in
                    self.hideMBProgressHUD()
                    ViewManager.showNotice(msg)
                    if isSuccess {
                        
                        let storyboard = UIStoryboard.init(name: "My", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "backUp") as! VIPBackUpViewController
                        vc.isRegister = 1
                        vc.title = "备份助记词"
                        vc.mnemonicStr = UserManager.manager.userEntity.mnemonic ?? ""
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }))
            alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
            }))
            
            self.present(alertVC, animated: true, completion: nil)
        }
        
    }
    //[a-zA-Z0-9]{8,20}+$                             8-20位数字或字母
    //^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$    8-20位数字加字母的组合
    func validate(_ string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$")
        return predicate.evaluate(with: string)
    }
    func updateValues() {
        languageButton.setTitle(LocalizedString(key: "Language"), for: .normal)
        
        phoneTextField.placeholder = LocalizedString(key: "Register_nameTextField_placeholder")
        loginPsdTextField.placeholder = LocalizedString(key: "Register_loginPsdTextField_placeholder")
        loginPsdRepeatTextField.placeholder = LocalizedString(key: "Register_loginPsdTextField_repeat_placeholder")
        tradePsdTextField.placeholder = LocalizedString(key: "Register_tradePsdTextField_placeholder")
        tradePsdRepeatTextField.placeholder = LocalizedString(key: "Register_tradePsdTextField_repeat_placeholder")
        inviteTextField.placeholder = LocalizedString(key: "Register_inviteTextField_placeholder")
        
        
        readLabel.text = LocalizedString(key: "Register_read_agree")
        privateButton.setTitle("《\(LocalizedString(key: "Register_user_agreement"))》", for: .normal)
        loginButton.setTitle(LocalizedString(key: "Register"), for: .normal)
        infoLabel.text = LocalizedString(key: "Registered")
        goLoginButton.setTitle(LocalizedString(key: "Register_gotologin"), for: .normal)
    }
}

extension VIPRegisterViewController: UITextFieldDelegate,JXKeyboardTextFieldDelegate {
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneTextField {
            loginPsdTextField.becomeFirstResponder()
            return false
        } else if textField == loginPsdTextField {
            loginPsdRepeatTextField.becomeFirstResponder()
            return false
        } else if textField == loginPsdRepeatTextField {
            tradePsdTextField.becomeFirstResponder()
            return false
        } else if textField == tradePsdTextField {
            tradePsdRepeatTextField.becomeFirstResponder()
            return false
        } else if textField == tradePsdRepeatTextField {
            inviteTextField.becomeFirstResponder()
            return false
        } else if textField == inviteTextField {
            self.logAction(0)
            textField.resignFirstResponder()
            return true
        }
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField || textField == loginPsdTextField || textField == loginPsdRepeatTextField {
            if range.location > 9 {
                return false
            }
        } else if textField == tradePsdTextField || textField == tradePsdRepeatTextField || textField == inviteTextField{
            if range.location > 5 {
                return false
            }
        }
        return true
    }
    
    @objc func textChange(notify: NSNotification) {
        
        if notify.object is UITextField {
            self.updateButtonStatus()
        }
    }
    func updateButtonStatus() {
        //登录按钮
        if
            let name = self.phoneTextField.text, name.isEmpty == false,
            let l_password = self.loginPsdTextField.text, l_password.isEmpty == false,
            let l_password_r = self.loginPsdRepeatTextField.text, l_password_r.isEmpty == false,
            let t_password = self.tradePsdTextField.text, t_password.isEmpty == false,
            let t_password_r = self.tradePsdRepeatTextField.text, t_password_r.isEmpty == false,
            self.agreeButton.isSelected == true{

            self.loginButton.isEnabled = true
            self.loginButton.backgroundColor = JXMainColor

        } else {

            self.loginButton.isEnabled = false
            self.loginButton.backgroundColor = JXlightBlueColor
        }
    }
    @objc func keyboardWillShow(notify:Notification) {
        
        guard
            let userInfo = notify.userInfo,
            let rect = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        
        //print(rect)//226
        UIView.animate(withDuration: animationDuration, animations: {
            self.mainScrollView.contentOffset = CGPoint(x: 0, y: 160)
            
        }) { (finish) in
            //
        }
    }
    @objc func keyboardWillHide(notify:Notification) {
        print("notify = ","notify")
        guard
            let userInfo = notify.userInfo,
            let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
            let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else {
                return
        }
        UIView.animate(withDuration: animationDuration, animations: {
            self.mainScrollView.contentOffset = CGPoint(x: 0, y: 0)
        }) { (finish) in
            
        }
    }
}
