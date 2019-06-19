//
//  VIPFinancialAccountListCell.swift
//  VIP
//
//  Created by 飞亦 on 5/30/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPFinancialAccountListCell: UITableViewCell {
    
    @IBOutlet weak var planLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!{
        didSet{
            self.rateLabel.textColor = JXRedColor
        }
    }
    @IBOutlet weak var buyButton: UIButton!{
        didSet{
            self.buyButton.backgroundColor = JXGreenColor
            self.buyButton.layer.cornerRadius = 2
        }
    }

    @IBAction func buyAction(_ sender: Any) {
        if let block = buyBlock {
            block()
        }
    }
    var buyBlock : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
