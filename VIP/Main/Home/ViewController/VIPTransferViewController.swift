//
//  VIPTransferViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

class VIPTransferViewController: VIPBaseViewController {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            self.scrollView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var numTextFeild: UITextField!
    @IBOutlet weak var allButton: UIButton!{
        didSet{
            self.allButton.layer.borderColor = JXGrayTextColor.cgColor
            self.allButton.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var valueLabel: UILabel!
    
    @IBOutlet weak var toAddressTextField: UITextField!{
        didSet{
            self.toAddressTextField.isEnabled = false
        }
    }
    @IBOutlet weak var addressButton: UIButton!{
        didSet{
            addressButton.setTitle(LocalizedString(key: "Home_addressBook"), for: .normal)
            addressButton.setImage(UIImage(named: "addressBook"), for: .normal)
            addressButton.setTitleColor(JXBlueColor, for: .normal)
            addressButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            addressButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
            //addressButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.numTextFeild,self.toAddressTextField])
        k.showBlock = { (height, rect) in
            print(height,rect)
        }
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.textFieldDelegate = self
        return k
    }()
    
    var entity : VIPPropertyModel?
    var vm = VIPPropertyVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.addSubview(self.keyboard)
        
        self.title = "\(self.entity?.coinEntity?.short_name ?? "") \(LocalizedString(key: "Transfer"))"
        self.numLabel.text = "\(self.entity?.coinEntity?.short_name ?? "") \(LocalizedString(key: "Balance"))：\(self.entity?.walletEntity?.available_qty ?? 0)"
        self.valueLabel.text = "≈ $0.00"
        if LanaguageManager.shared.type == .chinese {
            self.toAddressTextField.placeholder = LocalizedString(key: "请选择（ \(self.entity?.coinEntity?.short_name ?? "")）地址")
        } else {
            self.toAddressTextField.placeholder = LocalizedString(key: "Select address(\(self.entity?.coinEntity?.short_name ?? ""))")
        }
        self.fromAddressLabel.text = self.entity?.walletEntity?.address
        self.rateLabel.text = "\(LocalizedString(key: "Home_absenceFee"))：\(self.entity?.coinEntity?.withdraw_fee ?? 0)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func allAction(_ sender: UIButton) {
        self.numTextFeild.text = "\(self.entity?.walletEntity?.available_qty ?? 0)"
        if let text = self.numTextFeild.text, let num = Double(text) {
            self.valueLabel.text = "≈ $\(num * (self.entity?.coinEntity!.price)!)"
        } else {
            self.valueLabel.text = "≈ $\(0.00)"
        }
    }
    @IBAction func addressAction(_ sender: UIButton) {
        let vc = VIPAddressListController()
        vc.type = .transfer
        vc.coin_id = self.entity?.walletEntity?.currency_id ?? 0
        vc.coin_name = self.entity?.walletEntity?.currency_name
        vc.selectBlock = { address in
            self.toAddressTextField.text = address
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func scanAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "scan") as! VIPScanViewController
        vc.callBlock = { address in
            self.toAddressTextField.text = address
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func confirmAction(_ sender: UIButton) {
        guard let text = self.numTextFeild.text, text.isEmpty == false, let num = Float(text) else { return }
        guard let address = self.toAddressTextField.text, address.isEmpty == false else { return }
        
        let alertVC = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
        alertVC.addTextField(configurationHandler: { (textField) in
            textField.placeholder = LocalizedString(key: "Home_Please enter the trade password")
        })
        alertVC.addAction(UIAlertAction(title: LocalizedString(key: "OK"), style: .destructive, handler: { (action) in
            
            guard
                let textField = alertVC.textFields?[0],
                let psd = textField.text,
                psd.isEmpty == false else {
                return
            }
            
            
            self.showMBProgressHUD()
            self.vm.propertyTransfer(currency_id: self.entity?.coinEntity?.id ?? 0, operation_qty: num, operation_address: address, pay_password: psd, completion: { (_, msd, isSuc) in
                self.hideMBProgressHUD()
                ViewManager.showNotice(msd)
                if isSuc {
                    if let block = self.backBlock {
                        block()
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }))
        alertVC.addAction(UIAlertAction(title: LocalizedString(key: "Cancel"), style: .cancel, handler: { (action) in
        }))
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
}
extension VIPTransferViewController: JXKeyboardTextFieldDelegate {
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == numTextFeild {
            self.toAddressTextField.becomeFirstResponder()
            return false
        } else if textField == toAddressTextField {
            textField.resignFirstResponder()
            return true
        }
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        
        if textField == numTextFeild, let text = textField.text, let num = Double(text), num >= self.entity!.walletEntity!.available_qty  {
            
            return false
        }

        return true
    }
    @objc func textChange(notify: NSNotification) {
        
        if let textField = notify.object as? UITextField, textField == self.numTextFeild {
            if
                let text = textField.text, text.isEmpty == false,
                let num = Double(text), num > 0 {
                
                self.valueLabel.text = "≈ $\(num * (self.entity?.coinEntity?.price)!)"
            } else {
                self.valueLabel.text = "≈ $\(0.00)"
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
            //self.mainScrollView.contentOffset = CGPoint(x: 0, y: 0)
        }) { (finish) in
            
        }
    }
}
