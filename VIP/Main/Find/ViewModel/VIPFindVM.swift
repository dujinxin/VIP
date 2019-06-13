//
//  VIPFindVM.swift
//  VIP
//
//  Created by 飞亦 on 6/13/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPFindVM: NSObject {
    var findEntity = VIPFindModel()
    
    func find(completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.find.rawValue, param: ["lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            guard let result = data as? Array<Dictionary<String, Any>>
                else{
                    completion(nil, msg, false)
                    return
            }
            self.findEntity.list.removeAll()
            self.findEntity.imageList.removeAll()
            result.forEach({ (dict) in
                let entity = VIPBannerEntity()
                entity.setValuesForKeys(dict)
                self.findEntity.list.append(entity)
                self.findEntity.imageList.append(kBaseUrl + (dict["image"] as? String ?? ""))
            })
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
