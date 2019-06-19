//
//  VIPReceiptViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPReceiptViewController: VIPBaseViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight + 20
        }
    }
    @IBOutlet weak var iconImageView: UIImageView!{
        didSet{
            
        }
    }
    @IBOutlet weak var codeImageBgView: UIView!{
        didSet{
            codeImageBgView.backgroundColor = JXViewBgColor
        }
    }
    @IBOutlet weak var codeImageView: UIImageView!{
        didSet{
            
        }
    }
    
    @IBOutlet weak var addressBgView: UIView!{
        didSet{
            addressBgView.backgroundColor = JXViewBgColor
        }
    }
    @IBOutlet weak var addressLabel: UILabel!{
        didSet{
            addressLabel.textColor = JXBlueColor
        }
    }
    @IBOutlet weak var copyButton: UIButton!
  
    @IBOutlet weak var saveButton: UIButton!{
        didSet {
            self.saveButton.backgroundColor = JXCyanColor
            self.saveButton.setTitleColor(JXBlueColor, for: .normal)
        }
    }
    
    @IBOutlet weak var noticeLabel: UILabel!{
        didSet{
            noticeLabel.textColor = JXGrayTextColor
        }
    }
 
    var contractAddress : String = ""
    var tokenName : String = "ETH"
    var tokenIcon : String?
    var receiptStr = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.title = LocalizedString(key: "Receip")
 
        if let s = self.tokenIcon, let url = URL(string: kBaseUrl + s) {
            self.iconImageView.setImageWith(url, placeholderImage: UIImage(named: "coin"))
        }
        
        
        self.addressLabel.text = self.receiptStr
        
        if LanaguageManager.shared.type == .chinese {
            self.noticeLabel.text = "注意：该地址仅支持\(self.tokenName)收款，请勿用于其他币种！"
        } else {
            self.noticeLabel.text = "Note: This address only supports \(self.tokenName) receivables, please do not use it in other currencies!"
        }
        self.codeImageView.image = self.code(self.receiptStr)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func copyAddress(_ sender: Any) {
        let pals = UIPasteboard.general
        pals.string = self.addressLabel.text
        ViewManager.showNotice(LocalizedString(key: "Copied"))
    }
   
    @IBAction func saveImage(_ sender: Any) {
        guard let image = self.codeImageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(image:didFinishSavingWithError:contextInfo:)), nil)
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
        guard let image = self.createNonInterpolatedUIImage(outImage, size: CGSize(width: kScreenWidth - 50 * 2, height: kScreenWidth - 50 * 2)) else {
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
