//
//  VIPAddressCell.swift
//  VIP
//
//  Created by 飞亦 on 7/25/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPAddressCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!{
        didSet{
            self.backView.layer.cornerRadius = 3
            self.backView.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    
    var entity: VIPAddressCellEntity? {
        didSet{
            self.nameLabel.text = entity?.address_remark
            self.coinLabel.text = entity?.currency_name
            self.addressLabel.text = entity?.address
            
            if LanaguageManager.shared.type == .chinese {
                if entity?.verify_status == 0 {
                    self.statusImageView.image = UIImage(named: "unaudited_c")
                } else if entity?.verify_status == 1 {
                    self.statusImageView.image = UIImage(named: "audited_c")
                }
            } else {
                if entity?.verify_status == 0 {
                    self.statusImageView.image = UIImage(named: "unaudited_e")
                } else if entity?.verify_status == 1 {
                    self.statusImageView.image = UIImage(named: "audited_e")
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
