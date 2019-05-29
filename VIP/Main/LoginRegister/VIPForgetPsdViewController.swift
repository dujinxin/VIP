//
//  VIPForgetPsdViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/29/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

class VIPForgetPsdViewController: VIPBaseViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight
        }
    }
    
    @IBOutlet weak var psdTextField: UITextField!{
        didSet{
            
            psdTextField.rightViewMode = .always
            psdTextField.rightView = {() -> UIView in
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
    @IBOutlet weak var psdRepeatTextField: UITextField!{
        didSet{
            
            psdRepeatTextField.rightViewMode = .always
            psdRepeatTextField.rightView = {() -> UIView in
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
    
    //var vm = LoginVM()
    
    var isCounting: Bool = false
    
    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.psdTextField,self.psdRepeatTextField])
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
        
        //self.view.insertSubview(self.customNavigationBar, aboveSubview: self.contentView)
        self.title = "忘记密码"
        self.view.addSubview(self.keyboard)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        //self.updateButtonStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
        if let controllers = self.navigationController?.viewControllers {
            if controllers.count > 1 {
                self.navigationController?.viewControllers.remove(at: 0)
            }
        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
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
    
    @objc func switchPsd(button: UIButton) {
        //        button.isSelected = !button.isSelected
        //        if button.isSelected {
        //            self.passwordTextField.isSecureTextEntry = false
        //        }else{
        //            self.passwordTextField.isSecureTextEntry = true
        //        }
    }
    
    
    @IBAction func logAction(_ sender: Any) {
        //        guard String.validate(userTextField.text, type: .phone, emptyMsg: "手机号未填写", formatMsg: "手机号填写错误") == true else { return }
        //        guard String.validate(codeTextField.text, type: .code4, emptyMsg: "短信验证码未填写", formatMsg: "短信验证码填写错误") == true else { return }
        //        //guard String.validate(passwordTextField.text, type: RegularExpression, emptyMsg: "密码未填写", formatMsg: "密码格式错误") == true else { return }
        //        guard let password = self.passwordTextField.text, password.isEmpty == false else {
        //            ViewManager.showNotice("密码未填写")
        //            return
        //        }
        //
        //        if self.validate(password) == false {
        //            ViewManager.showNotice("密码格式错误")
        //            return
        //        }
        //        self.showMBProgressHUD()
        //
        //        self.vm.register(mobile: userTextField.text!, password: passwordTextField.text ?? "", mobileCode: codeTextField.text!) { (_, msg, isSuccess) in
        //            self.hideMBProgressHUD()
        //            ViewManager.showNotice(msg)
        //            if isSuccess {
        //                //已实名
        //                self.dismiss(animated: true, completion: {
        //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: NotificationLoginStatus), object: true)
        //                })
        //            }
        //        }
    }
    
    func validate(_ string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$")
        return predicate.evaluate(with: string)
    }
}

extension VIPForgetPsdViewController: UITextFieldDelegate,JXKeyboardTextFieldDelegate {
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        if textField == passwordTextField {
        //            self.logAction(0)
        //            return textField.resignFirstResponder()
        //        } else if textField == imageTextField {
        //            codeTextField.becomeFirstResponder()
        //            return false
        //        }
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //        if textField == userTextField {
        //            if range.location > 10 {
        //                return false
        //            }
        //        } else if textField == codeTextField || textField == imageTextField{
        //            if range.location > 3 {
        //                return false
        //            }
        //        } else if textField == passwordTextField {
        //            if range.location > 19 {
        //                return false
        //            }
        //        }
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        if textField == passwordTextField {
        //            self.logAction(0)
        //            return textField.resignFirstResponder()
        //        } else if textField == imageTextField {
        //            codeTextField.becomeFirstResponder()
        //            return false
        //        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //        if textField == userTextField {
        //            if range.location > 10 {
        //                return false
        //            }
        //        } else if textField == codeTextField {
        //            if range.location > 3 {
        //                return false
        //            }
        //        }
        return true
    }
    @objc func textChange(notify: NSNotification) {
        
        if notify.object is UITextField {
            //self.updateButtonStatus()
        }
    }
    //    func updateButtonStatus() {
    //        //登录按钮
    //        if
    //            let name = self.userTextField.text, name.isEmpty == false,
    //            let password = self.passwordTextField.text, password.isEmpty == false,
    //            let card = self.codeTextField.text, card.isEmpty == false{
    //
    //            self.loginButton.isEnabled = true
    //            self.loginButton.backgroundColor = JXMainColor
    //            self.loginButton.setTitleColor(JXMainTextColor, for: .normal)
    //
    //        } else {
    //
    //            self.loginButton.isEnabled = false
    //            self.loginButton.backgroundColor = UIColor.rgbColor(rgbValue: 0x9b9b9b)
    //            self.loginButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xb5b5b5), for: .normal)
    //
    //        }
    //        //验证码按钮
    //        if
    //            let name = self.userTextField.text, name.isEmpty == false,
    //            let imageCode = self.imageTextField.text, imageCode.isEmpty == false, self.isCounting == false{
    //
    //            self.fetchButton.isEnabled = true
    //            self.fetchButton.backgroundColor = JXMainColor
    //            self.fetchButton.setTitleColor(JXMainTextColor, for: .normal)
    //
    //        } else {
    //
    //            self.fetchButton.isEnabled = false
    //            self.fetchButton.backgroundColor = UIColor.rgbColor(rgbValue: 0x9b9b9b)
    //            self.fetchButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xb5b5b5), for: .normal)
    //
    //        }
    //    }
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
