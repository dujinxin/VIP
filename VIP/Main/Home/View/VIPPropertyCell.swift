//
//  VIPPropertyCell.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPPropertyCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!{
        didSet{
            self.typeLabel.textColor = JXBlackTextColor
        }
    }
    @IBOutlet weak var numTitleLabel: UILabel!{
        didSet{
            self.numTitleLabel.textColor = JX092641Color
        }
    }
    @IBOutlet weak var numLabel: UILabel!{
        didSet{
            self.numLabel.textColor = JXBlueColor
        }
    }
    @IBOutlet weak var statusTitleLabel: UILabel!{
        didSet{
            self.statusTitleLabel.textColor = JX092641Color
        }
    }
    @IBOutlet weak var statusLabel: UILabel!{
        didSet{
            self.statusLabel.textColor = JX809FBCColor
        }
    }
    @IBOutlet weak var timeTitleLabel: UILabel!{
        didSet{
            self.timeTitleLabel.textColor = JX092641Color
        }
    }
    @IBOutlet weak var timeLabel: UILabel!{
        didSet{
            self.timeLabel.textColor = JX7999B8Color
        }
    }
    @IBOutlet weak var separateLine: UIView!{
        didSet{
            self.separateLine.backgroundColor = UIColor.rgbColor(rgbValue: 0xEAF0F5)
        }
    }
    @IBOutlet weak var actionButton: UIButton!{
        didSet{
            
        }
    }

    @IBAction func action(_ sender: Any) {
        
    }
    var tradeRecords : VIPTradeRecordsEntity? {
        didSet {
            //self.
            if self.tradeRecords?.operation_qty ?? 0 > 0 {
                self.numLabel.text = "+\(self.tradeRecords?.operation_qty ?? 0) \(self.tradeRecords?.currency_name ?? "")"
            } else {
                self.numLabel.text = "\(self.tradeRecords?.operation_qty ?? 0) \(self.tradeRecords?.currency_name ?? "")"
            }
            // 1充值 2提现 3 理财 4兑换
            if self.tradeRecords?.operation_style == 1 {
                self.typeLabel.text = LocalizedString(key: "Recharge")
            } else if self.tradeRecords?.operation_style == 2 {
                self.typeLabel.text = LocalizedString(key: "Withdraw")
            } else if self.tradeRecords?.operation_style == 3 {
                self.typeLabel.text = LocalizedString(key: "Finance")
            } else if self.tradeRecords?.operation_style == 4 {
                self.typeLabel.text = LocalizedString(key: "Exchange")
            }
            //1 待审核 2 已审核(转账中，确认中) 3 已完成 4 审核失败(转账失败 操作失败)
            if self.tradeRecords?.verify_status == 1 {
                self.statusLabel.text = LocalizedString(key: "Home_review")
            } else if self.tradeRecords?.verify_status == 3 {
                self.statusLabel.text = LocalizedString(key: "Home_completed")
            } else if self.tradeRecords?.verify_status  == 2 {
                if self.tradeRecords?.operation_style == 1 {
                    self.statusLabel.text = LocalizedString(key: "Home_transferInProgress")
                } else if self.tradeRecords?.operation_style == 2 {
                    self.statusLabel.text = LocalizedString(key: "Home_transferInProgress")
                } else if self.tradeRecords?.operation_style == 3 {
                    self.statusLabel.text = LocalizedString(key: "Home_completed")
                } else if self.tradeRecords?.operation_style == 4 {
                    self.statusLabel.text = LocalizedString(key: "Home_confirmationInProgress")
                }
            } else {
                if self.tradeRecords?.operation_style == 1 {
                    self.statusLabel.text = LocalizedString(key: "Home_failure")
                } else if self.tradeRecords?.operation_style == 2 {
                    self.statusLabel.text = LocalizedString(key: "Home_failure")
                } else if self.tradeRecords?.operation_style == 3 {
                    self.statusLabel.text = LocalizedString(key: "Home_failure")
                } else if self.tradeRecords?.operation_style == 4 {
                    self.statusLabel.text = LocalizedString(key: "Home_failure")
                }
            }
            
        }
    }
    var exchangeRecords : VIPExchangeCellEntity? {
        didSet {
            //self.
            
            self.timeLabel.text = exchangeRecords?.create_time
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
