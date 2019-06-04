//
//  VIPExchangeViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

class VIPExchangeViewController: VIPBaseViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight
        }
    }
    @IBOutlet weak var fromBalanceLabel: UILabel!{
        didSet{
            self.fromBalanceLabel.textColor = JXRedColor
        }
    }
    @IBOutlet weak var toBalanceLabel: UILabel!{
        didSet{
            self.toBalanceLabel.textColor = JXGreenColor
        }
    }
    @IBOutlet weak var fromCoinLabel: UILabel!
    @IBOutlet weak var toCoinLabel: UILabel!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var totalNumLabel: UILabel!
    
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var coinNumLabel: UILabel!
    
    @IBOutlet weak var allButton: UIButton!{
        didSet{
            self.allButton.layer.borderColor = JXGrayTextColor.cgColor
            self.allButton.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var exchangeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: ({ () -> UIButton in
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 88, height: 30))
            //button.backgroundColor = UIColor.lightGray
            button.setTitle("兑换记录", for: .normal)
            button.setImage(UIImage(named: "copy"), for: .normal)
            button.setTitleColor(JXBlueColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            //button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2.5, bottom: 0, right: 2.5)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
            button.layer.cornerRadius = 4
            button.addTarget(self, action: #selector(record(button:)), for: .touchUpInside)
            return button
            }()))
    }
    
    @objc func record(button: UIButton) {
        let vc = VIPExRecordsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    func sdsdsd() {
        let l = UIViewController()
        l.modalPresentationStyle = .currentContext
    }

}
