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
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var textView: JXPlaceHolderTextView!{
        didSet{
             self.textView.placeHolderText = LocalizedString(key: "Forget_mnemonicsTextField_placeholder")
        }
    }
    @IBOutlet weak var psdTextField: UITextField!{
        didSet{
            psdTextField.placeholder = LocalizedString(key: "Forget_loginPsdTextField_placeholder")
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
    
            psdRepeatTextField.placeholder = LocalizedString(key: "Forget_loginPsdTextField_repeat_placeholder")
            psdRepeatTextField.rightViewMode = .always
            psdRepeatTextField.rightView = {() -> UIView in
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
    
    @IBOutlet weak var importButton: UIButton!{
        didSet{
            self.importButton.setTitle(LocalizedString(key: "Import"), for: .normal)
        }
    }
    lazy var topBar : JXBarView = {
        let topBar = JXBarView.init(frame: CGRect.init(x: 0, y: 0, width: view.bounds.width , height: 50), titles: [LocalizedString(key: "Mnemonic"),LocalizedString(key: "PrivateKey")])
        topBar.delegate = self
        
        let att = JXAttribute()
        
        att.selectedColor = JXBlueColor
        att.normalColor = JXBlackTextColor
        att.font = UIFont.systemFont(ofSize: 17)
        topBar.attribute = att
        
        topBar.backgroundColor = JXViewBgColor
        topBar.bottomLineSize = CGSize(width: topBar.jxWidth / 2, height: 3)
        topBar.bottomLineView.backgroundColor = JXMainColor
        topBar.isBottomLineEnabled = true
        
        return topBar
    }()
    
    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.textView,self.psdTextField,self.psdRepeatTextField])
        k.showBlock = { (height, rect) in
            print(height,rect)
        }
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.textViewDelegate = self
        k.textFieldDelegate = self
        return k
    }()
    
    
    var selectIndex : Int = 0
    
    var vm = VIPLoginRegisterVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.title = "忘记密码"
        self.barView.addSubview(self.topBar)
        self.view.addSubview(self.keyboard)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextView.textDidChangeNotification, object: nil)
        
        self.updateButtonStatus()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if let controllers = self.navigationController?.viewControllers {
//            print(controllers)
//            if controllers.count > 1 {
//                self.navigationController?.viewControllers.remove(at: 0)
//            }
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func switchPsd(button: UIButton) {
        button.isSelected = !button.isSelected
        if button.tag == 1 {
            self.psdTextField.isSecureTextEntry = !button.isSelected
        } else if button.tag == 2 {
            self.psdRepeatTextField.isSecureTextEntry = !button.isSelected
        }
    }
    
    
    @IBAction func logAction(_ sender: Any) {
        guard let text = self.textView.text else {
            return
        }
        guard let password = self.psdTextField.text, password.count >= 6 else {
            ViewManager.showNotice("登录密码需要设置6位以上！")
            return
        }
        guard let password_r = self.psdRepeatTextField.text, password == password_r else {
            ViewManager.showNotice("两次输入密码不一致！")
            return
        }
        
        //        if self.validate(password) == false {
        //            ViewManager.showNotice("密码格式错误")
        //            return
        //        }
        self.showMBProgressHUD()
        
        self.vm.resetPsd(text: text, type: self.selectIndex + 1, password: password) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuc {
                if let controllers = self.navigationController?.viewControllers {
                    if controllers.count > 1 {
                        self.navigationController?.viewControllers.remove(at: 0)
                    }
                }
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let login = storyboard.instantiateViewController(withIdentifier: "login") as! VIPLoginViewController
                self.navigationController?.pushViewController(login, animated: true)
                
//                self.navigationController?.popToRootViewController(animated: true)
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationLoginStatus"), object: false)
            }
        }
    
    }
    
    func validate(_ string: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$")
        return predicate.evaluate(with: string)
    }
}

extension VIPForgetPsdViewController: JXBarViewDelegate,JXKeyboardTextFieldDelegate,JXKeyboardTextViewDelegate {
    
    
    func jxBarView(barView: JXBarView, didClick index: Int) {
        guard self.selectIndex != index else {
            return
        }
        self.selectIndex = index
        self.textView.text = ""
        if index == 0 {
            self.textView.placeHolderText = LocalizedString(key: "Forget_mnemonicsTextField_placeholder")
        } else {
            self.textView.placeHolderText = LocalizedString(key: "Forget_privateKeyTextField_placeholder")
        }
    }
    func keyboardTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == psdTextField {
            psdRepeatTextField.becomeFirstResponder()
            return false
        } else if textField == psdRepeatTextField {
            self.logAction(0)
            return textField.resignFirstResponder()
        }
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == psdTextField || textField == psdRepeatTextField {
            if range.location > 9 {
                return false
            }
        }
        return true
    }
    
    @objc func textChange(notify: NSNotification) {
        
        if notify.object is UITextField {
            
        }
        self.updateButtonStatus()
    }
    func updateButtonStatus() {
        //登录按钮
        if
            let text = self.textView.text, text.isEmpty == false,
            let password = self.psdTextField.text, password.isEmpty == false,
            let password_r = self.psdRepeatTextField.text, password_r.isEmpty == false{
            
            self.importButton.isEnabled = true
            self.importButton.backgroundColor = JXMainColor
            
        } else {
            self.importButton.isEnabled = false
            self.importButton.backgroundColor = JXlightBlueColor
            
        }
    }
}
