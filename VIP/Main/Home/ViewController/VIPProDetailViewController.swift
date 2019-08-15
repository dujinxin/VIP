//
//  VIPProDetailViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPProDetailViewController: VIPBaseViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight + 15
        }
    }
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var entity : VIPTradeRecordsEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = LocalizedString(key: "Home_recordDetails")
        //self.customNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-back"), style: .plain, target: self, action: #selector(back))
        
        if self.entity.operation_qty > 0 {
            self.numLabel.text = "+\(self.entity.operation_qty) \(self.entity.currency_name ?? "")"
        } else {
            self.numLabel.text = "\(self.entity.operation_qty) \(self.entity.currency_name ?? "")"
        }
        // 1充值 2提现 3 理财 4兑换
        if self.entity.operation_style == 1 {
            self.typeLabel.text = LocalizedString(key: "Recharge")
        } else if self.entity.operation_style == 2 {
            self.typeLabel.text = LocalizedString(key: "Withdraw")
        } else if self.entity.operation_style == 3 {
            self.typeLabel.text = LocalizedString(key: "Finance")
        } else if self.entity.operation_style == 4 {
            self.typeLabel.text = LocalizedString(key: "Exchange")
        }
        //1 待审核 2 已审核(转账中，确认中) 3 已完成 4 审核失败(转账失败 操作失败)
        if self.entity.verify_status == 1 {
            self.statusLabel.text = LocalizedString(key: "Home_review")
        } else if self.entity.verify_status == 3 {
            self.statusLabel.text = LocalizedString(key: "Home_completed")
        } else if self.entity.verify_status  == 2 {
            if self.entity.operation_style == 1 {
                self.statusLabel.text = LocalizedString(key: "Home_transferInProgress")
            } else if self.entity.operation_style == 2 {
                self.statusLabel.text = LocalizedString(key: "Home_transferInProgress")
            } else if self.entity.operation_style == 3 {
                self.statusLabel.text = LocalizedString(key: "Home_completed")
            } else if self.entity.operation_style == 4 {
                self.statusLabel.text = LocalizedString(key: "Home_confirmationInProgress")
            }
        } else {
            if self.entity.operation_style == 1 {
                self.statusLabel.text = LocalizedString(key: "Home_operatefFailure")
            } else if self.entity.operation_style == 2 {
                self.statusLabel.text = LocalizedString(key: "Home_auditFailure")
            } else if self.entity.operation_style == 3 {
                self.statusLabel.text = LocalizedString(key: "Home_operatefFailure")
            } else if self.entity.operation_style == 4 {
                self.statusLabel.text = LocalizedString(key: "Home_operatefFailure")
            }
        }
        //self.statusLabel.text =
        self.timeLabel.text = self.entity.create_time
    }

    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
