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
                self.typeLabel.text = "充值"
            } else if self.tradeRecords?.operation_style == 2 {
                self.typeLabel.text = "提现"
            } else if self.tradeRecords?.operation_style == 3 {
                self.typeLabel.text = "理财"
            } else if self.tradeRecords?.operation_style == 4 {
                self.typeLabel.text = "兑换"
            }
           
            //self.statusLabel.text =
            let formater = DateFormatter()
            formater.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let date = formater.date(from: tradeRecords?.create_time ?? "0")
            //self.date.dateFromString(entity.create_time ?? "0")
            formater.dateFormat = "HH:mm MM/dd"
            //self.date.format("HH:mm MM/dd")
            //let dateStr = date?.stringFromDate()
            if let date = date {
                let dateStr = formater.string(from: date)
                self.timeLabel.text = dateStr
            } else {
                self.timeLabel.text = self.tradeRecords?.create_time
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
