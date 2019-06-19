//
//  VIPPropertyViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation
import MJRefresh

private let reuseIdentifier = "reuseIdentifier"
private let reuseIndentifierHeader = "reuseIndentifierHeader"
//
private let headViewHeight : CGFloat = 162 + 20 + 50 + 24 + 40 + 30 + 10 + 44

class VIPPropertyViewController: VIPTableViewController {
    
    //
    var vm: VIPPropertyVM?
    //
    var financialVM = VIPFinancialVM()
    var entity : VIPCoinPropertyEntity!
    
    lazy var scrollView: UIScrollView = {
        let s = UIScrollView(frame: CGRect(x: 0, y: kNavStatusHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight ))
        s.delegate = self
        //s.scrollIndicatorInsets = UIEdgeInsets.init(top: headViewHeight, left: 0, bottom: 0, right: 0)
        s.contentSize = CGSize(width: kScreenWidth, height: kScreenHeight - kNavStatusHeight)
        //s.contentSize = CGSize(width: kScreenWidth, height: kScreenHeight - kNavStatusHeight + (headViewHeight - 44 - 35))
        s.bounces = false
        s.isScrollEnabled = false
        return s
    }()
    
    lazy var headView: UIView = {
        let headView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: headViewHeight))
        headView.backgroundColor = JXFfffffColor
        //资产相关
        let topView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 162))
        topView.backgroundColor = JXEeeeeeColor
        headView.addSubview(topView)
        
//        let leftLabel = UILabel(frame: CGRect(x: 30, y: 30, width: 64, height: 30))
//        leftLabel.textColor = JXBlackTextColor
//        leftLabel.font = UIFont.systemFont(ofSize: 24)
//        leftLabel.textAlignment = .left
//        topView.addSubview(leftLabel)
//        leftLabel.center = CGPoint(x: leftLabel.center.x, y: topView.jxHeight / 2)
        
        let iconImageView = UIImageView(frame: CGRect(x: 0, y: 20, width: 50, height: 50))
        topView.addSubview(iconImageView)
        iconImageView.center = CGPoint(x: topView.center.x, y: iconImageView.center.y)
        
        
        let centerLabel1 = UILabel(frame: CGRect(x: 30, y: iconImageView.jxBottom + 20, width: 260, height: 30))
        centerLabel1.textColor = JXBlackTextColor
        centerLabel1.font = UIFont.systemFont(ofSize: 24)
        centerLabel1.textAlignment = .center
        topView.addSubview(centerLabel1)
        centerLabel1.center = CGPoint(x: topView.center.x, y: centerLabel1.center.y)
        
        let centerLabel2 = UILabel(frame: CGRect(x: 30, y: centerLabel1.jxBottom + 2, width: 260, height: 20))
        centerLabel2.textColor = JXGrayTextColor
        centerLabel2.font = UIFont.systemFont(ofSize: 14)
        centerLabel2.textAlignment = .center
        topView.addSubview(centerLabel2)
        centerLabel2.center = CGPoint(x: topView.center.x, y: centerLabel2.center.y)
        
        self.iconImageView = iconImageView
        self.coinNumLabel = centerLabel1
        self.coinValueLabel = centerLabel2
        
        //地址相关
        let textFieldBgView = UIView(frame: CGRect(x: 30, y: topView.jxBottom + 15, width: headView.jxWidth - 30 * 2, height: 50))
        textFieldBgView.backgroundColor = JXEeeeeeColor
        headView.addSubview(textFieldBgView)
        
        let addressLabel = UILabel(frame: CGRect(x: 15, y: 5, width: textFieldBgView.jxWidth - 15 - 44, height: 40))
        addressLabel.textColor = JXBlackTextColor
        addressLabel.font = UIFont.systemFont(ofSize: 12)
        addressLabel.textAlignment = .left
        addressLabel.numberOfLines = 0
        textFieldBgView.addSubview(addressLabel)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: addressLabel.jxRight, y: 5, width: 44, height: 40)
        button.setImage(UIImage(named: "copy"), for: .normal)
        
        button.addTarget(self, action: #selector(copyAddress), for: .touchUpInside)
        
        textFieldBgView.addSubview(button)
        
        self.addressLabel = addressLabel
        
        let space = (kScreenWidth - 30 - 90 * 3) / 2
        let names = [ LocalizedString(key: "Transfer"),LocalizedString(key: "Receip"),LocalizedString(key: "Exchange")]
        let icons = ["transfer","receip","exchange"]
        for i in 0..<3 {
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 15 + (space + 90) * CGFloat(i), y: textFieldBgView.jxBottom + 30, width: 90, height: 40)
            //button.setImage(UIImage(named: icons[i]), for: .normal)
            button.setTitle(names[i], for: .normal)
            button.setTitleColor(JXFfffffColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            //button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2.5, bottom: 0, right: 2.5)
            //button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2.5, bottom: 0, right: -2.5)
            button.tag = i
            button.addTarget(self, action: #selector(action(button:)), for: .touchUpInside)
            if i == 0 {
                button.backgroundColor = JXBlueColor
            } else if i == 1 {
                button.backgroundColor = JXGreenColor
            } else {
                button.backgroundColor = JXCyanColor
                button.setTitleColor(JXBlueColor, for: .normal)
            }
            headView.addSubview(button)
        }
        
        //地址相关
        let tabBgView = UIView(frame: CGRect(x: 0, y: textFieldBgView.jxBottom + 30 + 70, width: headView.jxWidth, height: 54))
        tabBgView.backgroundColor = JXEeeeeeColor
        headView.addSubview(tabBgView)
        
        let topBar = JXXBarView.init(frame: CGRect.init(x: 0, y: 10, width: view.bounds.width , height: 44), titles: [LocalizedString(key: "Whole"),LocalizedString(key: "Transfer"),LocalizedString(key: "Receip"),LocalizedString(key: "Finance"),LocalizedString(key: "Exchange")])
        topBar.delegate = self

        
        let att = JXAttribute()
        att.normalColor = JXBlackTextColor
        att.selectedColor = JXBlueColor
        if LanaguageManager.shared.type == .english {
            att.font = UIFont.systemFont(ofSize: 15)
        } else {
            att.font = UIFont.systemFont(ofSize: 17)
        }
        
        topBar.attribute = att
        
        topBar.backgroundColor = JXFfffffColor
        topBar.bottomLineSize = CGSize(width: 36, height: 4)
        topBar.bottomLineView.backgroundColor = JXMainColor
        topBar.isBottomLineEnabled = true
        
        tabBgView.addSubview(topBar)
        
        self.topBar = topBar
        
        return headView
    }()
    
    var iconImageView : UIImageView!
    var coinNumLabel : UILabel!
    var coinValueLabel : UILabel!
    
    var addressLabel : UILabel!
    
    var topBar : JXXBarView!
    var horizontalView : JXHorizontalView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //self.view.addSubview(self.headView)
       
        let rect = CGRect(x: 0, y: headViewHeight, width: kScreenWidth, height: kScreenHeight - kNavStatusHeight - headViewHeight)
        let vc1 = VIPProRecordsContorller()
        vc1.type = 0
        vc1.entity = self.entity
        vc1.refreshBlock = { vm in
            self.updateValues(vm)
        }
        vc1.scrollViewDidScrollBlock = { scroll in
            self.tableViewDidScroll(scrollView: scroll)
        }
        let vc2 = VIPProRecordsContorller()
        vc2.type = 1
        vc2.entity = self.entity
        vc2.refreshBlock = { vm in
            self.updateValues(vm)
        }
        vc2.scrollViewDidScrollBlock = { scroll in
            self.tableViewDidScroll(scrollView: scroll)
        }
        let vc3 = VIPProRecordsContorller()
        vc3.type = 2
        vc3.entity = self.entity
        vc3.refreshBlock = { vm in
            self.updateValues(vm)
        }
        vc3.scrollViewDidScrollBlock = { scroll in
            self.tableViewDidScroll(scrollView: scroll)
        }
        let vc4 = VIPProRecordsContorller()
        vc4.type = 3
        vc4.entity = self.entity
        vc4.refreshBlock = { vm in
            self.updateValues(vm)
        }
        vc4.scrollViewDidScrollBlock = { scroll in
            self.tableViewDidScroll(scrollView: scroll)
        }
        let vc5 = VIPProRecordsContorller()
        vc5.type = 4
        vc5.entity = self.entity
        vc5.refreshBlock = { vm in
            self.updateValues(vm)
        }
        vc5.scrollViewDidScrollBlock = { scroll in
            self.tableViewDidScroll(scrollView: scroll)
        }
        
        let horizontalView = JXHorizontalView.init(frame: rect, containers: [vc1,vc2,vc3,vc4,vc5], parentViewController: self)
        self.view.addSubview(horizontalView)
        self.horizontalView = horizontalView
        
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.headView)
        self.scrollView.addSubview(horizontalView)

        
        //设置默认值，真实数据以钱包结果为准
        if let s = self.entity.icon, let url = URL(string: kBaseUrl + s) {
            self.iconImageView.setImageWith(url, placeholderImage: UIImage(named: "coin"))
        }
        self.coinNumLabel.text = "\(self.entity.available_qty)"
        self.coinValueLabel.text = "$\(self.entity.available_qty * self.entity.price)"
        self.addressLabel.text = self.entity.address
    }
    func updateValues(_ vm: VIPPropertyVM) {
        self.vm = vm
        if let s = self.entity.icon, let url = URL(string: kBaseUrl + s) {
            self.iconImageView.setImageWith(url, placeholderImage: UIImage(named: "coin"))
        }
        self.coinNumLabel.text = String(format: "%.8f", vm.propertyEntity.walletEntity?.available_qty ?? 0)
        if let num = vm.propertyEntity.walletEntity?.available_qty, let prise = vm.propertyEntity.coinEntity?.price {
            self.coinValueLabel.text = String(format: "$%.2f", num * prise)
        }
        self.addressLabel.text = vm.propertyEntity.coinEntity?.deposit_address
    }
    override func requestData() {
        self.financialVM.walletList { (_, msg, isSuc) in
            
        }
    }
    @objc func copyAddress() {
        let pals = UIPasteboard.general
        pals.string = self.addressLabel.text
        ViewManager.showNotice(LocalizedString(key: "Copied"))
    }
    @objc func action(button: UIButton) {
       
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if button.tag == 0 {
            let vc = storyboard.instantiateViewController(withIdentifier: "transfer") as! VIPTransferViewController
            vc.entity = self.vm?.propertyEntity
            vc.backBlock = {
                self.tableView.mj_header.beginRefreshing()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        } else if button.tag == 1 {
            let vc = storyboard.instantiateViewController(withIdentifier: "receipt") as! VIPReceiptViewController
            vc.receiptStr = self.addressLabel.text ?? ""
            vc.tokenName = self.entity.short_name ?? ""
            vc.tokenIcon = self.entity.icon
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            if self.financialVM.walletListEntity.list.count > 0 {
                self.showAlert(entity: self.financialVM.walletListEntity)
            } else {
                self.showMBProgressHUD()
                self.financialVM.walletList { (_, msg, isSuc) in
                    self.hideMBProgressHUD()
                    self.showAlert(entity: self.financialVM.walletListEntity)
                }
            }
        }

    }
    func showAlert(entity: VIPWalletListEntity) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "exchange") as! VIPExchangeViewController
        vc.walletListEntity = entity
        vc.backBlock = {
            self.financialVM.walletListEntity.list.removeAll()
            self.financialVM.walletList { (_, msg, isSuc) in
                
            }
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
//MARK:UIScrollViewDelegate
extension VIPPropertyViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print(scrollView.contentOffset)
        let offsetY = self.scrollView.contentOffset.y
        if (offsetY <= 0.0) {
            var frame = self.headView.frame
            frame.origin.y = offsetY

//            var tFrame = self.tableView.frame
//            tFrame.origin.y = offsetY + headViewHeight
//            self.tableView.frame = tFrame
//            if !self.tableView.mj_header.isRefreshing {
//                self.tableView.contentOffset = CGPoint(x: 0, y: offsetY)
//            }
        }
    }
}
//MARK:JXBarViewDelegate
extension VIPPropertyViewController : JXXBarViewDelegate {
    
    func jxxBarView(barView: JXXBarView, didClick index: Int) {
        
        let indexPath = IndexPath.init(item: index, section: 0)
        //开启动画会影响topBar的点击移动动画
        self.horizontalView.containerView.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.left, animated: false)
    }
}
//MARK:JXHorizontalViewDelegate
extension VIPPropertyViewController : JXHorizontalViewDelegate {
    func horizontalViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        var x : CGFloat
        let count = CGFloat(self.topBar.titles.count)
        
        x = (kScreenWidth / count  - self.topBar.bottomLineSize.width) / 2 + (offset / kScreenWidth ) * ((kScreenWidth / count))
        
        self.topBar.bottomLineView.frame.origin.x = x
        
    }
    func horizontalView(_: JXHorizontalView, to indexPath: IndexPath) {
        if self.topBar.selectedIndex == indexPath.item {
            return
        }
        
        self.topBar.scrollToItem(at: indexPath)
    }
    
}
//vc1 tableView
extension VIPPropertyViewController {
    func tableViewDidScroll(scrollView: UIScrollView) {
        
        //print("table", scrollView.contentOffset)
        
        let offsetY = scrollView.contentOffset.y
        if (offsetY <= (headViewHeight - 45) && offsetY >= 0) {
            
            //self.scrollView.contentOffset = scrollView.contentOffset
        }
    }
}
