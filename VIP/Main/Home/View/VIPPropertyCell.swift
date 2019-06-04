//
//  VIPPropertyCell.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPPropertyCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!{
        didSet{
            self.typeLabel.textColor = JXBlackTextColor
        }
    }
    @IBOutlet weak var numTitleLabel: UILabel!{
        didSet{
            self.numTitleLabel.textColor = JX092641Color
        }
    }
    @IBOutlet weak var numLabel: UILabel!{
        didSet{
            self.numLabel.textColor = JXBlueColor
        }
    }
    @IBOutlet weak var statusTitleLabel: UILabel!{
        didSet{
            self.statusTitleLabel.textColor = JX092641Color
        }
    }
    @IBOutlet weak var statusLabel: UILabel!{
        didSet{
            self.statusLabel.textColor = JX809FBCColor
        }
    }
    @IBOutlet weak var timeTitleLabel: UILabel!{
        didSet{
            self.timeTitleLabel.textColor = JX092641Color
        }
    }
    @IBOutlet weak var timeLabel: UILabel!{
        didSet{
            self.timeLabel.textColor = JX7999B8Color
        }
    }
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
