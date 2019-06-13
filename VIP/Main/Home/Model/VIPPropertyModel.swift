//
//  VIPPropertyModel.swift
//  VIP
//
//  Created by 飞亦 on 6/2/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPPropertyModel: VIPBaseModel {
    var coinEntity : VIPCoinPropertyEntity?
    var walletEntity : VIPWalletEntity?
    var recordList = Array<VIPTradeRecordsEntity>()
}
class VIPWalletEntity: VIPBaseModel {
    @objc var id : Int = 0
    @objc var currency_id : Int = 0
    @objc var currency_type : Int = 0
    @objc var currency_name : String?
    @objc var available_qty : Double = 0
    @objc var address : String?
    @objc var locked_qty : Double = 0
    @objc var withdraw_qty : Double = 0
    @objc var status : Int = 0
    @objc var create_time : String?
    @objc var update_time : String?
    @objc var remarks : String?
}
class VIPTradeRecordsEntity: VIPBaseModel {
    
    @objc var type : Int = 0
    @objc var status : Int = 0
    @objc var verify_status : Int = 0
    
    @objc var currency_id : Int = 0
    @objc var currency_name : String?
    
    @objc var operation_fee : Double = 0
    @objc var operation_id : Int = 0
    @objc var operation_address : String?
    @objc var operation_style : Int = 0
    @objc var operation_qty : Double = 0
    
    @objc var create_time : String?
    @objc var update_time : String?
    @objc var remarks : String?
}
//兑换
class VIPExchangeListEntity: VIPBaseModel {
    var list = Array<VIPExchangeCellEntity>()
}
class VIPExchangeCellEntity: VIPBaseModel {
    
    @objc var order_no : String?
    
    @objc var l_currency_name : String?
    @objc var l_currency_price : Float = 0
    @objc var l_currency_qty : Float = 0
    @objc var l_currency_id : Int = 0
    
    @objc var r_currency_name : String?
    @objc var r_currency_id : Int = 0
    @objc var r_currency_qty : Float = 0
    @objc var r_currency_price : Float = 0
    
    @objc var status : Float = 0
    @objc var create_time : String?
}
