//
//  VIPFinancialVM.swift
//  VIP
//
//  Created by 飞亦 on 6/4/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPFinancialVM: NSObject {
    
    //钱包
    var walletListEntity = VIPWalletListEntity()
    func walletList(completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.walletList.rawValue, param: ["lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            if let result = data as? Array<Dictionary<String, Any>> {
                
                for i in 0..<result.count {
                    let entity = VIPCoinPropertyEntity()
                    entity.setValuesForKeys(result[i])
                    self.walletListEntity.list.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //理财账户
    var financialEntity = VIPFinancialEntity()
    
    func financial(completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        JXRequest.request(url: ApiString.financial.rawValue, param: ["lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion(nil, msg, false)
                    return
            }
            self.financialEntity.invest_sum = result["invest_sum"] as? Double ?? 0
            self.financialEntity.profit_sum = result["profit_sum"] as? Double ?? 0
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

    //理财计划
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
    //加入理财计划
    func financialJoin(contract_id: Int, currency_id: Int, currency_qty: Float, pay_password: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        JXRequest.request(url: ApiString.financialJoin.rawValue, param: ["contract_id": contract_id, "currency_id": currency_id,"currency_qty": currency_qty,"pay_password": pay_password, "lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //理财账户及计划
    var programRecordsEntity = VIPFinancialProgramRecordsEntity()
    
    func financialPrograms_Records(completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        JXRequest.request(url: ApiString.financialProgramRecords.rawValue, param: [ "lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            guard let result = data as? Array<Dictionary<String, Any>>
                else{
                    completion(nil, msg, false)
                    return
            }
            for i in 0..<result.count {
                let entity = VIPFinancialProgramRecordsListEntity()
                entity.setValuesForKeys(result[i])
                
                if let contracts = result[i]["contracts"] as? Array<Dictionary<String, Any>>{
                    for i in 0..<contracts.count {
                        let e = VIPFinancialProgramListEntity()
                        e.setValuesForKeys(contracts[i])
                        entity.list.append(e)
                        entity.titles.append(contracts[i]["title"] as? String ?? "")
                    }
                }
                self.programRecordsEntity.list.append(entity)
                
            }
            
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    
    //理财计划记录
    var recordsEntity = VIPFinancialRecordsEntity()
    
    func financialRecords(contract_id: Int, page: Int, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{

        JXRequest.request(url: ApiString.financialRecords.rawValue, param: ["contract_id": contract_id, "page": page, "limit": 10, "lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            if page == 1 {
                self.recordsEntity.list.removeAll()
            }
            if let result = data as? Array<Dictionary<String, Any>> {
                
                for i in 0..<result.count {
                    let entity = VIPFinancialRecordsListEntity()
                    entity.setValuesForKeys(result[i])
                    self.recordsEntity.list.append(entity)
                }
            }
            
            completion(data, msg, true)

        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    
//    //理财计划详情
//    var programEntity = VIPFinancialProgramListEntity()
//
//    func financialRrecordDetail(level_id: Int, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
//        JXRequest.request(url: ApiString.financialRecordDetail.rawValue, param: ["level_id": level_id, "lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
//
//            guard let result = data as? Dictionary<String, Any>
//                else{
//                    completion(nil, msg, false)
//                    return
//            }
//            self.programEntity.invest_money = result["invest_money"] as? Float ?? 0
//
//            if let contracts = result["contracts"] as? Array<Dictionary<String, Any>>{
//                for i in 0..<contracts.count {
//                    let entity = VIPFinancialProgramListEntity()
//                    entity.setValuesForKeys(contracts[i])
//                    self.programEntity.list.append(entity)
//                }
//            }
//
//            completion(data, msg, true)
//
//        }) { (msg, code) in
//            completion(nil, msg, false)
//        }
//    }
    //解除理财计划
    func financialRelease(plan_id: Int, pay_password: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        JXRequest.request(url: ApiString.financialRelease.rawValue, param: ["plan_id": plan_id, "pay_password": pay_password, "lang":LanaguageManager.shared.languageStr], success: { (data, msg) in

            completion(data, msg, true)

        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
