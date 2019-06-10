//
//  VIPQuotesVM.swift
//  VIP
//
//  Created by 飞亦 on 6/6/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPQuotesVM: NSObject {

    //行情列表
    var quotesListEntity = VIPQuotesListEntity()
    
    func quotesList(completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.quotesList.rawValue, param: ["lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            if let result = data as? Array<Dictionary<String, Any>> {
                
                for i in 0..<result.count {
                    let entity = VIPQuotesCellEntity()
                    entity.setValuesForKeys(result[i])
                    self.quotesListEntity.list.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
