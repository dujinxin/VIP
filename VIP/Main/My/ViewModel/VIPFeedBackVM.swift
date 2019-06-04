//
//  VIPFeedBackVM.swift
//  VIP
//
//  Created by 飞亦 on 6/2/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPFeedBackVM: NSObject {

    func feedback(text: String, completion: @escaping ((_ data: Any?, _ msg: String, _ isSuccess: Bool)->())) -> Void{
        
        JXRequest.request(url: ApiString.feedback.rawValue, param: ["text":text,"lang":LanaguageManager.shared.languageStr], success: { (data, msg) in
            completion(data, msg, true)
            
        }) { (msg, code) in
            completion(nil, msg, false)
        }
    }
}
