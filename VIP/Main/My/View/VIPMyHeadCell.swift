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
            self.topConstraint.constant = kStatusBarHeight
        }
    }
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    
    var entity: UserEntity? {
        didSet{
            if let str = entity?.headImg,let url = URL.init(string:str) {
                self.avatarImageView.setImageWith(url)
            }
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
