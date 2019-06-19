//
//  VIPFindHeadCell.swift
//  VIP
//
//  Created by 飞亦 on 6/11/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import SDCycleScrollView

class VIPFindHeadCell: UITableViewCell {

    
    @IBOutlet weak var cycleScrollView: SDCycleScrollView!{
        didSet{
            self.cycleScrollView.delegate = self
            self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated
            self.cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter
            self.cycleScrollView.showPageControl = true
            self.cycleScrollView.currentPageDotColor = JXBlueColor // 自定义分页控件小圆标颜色
            //self.cycleScrollView.placeholderImage = [UIImage imageNamed:@"placeholder"];
            
            //self.cycleScrollView.
            self.cycleScrollView.autoScroll = true
            self.cycleScrollView.autoScrollTimeInterval = 3
            self.cycleScrollView.infiniteLoop = true
            
        }
    }
    @IBOutlet weak var financialBgView: UIView!{
        didSet{
            self.financialBgView.backgroundColor = UIColor.clear
            self.financialBgView.layer.borderColor = UIColor.rgbColor(rgbValue: 0xEBF3F9).cgColor
            self.financialBgView.layer.borderWidth = 1
            self.financialBgView.layer.cornerRadius = 4
            self.financialBgView.tag = 100
            self.financialBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
        }
    }
    @IBOutlet weak var superNodeBgView: UIView!{
        didSet{
            self.superNodeBgView.backgroundColor = UIColor.clear
            self.superNodeBgView.layer.borderColor = UIColor.rgbColor(rgbValue: 0xEBF3F9).cgColor
            self.superNodeBgView.layer.borderWidth = 1
            self.superNodeBgView.layer.cornerRadius = 4
            self.superNodeBgView.tag = 101
            self.superNodeBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var btcBgView: UIView!{
        didSet{
            self.btcBgView.tag = 7
            self.btcBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
        }
    }
    @IBOutlet weak var ethBgView: UIView!{
        didSet{
            
            self.ethBgView.tag = 8
            self.ethBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
        }
    }
    
    
    var financialBlock : (()->())?
    var developBlock : (()->())?
    
    var netnoteBlock : (()->())?
    var foreignExchangeBlock : (()->())?
    var fundBlock : (()->())?
    var insuranceBlock : (()->())?
    var negotiableSecuritiesBlock : (()->())?
    
    var bannerBlock : ((_ index: Int)->())?
    
    var btcBlock : (()->())?
    var ethBlock : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let width : CGFloat = kScreenWidth - 30
        let s = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: 218))
        self.scrollContentView.addSubview(s)
        
        let titles = ["Netnote",LocalizedString(key: "Find_foreignExchange"),LocalizedString(key: "Find_fund"),LocalizedString(key: "Find_insurance"),LocalizedString(key: "Find_negotiableSecurities")]
        let itemSpace  = (width - 4 * 69) / 3
        for i in 0..<5 {
            let iv = UIImageView(frame: CGRect(x: CGFloat(i % 4) * (itemSpace + 69), y: 0 + CGFloat(i / 4) * (40 + 69), width: 69, height: 69))
            iv.image = UIImage(named: "\(i + 1)")
            iv.tag = i
            iv.isUserInteractionEnabled = true
            iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
            s.addSubview(iv)
           
            let l = UILabel(frame: CGRect(x: iv.jxLeft, y: iv.jxBottom + 5, width: 69, height: 30))
            l.text = titles[i]
            l.numberOfLines = 0
            l.textColor = JXBlueColor
            l.textAlignment = .center
            l.font = UIFont.systemFont(ofSize: 14)
            l.adjustsFontSizeToFitWidth = true
            s.addSubview(l)
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func tap(tap: UITapGestureRecognizer) {
        guard let v = tap.view else {
            return
        }
   
        if v.tag == 0 {
            if let block = self.netnoteBlock {
                block()
            }
        } else if v.tag == 1 {
            if let block = self.foreignExchangeBlock {
                block()
            }
        } else if v.tag == 2 {
            if let block = self.fundBlock {
                block()
            }
        } else if v.tag == 3 {
            if let block = self.insuranceBlock {
                block()
            }
        } else if v.tag == 4 {
            if let block = self.negotiableSecuritiesBlock {
                block()
            }
        } else if v.tag == 7 {
            if let block = self.btcBlock {
                block()
            }
        } else if v.tag == 8 {
            if let block = self.ethBlock {
                block()
            }
        } else if v.tag == 100 {
            if let block = self.financialBlock {
                block()
            }
        } else {
            if let block = self.developBlock {
                block()
            }
        }
        
    }
}
extension VIPFindHeadCell: SDCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        print(index)
        
        if let block = self.bannerBlock {
            block(index)
        }
    }
}
