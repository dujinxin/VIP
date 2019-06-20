//
//  VIPHomeModel.swift
//  VIP
//
//  Created by 飞亦 on 6/2/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPHomeModel: VIPBaseModel {
    @objc var total_number : Double = 0
    @objc var today_vit_number : Double = 0
    var list = Array<VIPCoinPropertyEntity>()
    var noticeList = Array<VIPNoticesCellEntity>()
    var contentList = Array<String>()
}
class VIPCoinPropertyEntity: VIPBaseModel {
    
    @objc var address : String?
    @objc var available_qty : Double = 0
    @objc var currency_type : Int = 0
    @objc var detail : String?
    @objc var icon : String?
    @objc var id : Int = 0
    @objc var locked_qty : Double = 0
    @objc var min_up_qty : Double = 0
    @objc var min_withdraw_qty : Double = 0
    @objc var name : String?
    @objc var price : Double = 0
    @objc var short_name : String?
    @objc var up_detail : String?
    @objc var up_status : Int = 0
    @objc var withdraw_detail : String?
    @objc var withdraw_fee : Double = 0
    @objc var withdraw_limit_day : Double = 0
    @objc var withdraw_limit_month : Double = 0
    @objc var withdraw_qty : Double = 0
    @objc var withdraw_status : Int = 0
}


