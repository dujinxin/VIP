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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        if 1 {
//            self.ReleaseButton.backgroundColor = JXCyanColor
//            self.ReleaseButton.setTitleColor(JXBlueColor, for: .normal)
//            self.ReleaseButton.isEnabled = true
//        } else {
//            self.ReleaseButton.backgroundColor = JXViewBgColor
//            self.ReleaseButton.setTitleColor(UIColor.rgbColor(rgbValue: 0xADB4BB), for: .normal)
//            self.ReleaseButton.isEnabled = false
//        }
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
