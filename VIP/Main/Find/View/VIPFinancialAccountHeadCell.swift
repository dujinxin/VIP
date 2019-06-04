//
//  VIPFinancialAccountHeadCell.swift
//  VIP
//
//  Created by 飞亦 on 5/30/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPFinancialAccountHeadCell: UITableViewCell {
    
    @IBOutlet weak var accountLabel: UILabel!{
        didSet{
            self.accountLabel.textColor = JXBlueColor
        }
    }
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var joinNumLabel: UILabel!
    @IBOutlet weak var joinBgView: UIView!
    @IBOutlet weak var line: UIView!{
        didSet{
            self.line.layer.cornerRadius = 2
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
