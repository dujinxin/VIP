//
//  VIPNotificationTextController.swift
//  VIP
//
//  Created by 飞亦 on 6/13/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPNotificationTextController: VIPBaseViewController {
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    var entity : VIPNoticesCellEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
            
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        self.title = LocalizedString(key: "Notification")
        self.titleLabel.text = self.entity.title
        self.timeLabel.text = self.entity.create_time
        self.contentLabel.text = self.entity.content
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
