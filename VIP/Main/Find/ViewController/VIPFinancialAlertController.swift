//
//  VIPFinancialAlertController.swift
//  VIP
//
//  Created by 飞亦 on 5/31/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPFinancialAlertController: VIPBaseViewController {
    
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
    var programEntity : VIPFinancialProgramListEntity!
    
    var walletListEntity : VIPWalletListEntity!
    var newWalletLists = Array<VIPCoinPropertyEntity>()
    
    var currentEntity : VIPCoinPropertyEntity!
    
    var vm = VIPFinancialVM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
        
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
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    @objc func textChange(notify: NSNotification) {
        
        if let textField = notify.object as? UITextField, textField == self.numTextField {
            if
                let text = textField.text, text.isEmpty == false,
                let num = Double(text), num > 0 {
                
                self.valueLabel.text = "价值 ≈ $\(num * self.currentEntity.available_qty)"
                
//                self.confirmButton.isEnabled = true
//                self.confirmButton.backgroundColor = JXMainColor
                
            } else {
                self.valueLabel.text = "价值 ≈ $\(0)"
                
//                self.confirmButton.isEnabled = false
//                self.confirmButton.backgroundColor = JXlightBlueColor
                
            }
        }
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
            self.valueLabel.text = "价值 ≈ $\(num * self.currentEntity.available_qty)"
        } else {
            self.valueLabel.text = "价值 ≈ $\(0)"
        }
        if self.currentEntity.available_qty > 0 {
//            self.confirmButton.isEnabled = true
//            self.confirmButton.backgroundColor = JXMainColor
//            //self.confirmButton.setTitleColor(JXFfffffColor, for: .normal)
        }
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        
        guard let text = self.numTextField.text, text.isEmpty == false, let num = Float(text) else { return }
        guard let psd = self.psdTextField.text, psd.isEmpty == false else { return }
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
        
//        self.confirmButton.isEnabled = false
//        self.confirmButton.backgroundColor = JXlightBlueColor
        
        self.priseLabel.text = "现价：$\(entity.price)"
        self.balanceLabel.text = "可用余额：\(entity.available_qty)"
        
        self.numTextField.text = ""
        self.numTextField.placeholder = "请输入数量（\(entity.short_name ?? "")）"
        
        if let text = self.numTextField.text, let num = Double(text) {
            self.valueLabel.text = "价值 ≈ $\(num * entity.available_qty)"
        } else {
            self.valueLabel.text = "价值 ≈ $\(0)"
        }
        
    }
}
