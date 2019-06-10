//
//  VIPExRecordsDetailController.swift
//  VIP
//
//  Created by 飞亦 on 5/30/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPExRecordsDetailController: VIPBaseViewController {
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight + 15
        }
    }
    
    @IBOutlet weak var numTitleLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    
    @IBOutlet weak var coinNumTitleLabel: UILabel!
    @IBOutlet weak var coinNumLabel: UILabel!
    
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var priceNumTitleLabel: UILabel!
    @IBOutlet weak var priceNumLabel: UILabel!
    
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var entity : VIPExchangeCellEntity!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = JXViewBgColor
        
        self.title = "记录详情"
        self.customNavigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon-back"), style: .plain, target: self, action: #selector(back))

        self.numTitleLabel.text = self.entity.l_currency_name
        self.numLabel.text = "\(self.entity.l_currency_qty)"
        self.coinNumTitleLabel.text = self.entity.r_currency_name
        self.coinNumLabel.text = "\(self.entity.r_currency_qty)"
        self.priceTitleLabel.text = self.entity.l_currency_name
        self.priceLabel.text = "$\(self.entity.l_currency_price)"
        self.priceNumTitleLabel.text = self.entity.r_currency_name
        self.priceNumLabel.text = "$\(self.entity.r_currency_price)"
        self.orderLabel.text = self.entity.order_no
        self.statusLabel.text = "已完成"
        self.timeLabel.text = self.entity.create_time
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
}
