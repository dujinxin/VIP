//
//  VIPVersionAlertController.swift
//  VIP
//
//  Created by 飞亦 on 6/18/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPVersionAlertController: VIPBaseViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!{
        didSet{
            self.contentView.backgroundColor = UIColor.clear
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!{
        didSet{
            self.confirmButton.layer.cornerRadius = 37.5 / 2
            self.confirmButton.backgroundColor = JXCyanColor
        }
    }

    
    var entity : VIPVersionModel!
    
    var callBackBlock : ((_ isDownload: Bool)->())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clear
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.contentLabel.text = "VIB \(self.entity.ios_version ?? Bundle.main.version)"
        
        
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    @IBAction func confirmAction(_ sender: Any) {
        
        if let block = self.callBackBlock {
            block(!(Bundle.main.version == self.entity.ios_version))
        }
        self.dismiss(animated: true, completion: nil)
    }

}
