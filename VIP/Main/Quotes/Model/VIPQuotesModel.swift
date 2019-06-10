//
//  VIPQuotesModel.swift
//  VIP
//
//  Created by 飞亦 on 6/6/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPQuotesListEntity: VIPBaseModel {
    var list = Array<VIPQuotesCellEntity>()
}
class VIPQuotesCellEntity: VIPBaseModel {
    
    @objc var icon : String?
    @objc var short_name : String?
    @objc var price : Float = 0
    @objc var range : Float = 0

}
