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
            if let currency = result["currencys"] as? Dictionary<String, Any> {
                self.propertyEntity.coinEntity = VIPHomeListEntity()
                self.propertyEntity.coinEntity?.setValuesForKeys(currency)
            }
            if let wallet = result["wallet"] as? Dictionary<String, Any> {
                self.propertyEntity.walletEntity = VIPWalletEntity()
                self.propertyEntity.walletEntity?.setValuesForKeys(wallet)
            }
            if let details = result["details"] as? Array<Dictionary<String, Any>> {
                for i in 0..<details.count {
//                    let entity = VIPNoticesListEntity()
//                    entity.setValuesForKeys(notices[i])
//                    self.homeEntity.noticeList.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
