//
//  VIPPropertyVM.swift
//  VIP
//
//  Created by 飞亦 on 6/2/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPPropertyVM: NSObject {
    

    var propertyEntity = VIPPropertyModel()
    
    func propertyDetail(currencyId: Int, queryType: Int, page: Int, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.propertyDetails.rawValue, param: ["currency_id":currencyId,"type":queryType,"page":page,"limit": 10,"lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion(nil, msg, false)
                    return
            }
            if page == 1 {
                self.propertyEntity.recordList.removeAll()
            }
            if let currency = result["currency"] as? Dictionary<String, Any> {
                self.propertyEntity.coinEntity = VIPCoinPropertyEntity()
                self.propertyEntity.coinEntity?.setValuesForKeys(currency)
            }
            if let wallet = result["wallet"] as? Dictionary<String, Any> {
                self.propertyEntity.walletEntity = VIPWalletEntity()
                self.propertyEntity.walletEntity?.setValuesForKeys(wallet)
            }
            if let details = result["details"] as? Array<Dictionary<String, Any>> {
                for i in 0..<details.count {
                    let entity = VIPTradeRecordsEntity()
                    entity.setValuesForKeys(details[i])
                    self.propertyEntity.recordList.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //转账
    func propertyTransfer(currency_id: Int, operation_qty: Float, operation_address: String, pay_password: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        JXRequest.request(url: ApiString.propertyTransfer.rawValue, param: ["operation_qty": operation_qty, "currency_id": currency_id,"operation_address": operation_address,"pay_password": pay_password, "lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //兑换
    func propertyExchange(l_currency_id: Int, l_currency_qty: Float, r_currency_id: Int, pay_password: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        JXRequest.request(url: ApiString.propertyExchange.rawValue, param: ["l_currency_id": l_currency_id, "l_currency_qty": l_currency_qty,"r_currency_id": r_currency_id,"pay_password": pay_password, "lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
    //兑换列表
    var exchangeListEntity = VIPExchangeListEntity()
    
    func exchangeList(page: Int, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.propertyExchangeList.rawValue, param: ["page":page, "limit": 10, "lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            if page == 1 {
                self.exchangeListEntity.list.removeAll()
            }
            if let result = data as? Array<Dictionary<String, Any>> {
                
                for i in 0..<result.count {
                    let entity = VIPExchangeCellEntity()
                    entity.setValuesForKeys(result[i])
                    self.exchangeListEntity.list.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
