//
//  VIPHomeVM.swift
//  VIP
//
//  Created by 飞亦 on 6/1/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPHomeVM: NSObject {

    var homeEntity = VIPHomeModel()
    
    
    func home(completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.homeInfo.rawValue, param: ["lang": LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion(nil, msg, false)
                    return
            }
            self.homeEntity.list.removeAll()
            self.homeEntity.noticeList.removeAll()
            self.homeEntity.contentList.removeAll()
            self.homeEntity.today_vit_number = result["today_vit_number"] as? Double ?? 0
            var totalNum : Double = 0
            
            if let currencys = result["currencys"] as? Array<Dictionary<String, Any>> {
                for i in 0..<currencys.count {
                    let entity = VIPCoinPropertyEntity()
                    entity.setValuesForKeys(currencys[i])
                    self.homeEntity.list.append(entity)
                    totalNum += entity.available_qty * entity.price
                }
                self.homeEntity.total_number = totalNum
            }
            if let notices = result["notices"] as? Array<Dictionary<String, Any>> {
                for i in 0..<notices.count {
                    let entity = VIPNoticesCellEntity()
                    entity.setValuesForKeys(notices[i])
                    self.homeEntity.noticeList.append(entity)
                    self.homeEntity.contentList.append(entity.content ?? "")
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
