//
//  VIPIncomRecordsCell.swift
//  VIP
//
//  Created by 飞亦 on 6/12/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPIncomRecordsCell: UITableViewCell {

    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var entity: VIPIncomeCellEntity? {
        didSet{
            self.numLabel.text = "\(entity?.currency_qty ?? 0) \(entity?.currency_name ?? "")"
            self.timeLabel.text = entity?.create_time
            //1:合约收益 2：分享收益 3：分享收益 4社区收益 5：平级收益
            if entity?.type == 1 {
                self.typeLabel.text = "合约收益"
            } else if entity?.type == 2 {
                self.typeLabel.text = "分享收益"
            } else if entity?.type == 3 {
                self.typeLabel.text = "分享收益"
            } else if entity?.type == 4 {
                self.typeLabel.text = "社区收益"
            } else if entity?.type == 5 {
                self.typeLabel.text = "平级收益"
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
