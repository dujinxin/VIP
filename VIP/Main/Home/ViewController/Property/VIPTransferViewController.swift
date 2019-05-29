//
//  VIPTransferViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPTransferViewController: VIPBaseViewController {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight + 20
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            if #available(iOS 11.0, *) {
                self.scrollView.contentInsetAdjustmentBehavior = .never
            } else {
                self.automaticallyAdjustsScrollViewInsets = false
            }
        }
    }
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var numTextFeild: UITextField!
    @IBOutlet weak var toAddressTextField: UITextField!
    @IBOutlet weak var fromAddressLabel: UILabel!
    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
