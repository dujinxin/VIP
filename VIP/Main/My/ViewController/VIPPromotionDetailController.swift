//
//  VIPPromotionDetailController.swift
//  VIP
//
//  Created by 飞亦 on 6/15/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPPromotionDetailController: VIPBaseViewController {

    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!{
        
        didSet{
            let gradientLayer = CAGradientLayer.init()
            gradientLayer.colors = [UIColor.rgbColor(rgbValue: 0x2179CD).cgColor,UIColor.rgbColor(rgbValue: 0xB9DBF0).cgColor]
            gradientLayer.locations = [0]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0, y: 1)
            gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight)
            self.contentView.layer.insertSublayer(gradientLayer, at: 0)
        }
    }
    
    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!{
        didSet{
            self.topHeightConstraint.constant = kNavStatusHeight
        }
    }
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var codeImageView: UIImageView!
 
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    
    var inviteUrl : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        //self.titleLabel.text = LocalizedString(key: "Promotion")
        
        self.codeImageView.image = self.code(self.inviteUrl)
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func saveImageAction(_ sender: Any) {
        guard let image = self.codeImageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
    }
    @IBAction func copyCodeAction(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = inviteUrl
        ViewManager.showNotice(LocalizedString(key: "Copied"))
        
    }
    @objc func image(image:UIImage,didFinishSavingWithError error:Error?,contextInfo:AnyObject?) {
        if error != nil {
            ViewManager.showNotice(LocalizedString(key: "SaveFailed"))
        } else {
            ViewManager.showNotice(LocalizedString(key: "Saved"))
        }
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
