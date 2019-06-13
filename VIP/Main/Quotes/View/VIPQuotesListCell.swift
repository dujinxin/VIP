//
//  VIPQuotesListCell.swift
//  VIP
//
//  Created by 飞亦 on 5/30/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPQuotesListCell: UITableViewCell {

    @IBOutlet weak var coinBgView: UIView!{
        didSet{
            self.coinBgView.backgroundColor = JXFfffffColor
            
//            coinBgView.layer.shadowOpacity = 1
//            coinBgView.layer.shadowRadius = 2
//            coinBgView.layer.shadowColor = UIColor.rgbColor(rgbValue: 0x000000, alpha: 0.5).cgColor
//            coinBgView.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
    }
    @IBOutlet weak var coinImageView: UIImageView!{
        didSet{
            //self.coinImageView.textColor = JXFfffffColor
            self.coinImageView.layer.cornerRadius = 25.0
            coinImageView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var coinTitleLabel: UILabel!

    @IBOutlet weak var coinPriceLabel: UILabel!
    @IBOutlet weak var coinRateLabel: UILabel!{
        didSet{
            self.coinRateLabel.layer.cornerRadius = 2
            self.coinRateLabel.layer.masksToBounds = true
        }
    }
    var entity : VIPQuotesCellEntity?{
        didSet{
            self.coinTitleLabel.text = entity?.short_name
            self.coinPriceLabel.text = "$\(entity?.price ?? 0)"
            
            if let s = entity?.icon,let url = URL(string: kBaseUrl + s) {
                self.coinImageView.setImageWith(url, placeholderImage: UIImage(named: "coin"))
            }
            if let range = entity?.range {
                if range > 0 {
                    self.coinRateLabel.backgroundColor = JXGreenColor
                    self.coinRateLabel.text = "+\(range)%"
                } else {
                    self.coinRateLabel.backgroundColor = JXRedColor
                    self.coinRateLabel.text = "\(range)%"
                }
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
