//
//  VIPIncomeViewController.swift
//  VIP
//
//  Created by 飞亦 on 6/12/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPIncomeViewController: VIPBaseViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight + 10
        }
    }
    
    @IBOutlet weak var todayIncomeNumLabel: UILabel!
    @IBOutlet weak var historyIncomeNumLabel: UILabel!
    
    @IBOutlet weak var todayFinancialIncomeNumLabel: UILabel!
    @IBOutlet weak var historyFinancialIncomeNumLabel: UILabel!
    
    @IBOutlet weak var todayShareIncomeNumLabel: UILabel!
    @IBOutlet weak var historyShareIncomeNumLabel: UILabel!
    
    @IBOutlet weak var todayCommunityIncomeNumLabel: UILabel!
    @IBOutlet weak var historyCommunityIncomeNumLabel: UILabel!
    
    @IBOutlet weak var todayNormalIncomeNumLabel: UILabel!
    @IBOutlet weak var historyNormalIncomeNumLabel: UILabel!
    
    @IBOutlet weak var todayIncomeBgView: UIView!{
        didSet{
            self.todayIncomeBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        }
    }
    @IBOutlet weak var historyIncomeBgView: UIView!{
        didSet{
            self.historyIncomeBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        }
    }
    
    @IBOutlet weak var todayFinancialIncomeBgView: UIView!{
        didSet{
            self.todayFinancialIncomeBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        }
    }
    @IBOutlet weak var historyFinancialIncomeBgView: UIView!{
        didSet{
            self.historyFinancialIncomeBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        }
    }
    @IBOutlet weak var todayShareIncomeBgView: UIView!{
        didSet{
            self.todayShareIncomeBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        }
    }
    @IBOutlet weak var historyShareIncomeBgView: UIView!{
        didSet{
            self.historyShareIncomeBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        }
    }
    @IBOutlet weak var todayCommunityIncomeBgView: UIView!{
        didSet{
            self.todayCommunityIncomeBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        }
    }
    @IBOutlet weak var historyCommunityIncomeBgView: UIView!{
        didSet{
            self.historyCommunityIncomeBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        }
    }
    @IBOutlet weak var todayNormalIncomeBgView: UIView!{
        didSet{
            self.todayNormalIncomeBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        }
    }
    @IBOutlet weak var historyNormalIncomeBgView: UIView!{
        didSet{
            self.historyNormalIncomeBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        }
    }
    
    
    var entity : VIPIncomeModel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.todayIncomeNumLabel.text = "\(self.entity.today_profit_price)"
        self.historyIncomeNumLabel.text = "\(self.entity.profit_price - self.entity.today_profit_price)"
        self.todayFinancialIncomeNumLabel.text = "\(self.entity.today_conduct_price)"
        self.historyFinancialIncomeNumLabel.text = "\(self.entity.conduct_price - self.entity.today_conduct_price)"
        self.todayShareIncomeNumLabel.text = "\(self.entity.today_share_price)"
        self.historyShareIncomeNumLabel.text = "\(self.entity.share_price - self.entity.today_share_price)"
        self.todayCommunityIncomeNumLabel.text = "\(self.entity.today_team_price)"
        self.historyCommunityIncomeNumLabel.text = "\(self.entity.team_price - self.entity.today_team_price)"
        self.todayNormalIncomeNumLabel.text = "\(self.entity.today_level_price)"
        self.historyNormalIncomeNumLabel.text = "\(self.entity.level_price - self.entity.today_level_price)"
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        let vc = VIPIncomeRecordsController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}
