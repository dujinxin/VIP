//
//  VIPHomeModel.swift
//  VIP
//
//  Created by 飞亦 on 6/2/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPHomeModel: VIPBaseModel {
    @objc var total_number : Float = 0
    @objc var today_vit_number : Float = 0
    var list = Array<VIPCoinPropertyEntity>()
    var noticeList = Array<VIPNoticesListEntity>()
}
class VIPCoinPropertyEntity: VIPBaseModel {
    
    @objc var deposit_address : String?
    
    @objc var address : String?
    @objc var available_qty : Float = 0
    @objc var currency_type : Int = 0
    @objc var detail : String?
    @objc var icon : String?
    @objc var id : Int = 0
    @objc var locked_qty : Float = 0
    @objc var min_up_qty : Float = 0
    @objc var min_withdraw_qty : Float = 0
    @objc var name : String?
    @objc var price : Float = 0
    @objc var short_name : String?
    @objc var up_detail : String?
    @objc var up_status : Int = 0
    @objc var withdraw_detail : String?
    @objc var withdraw_fee : Float = 0
    @objc var withdraw_limit_day : Float = 0
    @objc var withdraw_limit_month : Float = 0
    @objc var withdraw_qty : Float = 0
    @objc var withdraw_status : Int = 0
}


