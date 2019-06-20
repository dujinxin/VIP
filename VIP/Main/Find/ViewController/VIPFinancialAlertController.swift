//
//  VIPFinancialAlertController.swift
//  VIP
//
//  Created by 飞亦 on 5/31/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

class VIPFinancialAlertController: VIPBaseViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!{
        didSet{
            self.mainScrollView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var contentView: UIView!{
        didSet{
            //self.contentView.isHidden = true
        }
    }
    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var priseLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var psdTextField: UITextField!
    @IBOutlet weak var allButton: UIButton!{
        didSet{
            self.allButton.layer.borderWidth = 1
            self.allButton.layer.borderColor = JXGrayTextColor.cgColor
        }
    }
    
    @IBOutlet weak var confirmButton: UIButton!{
        didSet{
            self.confirmButton.backgroundColor = JXCyanColor
        }
    }
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.numTextField,self.psdTextField])
        k.showBlock = { (height, rect) in
            print(height,rect)
        }
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.textFieldDelegate = self
        return k
    }()
    
    var programEntity : VIPFinancialProgramListEntity!
    
    var walletListEntity : VIPWalletListEntity!
    var newWalletLists = Array<VIPCoinPropertyEntity>()
    
    var currentEntity : VIPCoinPropertyEntity!
    
    var vm = VIPFinancialVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.addSubview(self.keyboard)
        
        self.titleLabel.text = self.programEntity.title
        
        self.walletListEntity.list.forEach { (entity) in
            if entity.currency_type != 3 {
                self.newWalletLists.append(entity)
            }
        }
        for i in 0..<self.newWalletLists.count {
            let entity = self.newWalletLists[i]
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 34))
            button.setTitle(entity.short_name, for: .normal)
            button.tag = i
            
            button.layer.borderWidth = 1
            if i == 0 {
                button.backgroundColor = JXBlueColor
                button.setTitleColor(JXFfffffColor, for: .normal)
                button.layer.borderColor = JXGrayTextColor.cgColor
                button.isSelected = true
                
                self.setData(entity: entity)
            } else {
                button.layer.borderColor = JXGrayTextColor.cgColor
                button.isSelected = false
                button.backgroundColor = JXFfffffColor
                button.setTitleColor(JXGrayTextColor, for: .normal)
            }
            button.addTarget(self, action: #selector(coinAction(_:)), for: .touchUpInside)
            
            self.coinStackView.addArrangedSubview(button)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    
    
    @IBAction func dismissAlert(_ sender: Any) {
        if let block = self.backBlock {
            block()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var coinStackView: UIStackView!{
        didSet{
            
        }
    }
    @objc func coinAction(_ sender: UIButton) {
        
        self.coinStackView.arrangedSubviews.forEach { (v) in
            if let button = v as? UIButton {
                if button.tag == sender.tag {
                    button.backgroundColor = JXBlueColor
                    button.setTitleColor(JXFfffffColor, for: .normal)
                    button.layer.borderColor = JXGrayTextColor.cgColor
                    button.isSelected = true
                    
                } else {
                    button.layer.borderColor = JXGrayTextColor.cgColor
                    button.isSelected = false
                    button.backgroundColor = JXFfffffColor
                    button.setTitleColor(JXGrayTextColor, for: .normal)
                }
            }
        }
        
        let entity = self.newWalletLists[sender.tag]
        self.setData(entity: entity)
    }
  
    @IBAction func allAction(_ sender: Any) {
    
        self.numTextField.text = "\(self.currentEntity.available_qty)"
        if let text = self.numTextField.text, let num = Double(text) {
            self.valueLabel.text = String(format: "\(LocalizedString(key: "Find_value")) ≈ $%.2f", num * self.currentEntity.price)
        } else {
            self.valueLabel.text = "\(LocalizedString(key: "Find_value")) ≈ $\(0)"
        }
        if self.currentEntity.available_qty > 0 {
//            self.confirmButton.isEnabled = true
//            self.confirmButton.backgroundColor = JXMainColor
//            //self.confirmButton.setTitleColor(JXFfffffColor, for: .normal)
        }
    }
    
    @IBAction func confirmAction(_ sender: Any) {
       
        guard let text = self.numTextField.text, text.isEmpty == false
            else {
            ViewManager.showNotice(LocalizedString(key: "Notice_inputNumber"))
            return
        }
        guard let num = Double(text), num <= self.currentEntity.available_qty else {
            ViewManager.showNotice(LocalizedString(key: "Notice_insufficientBalance"))
            return
        }
        guard let psd = self.psdTextField.text, psd.isEmpty == false, psd.count == 6 else {
            ViewManager.showNotice(LocalizedString(key: "Notice_passwordError"))
            return
        }
        self.showMBProgressHUD()
        
        self.vm.financialJoin(contract_id: self.programEntity.id, currency_id: self.currentEntity.id, currency_qty: num, pay_password: psd) { (_, msd, isSuc) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msd)
            if isSuc {
                if let block = self.backBlock {
                    block()
                }
                self.dismiss(animated: true, completion: {})
            }
        }
    }
    
    func setData(entity: VIPCoinPropertyEntity) {
        self.currentEntity = entity
        
        
        self.priseLabel.text = "\(LocalizedString(key: "Find_presentPrice"))：$\(entity.price)"
        self.balanceLabel.text = "\(LocalizedString(key: "Find_availableBalance"))：\(entity.available_qty)"
        
        self.numTextField.text = ""
        self.numTextField.placeholder = "\(LocalizedString(key: "Find_enterAmount"))（\(entity.short_name ?? "")）"
        
        if let text = self.numTextField.text, let num = Double(text) {
            self.valueLabel.text = String(format: "\(LocalizedString(key: "Find_value")) ≈ $%.2f", num * self.currentEntity.price)
        } else {
            self.valueLabel.text = "\(LocalizedString(key: "Find_value")) ≈ $\(0)"
        }
        
    }
}
extension VIPFinancialAlertController: JXKeyboardTextFieldDelegate {
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == numTextField {
            psdTextField.becomeFirstResponder()
            return false
        } else if textField == psdTextField {
            self.confirmAction(0)
            textField.resignFirstResponder()
            return true
        }
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        
//        if textField == numTextField, let text = textField.text, let num = Double(text), num >= self.currentEntity.available_qty  {
//
//            return false
//        }
        if textField == psdTextField  {
            if range.location > 5 {
                return false
            }
        }
        return true
    }
    @objc func textChange(notify: NSNotification) {
        
        if let textField = notify.object as? UITextField, textField == self.numTextField {
            if
                let text = textField.text, text.isEmpty == false,
                let num = Double(text), num > 0 {
                
                self.valueLabel.text = String(format: "\(LocalizedString(key: "Find_value")) ≈ $%.2f", num * self.currentEntity.price)
            } else {
                self.valueLabel.text = "\(LocalizedString(key: "Find_value")) ≈ $\(0)"
            }
        }
    }
    @objc func keyboardWillShow(notify:Notification) {
        
        guard
            let userInfo = notify.userInfo,
            let _ = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
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
