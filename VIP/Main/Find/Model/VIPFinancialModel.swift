//
//  VIPFinancialModel.swift
//  VIP
//
//  Created by 飞亦 on 6/4/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPFinancialModel: VIPBaseModel {
    
}
//钱包
class VIPWalletListEntity: VIPBaseModel {
    var list = Array<VIPCoinPropertyEntity>()
}
//理财首页
class VIPFinancialEntity: VIPBaseModel {
    @objc var invest_sum : Double = 0
    @objc var profit_sum : Double = 0
    var list = Array<VIPFinancialListEntity>()
}

class VIPFinancialListEntity: VIPBaseModel {
    
    @objc var id : Int = 0
    @objc var level : Int = 0
    @objc var level_name : String?
    @objc var min_money : Double = 0
    @objc var max_money : Double = 0
}
//账户及计划总表
class VIPFinancialProgramRecordsEntity: VIPBaseModel {
    var list = Array<VIPFinancialProgramRecordsListEntity>()
}
class VIPFinancialProgramRecordsListEntity: VIPFinancialListEntity {
    var list = Array<VIPFinancialProgramListEntity>()
    var titles = Array<String>()   //用于自定义视图显示
}
//理财计划
class VIPFinancialProgramEntity: VIPBaseModel {
    @objc var invest_money : Double = 0
    var list = Array<VIPFinancialProgramListEntity>()
}

class VIPFinancialProgramListEntity: VIPBaseModel {
    
    @objc var id : Int = 0
    @objc var level_id : Int = 0
    @objc var title : String?
    @objc var cycle_value : Int = 0 //合约周期月 0为活期合约
    @objc var interest_range : String?
    
    @objc var return_id : Int = 0
    
}
//理财记录
class VIPFinancialRecordsEntity: VIPBaseModel {
    @objc var invest_money : Double = 0
    var list = Array<VIPFinancialRecordsListEntity>()
}

class VIPFinancialRecordsListEntity: VIPBaseModel {
    
    @objc var id : Int = 0
    @objc var plan_status : Int = 0
    @objc var contract_price : Double = 0
    
    @objc var currency_name : String?
    @objc var create_time : String?
    @objc var expire_time : String?
    
    @objc var bonus_price : Double = 0
    @objc var deduct_price : Double = 0
}
