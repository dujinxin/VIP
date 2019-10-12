//
//  VIPAddressAddController.swift
//  VIP
//
//  Created by 飞亦 on 7/26/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

enum AddressType: Int {
    case add       = 0
    case edit
}

class VIPAddressAddController: VIPBaseViewController {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight
        }
    }
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!{
        didSet{
            self.bottomConstraint.constant = kBottomMaginHeight + 20
        }
    }
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            self.scrollView.isScrollEnabled = false
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameTextFeild: UITextField!
 
    
    @IBOutlet weak var addressView: UIView!{
        didSet{
            self.addressView.isHidden = true
        }
    }
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextView: JXPlaceHolderTextView!{
        didSet{
            
        }
    }
    @IBOutlet weak var dropButton: UIButton!{
        didSet{
            
        }
    }
    
    
    @IBOutlet weak var scanButton: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!{
        didSet{
            self.deleteButton.isHidden = true
        }
    }
    lazy var selectView: JXSelectView = {
        let s = JXSelectView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 216), style: .pick)
        s.backgroundColor = JXFfffffColor
        s.delegate = self
        s.dataSource = self
        s.isUseSystemItemBar = true
        return s
    }()
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.nameTextFeild,self.addressTextView])
        k.showBlock = { (height, rect) in
            print(height,rect)
        }
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.textFieldDelegate = self
        k.textViewDelegate = self
        k.closeItem?.title = LocalizedString(key: "Done")
        return k
    }()
    
    var entity : VIPPropertyModel?
    var vm = VIPPropertyVM()
    var financialVM = VIPFinancialVM()
    
    var type : AddressType = .add
    var fromType : FromType = .my
    
    var current_coin_id = 0
    var address_id = 0
    
    var addressName : String?
    var address : String?
    var addressId : Int = 0
    var coinName : String?
    var coinId : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.scrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.addSubview(self.keyboard)
        
//        self.title = "\(self.entity?.coinEntity?.short_name ?? "") \(LocalizedString(key: "Transfer"))"
//        self.numLabel.text = "\(self.entity?.coinEntity?.short_name ?? "") \(LocalizedString(key: "Balance"))：\(self.entity?.walletEntity?.available_qty ?? 0)"
//        self.valueLabel.text = "≈ $0.00"
//        if LanaguageManager.shared.type == .chinese {
//            self.toAddressTextField.placeholder = LocalizedString(key: "请输入（ \(self.entity?.coinEntity?.short_name ?? "")）地址")
//        } else {
//            self.toAddressTextField.placeholder = LocalizedString(key: "Input address(\(self.entity?.coinEntity?.short_name ?? ""))")
//        }
//        self.fromAddressLabel.text = self.entity?.walletEntity?.address
//        self.rateLabel.text = "\(LocalizedString(key: "Home_absenceFee"))：\(self.entity?.coinEntity?.withdraw_fee ?? 0)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        
        self.confirmButton.setTitle(LocalizedString(key: "OK"), for: .normal)
        self.deleteButton.setTitle(LocalizedString(key: "Home_deleteTheAddress"), for: .normal)
        self.nameLabel.text = LocalizedString(key: "Home_name")
        self.nameTextFeild.placeholder = LocalizedString(key: "Home_text_placeHolder_addressName")
        self.addressTextView.placeHolderText = LocalizedString(key: "Home_text_placeHolder_address")
       
        if self.fromType == .my {
            if self.type == .add {
                self.title = LocalizedString(key: "Home_addAddressBook")
                self.addressView.isHidden = true
                self.deleteButton.isHidden = true
                
                self.addressLabel.text = LocalizedString(key: "Home_addAddress")
            } else {
                self.title = LocalizedString(key: "Home_editAddressBook")
                self.addressView.isHidden = false
                self.deleteButton.isHidden = false
                
                self.nameTextFeild.text = self.addressName
                self.addressTextView.text = self.address
                self.address_id = self.addressId
                self.addressLabel.text = "\(self.coinName ?? "") \(LocalizedString(key: "Home_address"))"
                self.current_coin_id = self.coinId
                
            }
            self.showMBProgressHUD()
            self.financialVM.walletList { (_, msg, isSuc) in
                self.hideMBProgressHUD()
            }
        } else {
            
            self.title = LocalizedString(key: "Home_addAddressBook")
            self.deleteButton.isHidden = true
            self.addressView.isHidden = false
            self.dropButton.isHidden = true
            
            self.nameTextFeild.text = self.addressName
            self.addressTextView.text = self.address
            self.address_id = self.addressId
            self.addressLabel.text = "\(self.coinName ?? "") \(LocalizedString(key: "Home_address"))"
            self.current_coin_id = self.coinId
        }
        
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @IBAction func dropAction(_ sender: UIButton) {
        self.view.endEditing(true)
        self.selectView.selectRow = 0
        self.selectView.show()
    }
    @IBAction func scanAction(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "scan") as! VIPScanViewController
        vc.callBlock = { address in
            self.addressTextView.text = address
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func confirmAction(_ sender: UIButton) {
        guard let text = self.nameTextFeild.text, text.isEmpty == false else { return }
        guard let address = self.addressTextView.text, address.isEmpty == false else { return }
        
        if self.type == .add {
            
            let alertVC = UIAlertController(title: nil, message: "", preferredStyle: .alert)
            //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
            alertVC.addTextField(configurationHandler: { (textField) in
                textField.placeholder = LocalizedString(key: "Home_Please enter the trade password")
                textField.isSecureTextEntry = true
            })
            alertVC.addAction(UIAlertAction(title: LocalizedString(key: "OK"), style: .destructive, handler: { (action) in
                
                guard
                    let textField = alertVC.textFields?[0],
                    let psd = textField.text,
                    psd.isEmpty == false else {
                        return
                }
                
                self.showMBProgressHUD()
                self.vm.addressAdd(address_remark: text, address: address, currency_id: self.current_coin_id, pay_password: psd, completion: { (_, msd, isSuc) in
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
        } else {
            
            let alertVC = UIAlertController(title: nil, message: "", preferredStyle: .alert)
            //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
            alertVC.addTextField(configurationHandler: { (textField) in
                textField.placeholder = LocalizedString(key: "Home_Please enter the trade password")
                textField.isSecureTextEntry = true
            })
            alertVC.addAction(UIAlertAction(title: LocalizedString(key: "OK"), style: .destructive, handler: { (action) in
                
                guard
                    let textField = alertVC.textFields?[0],
                    let psd = textField.text,
                    psd.isEmpty == false else {
                        return
                }
                
                self.showMBProgressHUD()
                
                self.vm.addressEdit(address_remark: text, address: address, currency_id: self.current_coin_id, address_id: self.address_id, pay_password: psd) { (_, msd, isSuc) in
                    self.hideMBProgressHUD()
                    ViewManager.showNotice(msd)
                    if isSuc {
                        if let block = self.backBlock {
                            block()
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }))
            alertVC.addAction(UIAlertAction(title: LocalizedString(key: "Cancel"), style: .cancel, handler: { (action) in
            }))
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
    }
    @IBAction func deleteAction(_ sender: UIButton) {
       
        let alertVC = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
        alertVC.addTextField(configurationHandler: { (textField) in
            textField.placeholder = LocalizedString(key: "Home_Please enter the trade password")
            textField.isSecureTextEntry = true
        })
        alertVC.addAction(UIAlertAction(title: LocalizedString(key: "OK"), style: .destructive, handler: { (action) in
            
            guard
                let textField = alertVC.textFields?[0],
                let psd = textField.text,
                psd.isEmpty == false else {
                    return
            }
            
            self.showMBProgressHUD()
            self.vm.addressDelete(address_id: self.address_id, pay_password: psd, completion: { (_, msd, isSuc) in
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
extension VIPAddressAddController: JXKeyboardTextFieldDelegate,JXKeyboardTextViewDelegate {
    func keyboardTextView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextFeild {
            self.addressTextView.becomeFirstResponder()
            return false
        }
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" {
            return true
        }
        return true
    }
    @objc func textChange(notify: NSNotification) {
        
//        if let textField = notify.object as? UITextField, textField == self.numTextFeild {
//            if
//                let text = textField.text, text.isEmpty == false,
//                let num = Double(text), num > 0 {
//
//                self.valueLabel.text = "≈ $\(num * (self.entity?.coinEntity?.price)!)"
//            } else {
//                self.valueLabel.text = "≈ $\(0.00)"
//            }
//        }
    }
}
extension VIPAddressAddController: JXSelectViewDelegate,JXSelectViewDataSource{
    func jxSelectView(selectView: JXSelectView, didSelectRowAt row: Int, inSection section: Int) {
        print(row)
        self.addressView.isHidden = false
        
        let entity = self.financialVM.walletListEntity.list[row]
        guard let name = entity.short_name else {
            self.current_coin_id = 0
            self.addressLabel.text = LocalizedString(key: "Home_addAddress")
            return
        }
        self.current_coin_id = entity.id
        self.addressLabel.text = "\(name) \(LocalizedString(key: "Home_address"))"
        
    }
    
    func jxSelectView(selectView: JXSelectView, numberOfRowsInSection section: Int) -> Int {
        return self.financialVM.walletListEntity.list.count
    }
    
    func jxSelectView(selectView: JXSelectView, heightForRowAt row: Int) -> CGFloat {
        return 36
    }
    
    func jxSelectView(selectView: JXSelectView, contentForRow row: Int, InSection section: Int) -> String {
        let entity = self.financialVM.walletListEntity.list[row]
        guard let name = entity.short_name else { return "" }
        return "\(name) \(LocalizedString(key: "Home_address"))"
    }
    
    
}
