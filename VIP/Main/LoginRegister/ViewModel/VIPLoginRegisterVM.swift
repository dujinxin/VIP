//
//  VIPLoginRegisterVM.swift
//  VIP
//
//  Created by 飞亦 on 6/1/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPLoginRegisterVM: NSObject {

    //登录
    func login(userName: String, password: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        let request = JXRequest.init(url: ApiString.login.rawValue, param: ["username": userName, "password": password,"lang":LanaguageManager.shared.languageStr], success: { (data, message) in
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil,message,false)
                    return
            }
            print(dict)
            

            let _ = UserManager.manager.saveAccound(dict: dict)
            completion(nil,message,true)
        }, failure: { (message, code) in
            completion(nil,message,false)
        }, progress: nil, download: nil, destination: nil)
        request.startRequest()
        
//        JXRequest.request(url: ApiString.login.rawValue, param: ["username": userName, "password": password,"lang":"zh"], success: { (data, message) in
//            guard
//                let dict = data as? Dictionary<String, Any>
//                else{
//                    completion(nil,message,false)
//                    return
//            }
//            print(dict)
//            let _ = UserManager.manager.saveAccound(dict: dict)
//            completion(nil,message,true)
//        }) { (message, code) in
//            completion(nil,message,false)
//        }
    }
    //注册
    func register(username: String, password: String, pay_password: String, invitation_code: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.register.rawValue, param: ["username": username, "password": password, "pay_password": pay_password ,"invitation_code":invitation_code,"lang":LanaguageManager.shared.languageStr], success: { (data, message) in
            guard
                let dict = data as? Dictionary<String, Any>
                else{
                    completion(nil,message,false)
                    return
            }
          
            let _ = UserManager.manager.saveAccound(dict: dict)
            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //重设密码
    func resetPsd(text: String, type: Int, password: String, completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())){
        JXRequest.request(url: ApiString.resetPsd.rawValue, param: ["text": text, "password": password ,"type": type, "lang":LanaguageManager.shared.languageStr], success: { (data, message) in

            completion(nil,message,true)
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
    //退出
    func logout(completion:@escaping ((_ data:Any?, _ msg:String,_ isSuccess:Bool)->())) {
        JXRequest.request(url: ApiString.logout.rawValue, param: ["lang":LanaguageManager.shared.languageStr], success: { (data, message) in
            completion(data,message,true)
            
        }) { (message, code) in
            completion(nil,message,false)
        }
    }
}
