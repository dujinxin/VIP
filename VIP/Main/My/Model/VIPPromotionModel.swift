//
//  VIPPromotionModel.swift
//  VIP
//
//  Created by 飞亦 on 6/11/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPPromotionModel: VIPBaseModel {
    
    @objc var invitation_code : String?
    @objc var invent_url : String?
    
    @objc var invent_counts : Int = 0
    @objc var valid_count : Int = 0
    @objc var user_price : Int = 0
    @objc var team_price : Int = 0
}
