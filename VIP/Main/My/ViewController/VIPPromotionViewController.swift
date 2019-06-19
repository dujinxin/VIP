//
//  VIPPromotionViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation
import MJRefresh

class VIPPromotionViewController: VIPBaseViewController {
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight
        }
    }
    
    @IBOutlet weak var codeImageView: UIImageView!

    @IBOutlet weak var inviteNumLabel: UILabel!
    @IBOutlet weak var validAccountLabel: UILabel!
    @IBOutlet weak var personalPerformanceLabel: UILabel!
    @IBOutlet weak var sharePerformanceNumLabel: UILabel!
    @IBOutlet weak var inviteCodeLabel: UILabel!
    
    @IBOutlet weak var copyButton: UIButton!
    
    var entity : VIPPromotionModel!
    var vm = VIPPromotionVM()
    
    
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func requestData() {
        self.vm.promotion { (_, msg, isSuc) in
            self.mainScrollView.mj_header.endRefreshing()
            if isSuc {
                self.entity = self.vm.promotionEntity
                self.updateValues()
            } else {
                ViewManager.showNotice(msg)
            }
        }
    }
    func updateValues() {
        self.inviteNumLabel.text = "\(self.entity.invent_counts)"
        self.validAccountLabel.text = "\(self.entity.valid_count)"
        self.personalPerformanceLabel.text = "\(self.entity.user_price)"
        self.sharePerformanceNumLabel.text = "\(self.entity.team_price)"
        self.inviteCodeLabel.text = self.entity.invitation_code
        
        self.codeImageView.image = self.code(self.entity.invent_url ?? "")
    }
    @IBAction func copyCodeAction(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.inviteCodeLabel.text
        ViewManager.showNotice(LocalizedString(key: "Copied"))
    }
    @IBAction func copyUrlAction(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.entity.invent_url
        ViewManager.showNotice(LocalizedString(key: "Copied"))
       
    }
    func code(_ string:String) -> UIImage {
        //二维码滤镜
        let filter = CIFilter.init(name: "CIQRCodeGenerator")
        //设置滤镜默认属性
        filter?.setDefaults()
        
        let data = string.data(using: .utf8)
        
        //设置内容
        filter?.setValue(data, forKey: "inputMessage")
        //设置纠错级别
        filter?.setValue("M", forKey: "inputCorrectionLevel")
        //获取滤镜输出图像
        guard let outImage = filter?.outputImage else{
            return UIImage()
        }
        //转换CIIamge为UIImage,并放大显示
        guard let image = self.createNonInterpolatedUIImage(outImage, size: CGSize(width: 200, height: 200)) else {
            return UIImage()
        }
        return image
    }
    func createNonInterpolatedUIImage(_ ciImage : CIImage,size:CGSize) -> UIImage? {
        let a = size.height
        
        let extent = ciImage.extent.integral
        let scale = min(a / extent.size.width, a / extent.size.height)
        //创建bitmap
        let width = extent.width * scale
        let height = extent.height * scale
        
        let cs = CGColorSpaceCreateDeviceGray()
        guard let bitmapRef = CGContext.init(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: cs, bitmapInfo: CGImageAlphaInfo.none.rawValue) else {
            return nil
        }
        let context = CIContext.init()
        guard let bitmapImage = context.createCGImage(ciImage, from: extent) else {
            return nil
        }
        bitmapRef.interpolationQuality = .none
        bitmapRef.scaleBy(x: scale, y: scale)
        bitmapRef.draw(bitmapImage, in: extent)
        //保存bitmap到图片
        guard let scaledImage = bitmapRef.makeImage() else {
            return nil
        }
        let image = UIImage.init(cgImage: scaledImage)
        return image
    }
}
