//
//  VIPFinancialRecordsAlertController.swift
//  VIP
//
//  Created by 飞亦 on 6/3/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

class VIPFinancialRecordsAlertController: VIPBaseViewController {

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
    
    @IBOutlet weak var cancelButton: UIButton!{
        didSet{
            self.cancelButton.backgroundColor = JXCyanColor
        }
    }
    @IBOutlet weak var confirmButton: UIButton!{
        didSet{
            self.confirmButton.backgroundColor = JXCyanColor
        }
    }
    @IBOutlet weak var totalCastLabel: UILabel!
    @IBOutlet weak var interestIncomeLabel: UILabel!
    
    @IBOutlet weak var psdTextField: UITextField!
  
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.psdTextField])
        k.showBlock = { (height, rect) in
            print(height,rect)
        }
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.textFieldDelegate = self
        k.closeItem?.title = LocalizedString(key: "Done")
        return k
    }()
    
    var entity : VIPFinancialRecordsListEntity?{
        didSet{
            self.totalCastLabel.text = String(describing: entity?.contract_price ?? 0.0)
            self.interestIncomeLabel.text = String(describing: entity?.deduct_price ?? 0.0)
        }
    }
    var titleStr : String = "" {
        didSet{
            self.titleLabel.text = titleStr
        }
    }
    var vm = VIPFinancialVM()
    var callBackBlock : ((_ isRefresh: Bool)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.addSubview(self.keyboard)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notify:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notify:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    @IBAction func cancelAction(_ sender: Any) {
        if let block = self.callBackBlock {
            block(false)
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmAction(_ sender: UIButton) {
        guard let psd = self.psdTextField.text,psd.isEmpty == false else {
            ViewManager.showNotice(LocalizedString(key: "Notice_inputPassword"))
            return
        }
        guard psd.count == 6 else {
            ViewManager.showNotice(LocalizedString(key: "Notice_passwordError"))
            return
        }
        guard let id = self.entity?.id else { return }
        
        self.showMBProgressHUD()
        self.vm.financialRelease(plan_id: id, pay_password: psd) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuc {
                if let block = self.callBackBlock {
                    block(true)
                }
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
}
extension VIPFinancialRecordsAlertController: JXKeyboardTextFieldDelegate {
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == psdTextField {
            textField.resignFirstResponder()
            return true
        }
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        if textField == psdTextField  {
            if range.location > 5 {
                return false
            }
        }
        return true
    }
    @objc func textChange(notify: NSNotification) {
        
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
