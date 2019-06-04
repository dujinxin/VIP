//
//  VIPPropertyModel.swift
//  VIP
//
//  Created by 飞亦 on 6/2/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPPropertyModel: VIPBaseModel {
    var coinEntity : VIPHomeListEntity?
    var walletEntity : VIPWalletEntity?
    var recordList = Array<VIPNoticesListEntity>()
}
class VIPWalletEntity: VIPBaseModel {
    @objc var id : Int = 0
    @objc var currency_id : Int = 0
    @objc var currency_type : Int = 0
    @objc var currency_name : String?
    @objc var available_qty : Float = 0
    @objc var address : String?
    @objc var locked_qty : Float = 0
    @objc var withdraw_qty : Float = 0
    @objc var status : Int = 0
    @objc var create_time : String?
    @objc var update_time : String?
    @objc var remarks : String?
}
