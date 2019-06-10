//
//  VIPFinancialRecordsAlertController.swift
//  VIP
//
//  Created by 飞亦 on 6/3/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPFinancialRecordsAlertController: VIPBaseViewController {

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
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var interestIncomeLabel: UILabel!
    
    @IBOutlet weak var psdTextField: UITextField!
    
    @IBOutlet weak var noticeLabel: UILabel!
    
    var entity : VIPFinancialRecordsListEntity?
    var titleStr = ""
    var vm = VIPFinancialVM()
    var callBackBlock : ((_ isRefresh: Bool)->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        self.titleLabel.text = self.titleStr
        self.totalCastLabel.text = "\(self.entity?.contract_price ?? 0)"
        self.totalIncomeLabel.text = "\(self.entity?.bonus_price ?? 0)"
        self.interestIncomeLabel.text = "\(self.entity?.deduct_price ?? 0)"
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
            ViewManager.showNotice("请输入密码")
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
