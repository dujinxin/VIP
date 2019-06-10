//
//  VIPExchangeListCell.swift
//  VIP
//
//  Created by 飞亦 on 6/7/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPExchangeListCell: UITableViewCell {
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var numTitleLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    
    @IBOutlet weak var coinNumTitleLabel: UILabel!
    @IBOutlet weak var coinNumLabel: UILabel!
    
    @IBOutlet weak var timeTitleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
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
    
    var entity : VIPExchangeCellEntity? {
        didSet{
            // 1充值 2提现 3 理财 4兑换
            self.typeLabel.text = "兑换"
            
            self.numTitleLabel.text = self.entity?.l_currency_name
            self.numLabel.text = "\(self.entity?.l_currency_qty ?? 0)"
            
            self.coinNumTitleLabel.text = self.entity?.r_currency_name
            self.coinNumLabel.text = "\(self.entity?.r_currency_qty ?? 0)"
            
           
            let formater = DateFormatter()
            formater.dateFormat = "YYYY-MM-dd HH:mm:ss"
            let date = formater.date(from: entity?.create_time ?? "0")
            //self.date.dateFromString(entity.create_time ?? "0")
            formater.dateFormat = "HH:mm MM/dd"
            //self.date.format("HH:mm MM/dd")
            //let dateStr = date?.stringFromDate()
            if let date = date {
                let dateStr = formater.string(from: date)
                self.timeLabel.text = dateStr
            } else {
                self.timeLabel.text = self.entity?.create_time
            }
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
