//
//  VIPCommunityModel.swift
//  VIP
//
//  Created by 飞亦 on 6/11/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPCommunityModel: VIPBaseModel {
    
    var memberEntity = VIPCommunityMemberEntity()
    var list = Array<VIPCommunityMemberEntity>()
}

class VIPCommunityMemberEntity: VIPBaseModel {
    @objc var name : String?
    
    @objc var status : Int = 0
    @objc var level : Int = 0
    @objc var team_market_value : Double = 0
    @objc var valid_count : Double = 0
    @objc var level_price : Double = 0
    @objc var team_price : Double = 0
}
