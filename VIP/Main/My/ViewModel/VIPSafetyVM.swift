//
//  VIPSafetyVM.swift
//  VIP
//
//  Created by 飞亦 on 6/3/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPSafetyVM: NSObject {
    
    var mnemonic = ""
    var privateKey = ""
    

    //修改密码
    func modifyPsd(type: Int, used_password: String, new_password: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.modifyPsd.rawValue, param: ["type": type, "used_password": used_password ,"new_password": new_password,"lang":LanaguageManager.shared.languageStr], success: { (data, message) in
            
            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    
    //获取私钥
    func fetchPrivateKey(pay_password: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.privateKey.rawValue, param: ["lang":LanaguageManager.shared.languageStr, "pay_password": pay_password], success: { (data, message) in
            self.privateKey = data as! String
            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //获取助记词
    func fetchMnemonic(pay_password: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.mnemonic.rawValue, param: ["lang":LanaguageManager.shared.languageStr, "pay_password": pay_password], success: { (data, message) in
            self.mnemonic = data as! String
            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
}
