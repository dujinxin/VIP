//
//  VIPBaseModel.swift
//  VIP
//
//  Created by 飞亦 on 5/27/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

class VIPBaseModel: BaseModel {

    override open func setValue(_ value: Any?, forUndefinedKey key: String) {
        print("undefinedKey:\(key)")
        //print("class:\(type(of: self)) undefinedKey:\(key) Value:\(String(describing: value))")
    }
}
