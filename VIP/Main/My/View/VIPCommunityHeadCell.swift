//
//  VIPCommunityHeadCell.swift
//  VIP
//
//  Created by 飞亦 on 6/4/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPCommunityHeadCell: UITableViewCell {

    @IBOutlet weak var nickNameLabel: UILabel!
   
    @IBOutlet weak var communityValueLabel: UILabel!
    @IBOutlet weak var availalbeAccountLabel: UILabel!
    @IBOutlet weak var communityRewardLabel: UILabel!
    @IBOutlet weak var normalRewardLabel: UILabel!
    @IBOutlet weak var title1Label: UILabel!
    @IBOutlet weak var title2Label: UILabel!
    @IBOutlet weak var title3Label: UILabel!
    @IBOutlet weak var title4Label: UILabel!
    
    @IBOutlet weak var bg1View: UIView!{
        didSet{
            self.bg1View.backgroundColor = JXCyanColor
            self.bg1View.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var bg2View: UIView!{
        didSet{
            self.bg2View.backgroundColor = JXCyanColor
            self.bg2View.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var bg3View: UIView!{
        didSet{
            self.bg3View.backgroundColor = JXCyanColor
            self.bg3View.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var bg4View: UIView!{
        didSet{
            self.bg4View.backgroundColor = JXCyanColor
            self.bg4View.layer.cornerRadius = 10
        }
    }
    
    
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    
    var entity: UserEntity? {
        didSet{
            
            self.nickNameLabel.text = entity?.nickname
            
            switch entity?.user_level {
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
