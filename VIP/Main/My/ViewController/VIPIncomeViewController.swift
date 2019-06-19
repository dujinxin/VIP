//
//  VIPIncomeViewController.swift
//  VIP
//
//  Created by 飞亦 on 6/12/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import MJRefresh

class VIPIncomeViewController: VIPBaseViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight
        }
    }
    @IBOutlet weak var lineView: UIView!{
        didSet{
            self.lineView.layer.cornerRadius = 1.5
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
    
    @IBOutlet weak var topBgView: UIView!{
        didSet{
            self.topBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
        }
    }
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
    
    
    var entity : VIPIncomeModel!
    var vm = VIPIncomeVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        
        self.updateValues()
        
        self.mainScrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.requestData()
        })
    }
    override func requestData() {
        self.vm.income { (_, msg, isSuc) in
            self.mainScrollView.mj_header.endRefreshing()
            if isSuc {
                self.entity = self.vm.incomeEntity
                self.updateValues()
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
    func updateValues() {
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
class LineView: UIView {
    
    var bottomLineColor : UIColor = JXSeparatorColor
    var bottomLineHeight : CGFloat = 2
    var bottomLineWidth : Float = 6
    var bottomLineSpace : Float = 4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let rect = CGRect(x: 0, y: frame.size.height - self.bottomLineHeight, width: frame.size.width , height: self.bottomLineHeight)
        let shapeLayer = self.drawDashLine(rect: rect, lineWidth: self.bottomLineHeight, lineLength: self.bottomLineWidth, lineSpace: self.bottomLineSpace, lineColor: self.backgroundColor!)
        shapeLayer.opacity = 0.5
        layer.addSublayer(shapeLayer)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let rect = CGRect(x: 0, y: frame.size.height - self.bottomLineHeight, width: frame.size.width , height: self.bottomLineHeight)
        let shapeLayer = self.drawDashLine(rect: rect, lineWidth: self.bottomLineHeight, lineLength: self.bottomLineWidth, lineSpace: self.bottomLineSpace, lineColor: self.backgroundColor!)
        shapeLayer.opacity = 0.5
        layer.addSublayer(shapeLayer)
        self.backgroundColor = UIColor.clear
    }
    
    func drawDashLine(rect: CGRect, lineWidth: CGFloat, lineLength: Float, lineSpace: Float, lineColor :UIColor) -> CAShapeLayer{
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.frame = rect
        shapeLayer.position = CGPoint(x: 0, y: frame.size.height - lineWidth)
        //只要是CALayer这种类型,他的anchorPoint默认都是(0.5,0.5)
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpace)]
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: CGFloat(lineSpace / 2), y: lineWidth / 2))
        path.addLine(to: CGPoint(x: rect.size.width, y: lineWidth / 2))
        shapeLayer.path = path
        
        return shapeLayer
    }
}
