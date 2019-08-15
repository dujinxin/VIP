//
//  VIPLoginViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/29/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

class VIPLoginViewController: VIPBaseViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = 0
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
   
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            
        }
    }
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var goRegisterButton: UIButton!{
        didSet{
            
        }
    }
    @IBOutlet weak var forgetButton: UIButton!{
        didSet{
            
        }
    }
    
    var vm = VIPLoginRegisterVM()
 
    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.phoneTextField,self.loginPsdTextField])
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
        
//        self.phoneTextField.text = "123312343"
//        self.loginPsdTextField.text = "12345678"
        
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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
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
            if isChanged == true {
                //更新UI
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
        if button.isSelected {
            self.loginPsdTextField.isSecureTextEntry = false
        }else{
            self.loginPsdTextField.isSecureTextEntry = true
        }
        
    }
    

    @IBAction func logAction(_ sender: Any) {
    
        guard let user = self.phoneTextField.text, user.count >= 5  else {
            ViewManager.showNotice(LocalizedString(key: "Notice_nameError"))
            return
        }
        guard let password = self.loginPsdTextField.text, password.count >= 6 else {
            ViewManager.showNotice(LocalizedString(key: "Notice_passwordError"))
            return
        }

//        if self.validate(password) == false {
//            ViewManager.showNotice("密码格式错误")
//            return
//        }
        self.showMBProgressHUD()

        self.vm.login(userName: user, password: password) { (_, msg, isSuccess) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuccess {
                //已实名
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationLoginStatus"), object: true)
                })
            }
        }
    }
    @IBAction func forgetPsd(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Login", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "forget") as! VIPForgetPsdViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func validate(_ string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$")
        return predicate.evaluate(with: string)
    }

    func updateValues() {
        languageButton.setTitle(LocalizedString(key: "Language"), for: .normal)
        
        phoneTextField.placeholder = LocalizedString(key: "Register_nameTextField_placeholder")
        loginPsdTextField.placeholder = LocalizedString(key: "Login_psdTextField_placeholder")
        
        
        loginButton.setTitle(LocalizedString(key: "Login"), for: .normal)
        infoLabel.text = LocalizedString(key: "Login_noAccountYet")
        goRegisterButton.setTitle(LocalizedString(key: "Login_goToRegister"), for: .normal)
        forgetButton.setTitle(LocalizedString(key: "Login_forgetPassword"), for: .normal)
    }
}

extension VIPLoginViewController: UITextFieldDelegate,JXKeyboardTextFieldDelegate {
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneTextField {
            loginPsdTextField.becomeFirstResponder()
            return false
        } else if textField == loginPsdTextField {
            self.logAction(0)
            textField.resignFirstResponder()
            return true
        }
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneTextField || textField == loginPsdTextField  {
            if range.location > 9 {
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
            let password = self.loginPsdTextField.text, password.isEmpty == false{
            
            self.loginButton.isEnabled = true
            self.loginButton.backgroundColor = JXMainColor
            
        } else {
            self.loginButton.isEnabled = false
            self.loginButton.backgroundColor = JXlightBlueColor
            
        }
    }
}

