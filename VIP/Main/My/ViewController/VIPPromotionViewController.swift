//
//  VIPPromotionViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

class VIPPromotionViewController: VIPBaseViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight + 10
        }
    }
    
    @IBOutlet weak var codeImageView: UIImageView!

    @IBOutlet weak var inviteNumLabel: UILabel!
    @IBOutlet weak var validAccountLabel: UILabel!
    @IBOutlet weak var personalPerformanceLabel: UILabel!
    @IBOutlet weak var sharePerformanceNumLabel: UILabel!
    @IBOutlet weak var inviteCodeLabel: UILabel!
    
    @IBOutlet weak var copyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func copyCodeAction(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.inviteCodeLabel.text
        ViewManager.showNotice("已复制")
    }
    @IBAction func copyUrlAction(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = "url"
        ViewManager.showNotice("已复制")
       
    }
 
}
