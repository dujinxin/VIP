//
//  VIPFindModel.swift
//  VIP
//
//  Created by 飞亦 on 6/13/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPFindModel: VIPBaseModel {

    var list = Array<VIPBannerEntity>()
    var imageList = Array<String>()
}

class VIPBannerEntity: VIPBaseModel {
    @objc var status : Int = 0
    @objc var image : String?
    @objc var click : String?
}
