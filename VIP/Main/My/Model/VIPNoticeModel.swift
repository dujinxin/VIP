//
//  VIPNoticeModel.swift
//  VIP
//
//  Created by 飞亦 on 6/2/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPNoticeModel: VIPBaseModel {
    var list = Array<VIPNoticesListEntity>()
}

class VIPNoticesListEntity: VIPBaseModel {
    
    @objc var content_en : String?
    @objc var content_zh : String?
    @objc var title_en : String?
    @objc var title_zh : String?
    @objc var link : String?
    @objc var notice_icon : String?
    @objc var remarks : String?
    @objc var update_time : String?
    @objc var create_time : String?
    
    
    @objc var content_type : Int = 0
    @objc var id : Int = 0
    @objc var status : Int = 0
    @objc var stick : Float = 0
}
