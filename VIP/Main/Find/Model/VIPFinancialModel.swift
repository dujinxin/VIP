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
//理财首页
class VIPFinancialEntity: VIPBaseModel {
    @objc var invest_sum : Float = 0
    @objc var profit_sum : Float = 0
    var list = Array<VIPFinancialListEntity>()
}

class VIPFinancialListEntity: VIPBaseModel {
    
    @objc var id : Int = 0
    @objc var level : Int = 0
    @objc var level_name : String?
    @objc var min_money : Float = 0
    @objc var max_money : Float = 0
}
//理财计划
class VIPFinancialProgramEntity: VIPBaseModel {
    @objc var invest_money : Float = 0
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
