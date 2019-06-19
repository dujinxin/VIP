//
//  UserManager.swift
//  ZPSY
//
//  Created by 杜进新 on 2017/9/22.
//  Copyright © 2017年 zhouhao. All rights reserved.
//

import Foundation

private let userPath = NSHomeDirectory() + "/Documents/userAccound.json"

class UserEntity: VIPBaseModel {
    
    @objc var nickname : String?
    @objc var username : String = ""
    @objc var mobile : String?
    @objc var headImg : String?
    @objc var create_date : String?
    @objc var update_date : String?
    @objc var invitation_code : String?
    @objc var mnemonic : String?
    @objc var master_private_key : String?
    
    @objc var status : Int = 0
    @objc var invent_level : Int = 0
    @objc var invent_id : Int = 0
    @objc var invent_counts : Int = 0
    @objc var vip_level : Int = 0
    @objc var user_level : Int = 0
    @objc var dynamic_user_level : Int = 0
    
    
    @objc var beegosessionID : String = "7550879a1e9746fe470fbcfbdad7870c"
    //"Set-Cookie" =     (
    //"beegosessionID=7550879a1e9746fe470fbcfbdad7870c; Path=/; HttpOnly"
    //);

}

class UserManager : NSObject{
    
    static let manager = UserManager()
    
    //登录接口获取
    var userEntity = UserEntity()
    //
    var userDict = Dictionary<String, Any>()
    
    var isLogin: Bool {
        get {
            return !userEntity.username.isEmpty
        }
    }
    
    override init() {
        super.init()
        
        let pathUrl = URL(fileURLWithPath: userPath)
        
        guard
            let data = try? Data(contentsOf: pathUrl),
            let dict = try? JSONSerialization.jsonObject(with: data, options: [])else {
                print("该地址不存在用户信息：\(userPath)")
                return
        }
        self.userDict = dict as! [String : Any]
        self.userEntity.setValuesForKeys(dict as! [String : Any])
        print(dict)
        print("用户地址：\(userPath)")
        
    }
    
    /// 保存用户信息
    ///
    /// - Parameter dict: 用户信息字典
    /// - Returns: 保存结果
    func saveAccound(dict:Dictionary<String, Any>) -> Bool {

        self.userDict = dict
        self.userEntity.setValuesForKeys(dict)

        guard let data = try? JSONSerialization.data(withJSONObject: dict, options: [])
            else {
                return false
        }
        try? data.write(to: URL.init(fileURLWithPath: userPath))
        print("保存地址：\(userPath)")
        
        return true
    }
    /// 删除用户信息
    func removeAccound() {
        self.userEntity = UserEntity()
        
        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: userPath)
    }
    
}
extension UserManager {
    func updateNickName(_ nickName: String) {
        var dict = self.userDict
        dict["nickname"] = nickName
        let _ = self.saveAccound(dict: dict)
    }
    func updateAvatar(_ avatar: String) {
        var dict = self.userDict
        dict["headImg"] = avatar
        let _ = self.saveAccound(dict: dict)
    }
}
