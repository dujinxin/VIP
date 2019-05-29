//
//  VIPHomeHeaderCell.swift
//  VIP
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPHomeHeaderCell: UITableViewCell {

    @IBOutlet weak var propertyBgView: UIView!{
        didSet{
            self.propertyBgView.backgroundColor = JXBlueColor
            
            propertyBgView.layer.cornerRadius = 4
            propertyBgView.layer.shadowOpacity = 1
            propertyBgView.layer.shadowRadius = 7
            propertyBgView.layer.shadowColor = JXBlueShadow.cgColor
            propertyBgView.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
    @IBOutlet weak var totalTitleLabel: UILabel!{
        didSet{
            self.totalTitleLabel.textColor = JXFfffffColor
        }
    }
    @IBOutlet weak var totalPropertyLabel: UILabel!{
        didSet{
            self.totalPropertyLabel.textColor = JXFfffffColor
        }
    }
    @IBOutlet weak var todayIncomeLabel: UILabel!{
        didSet{
            self.todayIncomeLabel.textColor = JXFfffffColor
        }
    }
    @IBOutlet weak var manageButton: UIButton!{
        didSet{
            self.manageButton.backgroundColor = JXFfffffColor
            self.manageButton.setTitleColor(JXBlueColor, for: .normal)
            self.manageButton.setTitle("理财", for: .normal)
            
            manageButton.layer.cornerRadius = 4
            manageButton.layer.borderColor = JXFfffffColor.cgColor
            manageButton.layer.borderWidth = 1
          
        }
    }
    @IBOutlet weak var superNodeButton: UIButton!{
        didSet{
            self.superNodeButton.backgroundColor = JXBlueColor
            self.superNodeButton.setTitleColor(JXFfffffColor, for: .normal)
            self.superNodeButton.setTitle("超级节点", for: .normal)
            
            superNodeButton.layer.cornerRadius = 4
            superNodeButton.layer.borderColor = JXFfffffColor.cgColor
            superNodeButton.layer.borderWidth = 1
        }
    }
    
    @IBOutlet weak var noticeBgView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
