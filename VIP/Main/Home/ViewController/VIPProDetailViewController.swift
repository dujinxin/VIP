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
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var entity : VIPTradeRecordsEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "记录详情"
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-back"), style: .plain, target: self, action: #selector(back))
        
        if self.entity.operation_qty > 0 {
            self.numLabel.text = "+\(self.entity.operation_qty) \(self.entity.currency_name ?? "")"
        } else {
            self.numLabel.text = "\(self.entity.operation_qty) \(self.entity.currency_name ?? "")"
        }
        // 1充值 2提现 3 理财 4兑换
        if self.entity.operation_style == 1 {
            self.typeLabel.text = "充值"
        } else if self.entity.operation_style == 2 {
            self.typeLabel.text = "提现"
        } else if self.entity.operation_style == 3 {
            self.typeLabel.text = "理财"
        } else if self.entity.operation_style == 4 {
            self.typeLabel.text = "兑换"
        }
        self.orderLabel.text = "\(self.entity.operation_id)"
        //self.statusLabel.text =
        self.timeLabel.text = self.entity.create_time
    }

    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
