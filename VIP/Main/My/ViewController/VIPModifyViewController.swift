//
//  VIPModifyViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

enum ModifyType : Int{
    case login  =  1
    case trade  =  2
}

class VIPModifyViewController: VIPBaseViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!{
        didSet{
            self.topHeightConstraint.constant = kNavStatusHeight + 10
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
                button.tag = 0
                return button
            }()
        }
    }
    @IBOutlet weak var newPsdTextField: UITextField!{
        didSet{
            
            newPsdTextField.rightViewMode = .always
            newPsdTextField.rightView = {() -> UIView in
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
    @IBOutlet weak var newPsdRepeatTextField: UITextField!{
        didSet{
            
            newPsdRepeatTextField.rightViewMode = .always
            newPsdRepeatTextField.rightView = {() -> UIView in
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
    
    @IBOutlet weak var confirmButton: UIButton!
    
    var type : ModifyType = .login
    
    var vm = VIPSafetyVM()
    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.psdTextField,self.newPsdTextField,self.newPsdRepeatTextField])
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
       
        self.view.addSubview(self.keyboard)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        if type == .login {
            self.confirmButton.setTitle("修改登录密码", for: .normal)
        } else {
            self.confirmButton.setTitle("修改交易密码", for: .normal)
        }
        
        self.updateButtonStatus()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.navigationController?.isNavigationBarHidden = true
//
//        if let controllers = self.navigationController?.viewControllers {
//            if controllers.count > 1 {
//                self.navigationController?.viewControllers.remove(at: 0)
//            }
//        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        self.navigationController?.isNavigationBarHidden = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func hideKeyboard() {
        //        self.view.endEditing(true)
    }
    
    @objc func switchPsd(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.tag == 0 {
            if button.isSelected {
                self.psdTextField.isSecureTextEntry = false
            }else{
                self.psdTextField.isSecureTextEntry = true
            }
        } else if button.tag == 1 {
            if button.isSelected {
                self.newPsdTextField.isSecureTextEntry = false
            }else{
                self.newPsdTextField.isSecureTextEntry = true
            }
        } else {
            if button.isSelected {
                self.newPsdRepeatTextField.isSecureTextEntry = false
            }else{
                self.newPsdRepeatTextField.isSecureTextEntry = true
            }
        }
        
    }
    
    
    @IBAction func confirmAction(_ sender: Any) {
        
        guard let used_password = self.psdTextField.text else {
            return
        }
        guard let new_password = self.newPsdTextField.text else {
            return
        }
        guard let new_password_again = self.newPsdRepeatTextField.text, new_password_again == new_password else {
            ViewManager.showNotice("新密码不一致！")
            return
        }
        self.showMBProgressHUD()

        self.vm.modifyPsd(type: self.type.rawValue, used_password: used_password, new_password: new_password, completion: { (_, msg, isSuccess) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuccess {
                self.navigationController?.popToRootViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationLoginStatus"), object: false)
            }
        })
    }
    
    func validate(_ string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$")
        return predicate.evaluate(with: string)
    }
}

extension VIPModifyViewController: UITextFieldDelegate,JXKeyboardTextFieldDelegate {
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == newPsdRepeatTextField {
            self.confirmAction(0)
            return textField.resignFirstResponder()
        } else if textField == psdTextField {
            newPsdTextField.becomeFirstResponder()
            return false
        } else if textField == newPsdTextField {
            newPsdRepeatTextField.becomeFirstResponder()
            return false
        }
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
            self.updateButtonStatus()
        }
    }
    func updateButtonStatus() {
        //登录按钮
        if
            let name = self.psdTextField.text, name.isEmpty == false,
            let password = self.newPsdTextField.text, password.isEmpty == false,
            let card = self.newPsdRepeatTextField.text, card.isEmpty == false{

            self.confirmButton.isEnabled = true
            self.confirmButton.backgroundColor = JXMainColor

        } else {
            self.confirmButton.isEnabled = false
            self.confirmButton.backgroundColor = JXlightBlueColor
            
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
            //self.mainScrollView.contentOffset = CGPoint(x: 0, y: 160)
            
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
