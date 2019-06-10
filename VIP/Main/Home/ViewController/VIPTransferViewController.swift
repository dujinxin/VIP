//
//  VIPTransferViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPTransferViewController: VIPBaseViewController {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight + 20
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            if #available(iOS 11.0, *) {
                self.scrollView.contentInsetAdjustmentBehavior = .never
            } else {
                self.automaticallyAdjustsScrollViewInsets = false
            }
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
    
    @IBOutlet weak var toAddressTextField: UITextField!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    var entity : VIPPropertyModel?
    var vm = VIPPropertyVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "\(self.entity?.coinEntity?.short_name ?? "")转账"
        self.numLabel.text = "\(self.entity?.coinEntity?.short_name ?? "")余额：\(self.entity?.walletEntity?.available_qty ?? 0)"
        self.valueLabel.text = "≈ $0.00"
        self.fromAddressLabel.text = self.entity?.walletEntity?.address
        self.rateLabel.text = "矿工费：\(self.entity?.coinEntity?.withdraw_fee ?? 0)"
        
        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    @objc func textChange(notify: NSNotification) {
        
        if let textField = notify.object as? UITextField, textField == self.numTextFeild {
            if
                let text = textField.text, text.isEmpty == false,
                let num = Float(text), num > 0 {
                
                self.valueLabel.text = "≈ $\(num * (self.entity?.walletEntity!.available_qty)!)"
                
                //                self.confirmButton.isEnabled = true
                //                self.confirmButton.backgroundColor = JXMainColor
                
            } else {
                self.valueLabel.text = "≈ $\(0.00)"
                
                //                self.confirmButton.isEnabled = false
                //                self.confirmButton.backgroundColor = JXlightBlueColor
                
            }
        }
    }
    
    @IBAction func allAction(_ sender: UIButton) {
        self.numTextFeild.text = "\(self.entity?.walletEntity?.available_qty ?? 0)"
        if let text = self.numTextFeild.text, let num = Float(text) {
            self.valueLabel.text = "≈ $\(num * (self.entity?.coinEntity!.price)!)"
        } else {
            self.valueLabel.text = "≈ $\(0.00)"
        }
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
            textField.placeholder = "请输入交易密码"
        })
        alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            
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
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
}
