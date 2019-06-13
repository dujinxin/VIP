//
//  VIPIncomeVM.swift
//  VIP
//
//  Created by 飞亦 on 6/11/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPIncomeVM: NSObject {
    var incomeEntity = VIPIncomeModel()
    
    func income(completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.income.rawValue, param: ["lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion(nil, msg, false)
                    return
            }
            
            self.incomeEntity.setValuesForKeys(result)
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    
    var incomeListEntity = VIPIncomeListEntity()
    
    func incomeRecords(page: Int, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.incomeRecords.rawValue, param: ["page":page,"limit": 20,"lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            guard let result = data as? Array<Dictionary<String, Any>>
                else{
                    completion(nil, msg, false)
                    return
            }
            if page == 1 {
                self.incomeListEntity.list.removeAll()
            }
            for i in 0..<result.count {
                let entity = VIPIncomeCellEntity()
                entity.setValuesForKeys(result[i])
                self.incomeListEntity.list.append(entity)
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
