//
//  VIPCommunityVM.swift
//  VIP
//
//  Created by 飞亦 on 6/11/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPCommunityVM: NSObject {
    var communityEntity = VIPCommunityModel()
    
    func community(completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.community.rawValue, param: ["lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            
            guard let result = data as? Dictionary<String, Any>
                else{
                    completion(nil, msg, false)
                    return
            }
            self.communityEntity.memberEntity.setValuesForKeys(result)
            if let arr = result["users"] as? Array<Dictionary<String, Any>> {
                for i in 0..<arr.count {
                    let entity = VIPCommunityMemberEntity()
                    entity.setValuesForKeys(arr[i])
                    self.communityEntity.list.append(entity)
                }
            }
            
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
