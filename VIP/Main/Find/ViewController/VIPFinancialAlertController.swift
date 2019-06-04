//
//  VIPFinancialAlertController.swift
//  VIP
//
//  Created by 飞亦 on 5/31/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPFinancialAlertController: VIPBaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var BTCButton: UIButton!{
        didSet{
            self.BTCButton.backgroundColor = JXBlueColor
            self.BTCButton.setTitleColor(JXFfffffColor, for: .normal)
            self.BTCButton.layer.borderWidth = 1
            self.BTCButton.layer.borderColor = JXGrayTextColor.cgColor
            self.BTCButton.isSelected = true
        }
    }
    @IBOutlet weak var ETHButton: UIButton!{
        didSet{
            self.ETHButton.backgroundColor = JXFfffffColor
            self.ETHButton.setTitleColor(JXGrayTextColor, for: .normal)
            self.ETHButton.layer.borderWidth = 1
            self.ETHButton.layer.borderColor = JXGrayTextColor.cgColor
            self.ETHButton.isSelected = false
        }
    }
    @IBOutlet weak var USDTButton: UIButton!{
        didSet{
            self.USDTButton.backgroundColor = JXFfffffColor
            self.USDTButton.setTitleColor(JXGrayTextColor, for: .normal)
            self.USDTButton.layer.borderWidth = 1
            self.USDTButton.layer.borderColor = JXGrayTextColor.cgColor
            self.USDTButton.isSelected = false
        }
    }
    
    @IBOutlet weak var priseLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var psdTextField: UITextField!
    @IBOutlet weak var allButton: UIButton!{
        didSet{
            self.allButton.layer.borderWidth = 1
            self.allButton.layer.borderColor = JXGrayTextColor.cgColor
        }
    }
    
    @IBOutlet weak var confirmButton: UIButton!{
        didSet{
            //self.USDTButton.backgroundColor =
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.clear
        
        
        // Do any additional setup after loading the view.
    }
    @IBAction func dismissAlert(_ sender: Any) {
        if let block = self.backBlock {
            block()
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func btcAction(_ sender: UIButton) {
        self.setSelectedStatus(button: sender)
        self.setUnselectedStatus(button: self.ETHButton)
        self.setUnselectedStatus(button: self.USDTButton)
    }
    @IBAction func ethAction(_ sender: UIButton) {
        self.setSelectedStatus(button: sender)
        self.setUnselectedStatus(button: self.BTCButton)
        self.setUnselectedStatus(button: self.USDTButton)
    }
    @IBAction func usdtAction(_ sender: UIButton) {
        self.setSelectedStatus(button: sender)
        self.setUnselectedStatus(button: self.ETHButton)
        self.setUnselectedStatus(button: self.BTCButton)
    }
    func setSelectedStatus(button: UIButton) {
        button.backgroundColor = JXBlueColor
        button.setTitleColor(JXFfffffColor, for: .normal)
        button.isSelected = true
    }
    func setUnselectedStatus(button: UIButton) {
        button.backgroundColor = JXFfffffColor
        button.setTitleColor(JXGrayTextColor, for: .normal)
        button.isSelected = false
    }
    @IBAction func allAction(_ sender: Any) {
       
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        
    }
}
