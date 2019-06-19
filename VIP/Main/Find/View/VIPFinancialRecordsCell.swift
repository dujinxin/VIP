//
//  VIPFinancialRecordsCell.swift
//  VIP
//
//  Created by 飞亦 on 6/3/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPFinancialRecordsCell: UITableViewCell {

    @IBOutlet weak var coinNameLabel: UILabel!
    @IBOutlet weak var joinTimeLabel: UILabel!
    @IBOutlet weak var coinValueLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var ReleaseButton: UIButton!
    
    var releaseBlock : (()->())?
    
    var entity: VIPFinancialRecordsListEntity? {
        didSet{
            self.coinNameLabel.text = entity?.currency_name
            self.coinValueLabel.text = "$\(entity?.contract_price ?? 0)"
            if entity?.plan_status == 1 {
                self.statusLabel.text = LocalizedString(key: "Find_effectiveInProgress")
                self.ReleaseButton.backgroundColor = JXCyanColor
                self.ReleaseButton.setTitleColor(JXBlueColor, for: .normal)
                self.ReleaseButton.isEnabled = true
            } else if entity?.plan_status == 2 {
                self.statusLabel.text = LocalizedString(key: "Find_completed")
                self.ReleaseButton.backgroundColor = JXViewBgColor
                self.ReleaseButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xadb4bb), for: .normal)
                self.ReleaseButton.isEnabled = false
            } else if entity?.plan_status == 3 {
                self.statusLabel.text = LocalizedString(key: "Find_released")
                self.ReleaseButton.backgroundColor = JXViewBgColor
                self.ReleaseButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xadb4bb), for: .normal)
                self.ReleaseButton.isEnabled = false
            }
            self.joinTimeLabel.text = entity?.create_time
            
            if entity?.create_time == entity?.expire_time {
                self.endTimeLabel.text = LocalizedString(key: "Find_nothing")
            } else {
                self.endTimeLabel.text = entity?.expire_time
            }
          
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func releaseAction(_ sender: Any) {
        if let block = self.releaseBlock {
            block()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
