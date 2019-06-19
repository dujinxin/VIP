//
//  VIPExportViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPExportViewController: VIPBaseViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight + 10
        }
    }
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var copyButton: UIButton!
    
    var privateKey = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = JXFfffffColor
        
        self.addressLabel.text = self.privateKey
    }
    @IBAction func copyAction(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.addressLabel.text
        ViewManager.showNotice(LocalizedString(key: "Copied"))
    }
    
}
