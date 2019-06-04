//
//  VIPFinancialRecordsAlertController.swift
//  VIP
//
//  Created by 飞亦 on 6/3/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPFinancialRecordsAlertController: VIPBaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!{
        didSet{
            self.cancelButton.backgroundColor = JXCyanColor
        }
    }
    @IBOutlet weak var confirmButton: UIButton!{
        didSet{
            self.confirmButton.backgroundColor = JXCyanColor
        }
    }
    @IBOutlet weak var totalCastLabel: UILabel!
    @IBOutlet weak var totalIncomeLabel: UILabel!
    @IBOutlet weak var interestIncomeLabel: UILabel!
    
    @IBOutlet weak var psdTextField: UITextField!
    
    @IBOutlet weak var noticeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func cancelAction(_ sender: Any) {
        if let block = self.backBlock {
            block()
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmAction(_ sender: UIButton) {
        if let block = self.backBlock {
            block()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
}
