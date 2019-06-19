//
//  VIPHomeCell.swift
//  VIP
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPHomeCell: UITableViewCell {

    @IBOutlet weak var coinBgView: UIView!{
        didSet{
            self.coinBgView.backgroundColor = JXFfffffColor
            
//            coinBgView.layer.shadowOpacity = 1
//            coinBgView.layer.shadowRadius = 2
//            coinBgView.layer.shadowColor = UIColor.rgbColor(rgbValue: 0x000000, alpha: 0.1).cgColor
//            coinBgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }
    @IBOutlet weak var coinImageView: UIImageView!{
        didSet{
            self.coinImageView.backgroundColor = UIColor.clear
            self.coinImageView.layer.cornerRadius = 26.0
            coinImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var coinTitleLabel: UILabel!{
        didSet{
            self.coinTitleLabel.textColor = JXBlackTextColor
        }
    }
    @IBOutlet weak var coinValueLabel: UILabel!{
        didSet{
            self.coinValueLabel.textColor = JXGrayTextColor
        }
    }
    @IBOutlet weak var coinNumLabel: UILabel!{
        didSet{
            self.coinNumLabel.textColor = JXBlackTextColor
        }
    }
    @IBOutlet weak var numValueLabel: UILabel!{
        didSet{
            self.numValueLabel.textColor = JXGrayTextColor
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
