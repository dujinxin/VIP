//
//  VIPNotificationVM.swift
//  VIP
//
//  Created by 飞亦 on 6/2/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPNotificationVM: NSObject {

    var noticeListEntity = VIPNoticeModel()
    
    
    func noticeList(page: Int, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.noticeLists.rawValue, param: ["page":page,"limit": 20,"lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            guard let result = data as? Array<Dictionary<String, Any>>
                else{
                    completion(nil, msg, false)
                    return
            }
            if page == 1 {
                self.noticeListEntity.list.removeAll()
            }
            for i in 0..<result.count {
                let entity = VIPNoticesListEntity()
                entity.setValuesForKeys(result[i])
                self.noticeListEntity.list.append(entity)
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
