//
//  VIPFinancialListCell.swift
//  VIP
//
//  Created by 飞亦 on 6/4/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPFinancialListCell: UITableViewCell {

    @IBOutlet weak var accountLabel: UILabel!{
        didSet{
            self.accountLabel.textColor = JXBlueColor
        }
    }
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var joinButton: UIButton!{
        didSet{
            self.joinButton.backgroundColor = JXGreenColor
            self.joinButton.isEnabled = false
            
            self.joinButton.layer.cornerRadius = 2
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
