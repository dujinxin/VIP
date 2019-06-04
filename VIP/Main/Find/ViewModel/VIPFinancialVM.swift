//
//  VIPFinancialVM.swift
//  VIP
//
//  Created by 飞亦 on 6/4/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPFinancialVM: NSObject {
    
    var financialEntity = VIPFinancialEntity()
    
    func financial(completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        JXRequest.request(url: ApiString.financial.rawValue, param: ["lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion(nil, msg, false)
                    return
            }
            self.financialEntity.invest_sum = result["invest_sum"] as? Float ?? 0
            self.financialEntity.profit_sum = result["profit_sum"] as? Float ?? 0
            if let levels = result["levels"] as? Array<Dictionary<String, Any>>{
                for i in 0..<levels.count {
                    let entity = VIPFinancialListEntity()
                    entity.setValuesForKeys(levels[i])
                    self.financialEntity.list.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }

    
    var programEntity = VIPFinancialProgramEntity()
    
    func financialProgram(level_id: Int, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        JXRequest.request(url: ApiString.financialProgram.rawValue, param: ["level_id": level_id, "lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion(nil, msg, false)
                    return
            }
            self.programEntity.invest_money = result["invest_money"] as? Float ?? 0
         
            if let contracts = result["contracts"] as? Array<Dictionary<String, Any>>{
                for i in 0..<contracts.count {
                    let entity = VIPFinancialProgramListEntity()
                    entity.setValuesForKeys(contracts[i])
                    self.programEntity.list.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
