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
            self.financialBgView.backgroundColor = JXCyanColor
            self.financialBgView.layer.cornerRadius = 4
            self.financialBgView.tag = 100
            self.financialBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
        }
    }
    @IBOutlet weak var superNodeBgView: UIView!{
        didSet{
            self.superNodeBgView.backgroundColor = JXCyanColor
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
            
            self.ethBgView.tag = 7
            self.ethBgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
        }
    }
    
    
    var financialBlock : (()->())?
    var developBlock : (()->())?
    
    var bannerBlock : ((_ index: Int)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        var width : CGFloat = kScreenWidth - 30
        let s = UIScrollView(frame: CGRect(x: 0, y: 0, width: width, height: 120))
        self.scrollContentView.addSubview(s)
        
        let titles = ["Netnote","外汇","基金","保险","证券"]
        for i in 0..<5 {
            let iv = UIImageView(frame: CGRect(x: i * (15 + 69), y: 0, width: 69, height: 69))
            iv.image = UIImage(named: "\(i + 1)")
            iv.tag = i
            iv.isUserInteractionEnabled = true
            iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(tap:))))
            s.addSubview(iv)
            if i == 4 {
                width = iv.jxRight
            }
            
            let l = UILabel(frame: CGRect(x: i * (15 + 69), y: Int(iv.jxBottom + 10), width: 69, height: 20))
            l.text = titles[i]
            l.textColor = JXBlueColor
            l.textAlignment = .center
            l.font = UIFont.systemFont(ofSize: 14)
            s.addSubview(l)
        }
        
        width = width > (kScreenWidth - 30) ? width : kScreenWidth - 30
        s.contentSize = CGSize(width: width, height: 120)
        //self.widthConstraint.constant = width
        
        print(width)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @objc func tap(tap: UITapGestureRecognizer) {
        if let v = tap.view, v.tag == 100 {
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
        //ViewManager.showNotice("待开发中，敬请期待")
        if let block = self.bannerBlock {
            block(index)
        }
    }
}
