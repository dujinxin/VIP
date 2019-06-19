//
//  VIPMyHeadCell.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPMyHeadCell: UITableViewCell {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight
        }
    }
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var statusBgView: UIView!{
        didSet{
            self.statusBgView.layer.cornerRadius = 5
            self.statusBgView.layer.borderColor = UIColor.rgbColor(rgbValue: 0x57abff).cgColor
            self.statusBgView.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var statusLabel: UILabel!{
        didSet{
            self.statusLabel.textColor = UIColor.rgbColor(rgbValue: 0x57abff)
            
        }
    }
    @IBOutlet weak var promotionImageView: UIImageView!{
        didSet{
            self.promotionImageView.isUserInteractionEnabled = true
            self.promotionImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(promotionAction)))
        }
    }
    
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    
    var entity: VIPMyModel? {
        didSet{
            if let str = entity?.icon,let url = URL.init(string:str) {
                self.avatarImageView.setImageWith(url)
            }
            if let nickName = entity?.name, nickName.isEmpty == false {
                self.nickNameLabel.text = nickName
            } else {
                self.nickNameLabel.text = UserManager.manager.userEntity.username
            }
      
            if entity?.status == 0 {
                self.statusLabel.text = LocalizedString(key: "My_notActive")
            } else if entity?.status == 1 {
                self.statusLabel.text = LocalizedString(key: "My_effective")
            } else if entity?.status == 2 {
                self.statusLabel.text = LocalizedString(key: "My_qualified")
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
    @objc var promotionBlock : (()->())?
    
    
    @objc func promotionAction() {
        if let block = self.promotionBlock {
            block()
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
