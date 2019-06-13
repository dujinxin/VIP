//
//  VIPCommunityListCell.swift
//  VIP
//
//  Created by 飞亦 on 6/4/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPCommunityListCell: UITableViewCell {
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var availalbeAccountLabel: UILabel!
    @IBOutlet weak var communityValueLabel: UILabel!
    
    @IBOutlet weak var title1Label: UILabel!
    @IBOutlet weak var title2Label: UILabel!
    
    
    @IBOutlet weak var topBgView: UIView!{
        didSet{
            self.topBgView.backgroundColor = UIColor.rgbColor(rgbValue: 0xeff3f8)
            self.topBgView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var bgView: UIView!{
        didSet{
            self.bgView.backgroundColor = JXCyanColor
            self.bgView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var bottomBgView: UIView!{
        didSet{
            
        }
    }
    
    
    
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    
    var entity: VIPCommunityMemberEntity? {
        didSet{
            
            self.nickNameLabel.text = entity?.name
            self.communityValueLabel.text = "\(entity?.team_market_value ?? 0)"
            self.availalbeAccountLabel.text = "\(entity?.valid_count ?? 0)"
            if let level = entity?.level, level > 0 {
                self.statusImageView.image = UIImage(named: "available")
            } else {
                self.statusImageView.image = UIImage(named: "unavailable")
            }
            switch entity?.level {
            case 1:
                self.star1ImageView.isHidden = false
                self.star2ImageView.isHidden = true
                self.star3ImageView.isHidden = true
                self.star4ImageView.isHidden = true
                self.star5ImageView.isHidden = true
            case 2:
                self.star1ImageView.isHidden = false
                self.star2ImageView.isHidden = false
                self.star3ImageView.isHidden = true
                self.star4ImageView.isHidden = true
                self.star5ImageView.isHidden = true
            case 3:
                self.star1ImageView.isHidden = false
                self.star2ImageView.isHidden = false
                self.star3ImageView.isHidden = false
                self.star4ImageView.isHidden = true
                self.star5ImageView.isHidden = true
            case 4:
                self.star1ImageView.isHidden = false
                self.star2ImageView.isHidden = false
                self.star3ImageView.isHidden = false
                self.star4ImageView.isHidden = false
                self.star5ImageView.isHidden = true
            case 5:
                self.star1ImageView.isHidden = false
                self.star2ImageView.isHidden = false
                self.star3ImageView.isHidden = false
                self.star4ImageView.isHidden = false
                self.star5ImageView.isHidden = false
            default:
                self.star1ImageView.isHidden = true
                self.star2ImageView.isHidden = true
                self.star3ImageView.isHidden = true
                self.star4ImageView.isHidden = true
                self.star5ImageView.isHidden = true
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
