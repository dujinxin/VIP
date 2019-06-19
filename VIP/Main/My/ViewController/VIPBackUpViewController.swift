//
//  VIPBackUpViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPBackUpViewController: VIPBaseViewController {
    
    var unInputMnemonics = [String]()
    var inputMnemonics = [String]()
    
    var isRegister : Int = 0 // 0否，其他 是
    
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            topConstraint.constant = kNavStatusHeight + 20
        }
    }
    @IBOutlet weak var mnemonicsViewLeadingConstraint: NSLayoutConstraint!{
        didSet{
            mnemonicsViewLeadingConstraint.constant = 20
        }
    }
    
    @IBOutlet weak var textLabel: UILabel!{
        didSet{
            textLabel.textColor = JXGrayTextColor
        }
    }
  
    @IBOutlet weak var mnemonicView: UIView!
    @IBOutlet weak var mnemonicViewHeight: NSLayoutConstraint!
    
    var mnemonicStr = "1 2 34 567 89 00 88 7 6678 ghjk hhgy8ih 8 jbhkj 8998 bhghghkjj"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = JXFfffffColor
        self.title = LocalizedString(key: "My_backupMnemonics")
        
        let titles = mnemonicStr.components(separatedBy: " ")
        print(self.mnemonicView)
        self.unInputMnemonics = titles
        self.mnemonicViewHeight.constant = self.setupMnemonicView(self.mnemonicView, subViewsWithTitles: titles)
    }
    
    func setupMnemonicView(_ mnemonicContentView: UIView, subViewsWithTitles titles: Array<String>) -> CGFloat{
        
        mnemonicContentView.removeAllSubView()
        
        let rangeRect = CGRect(x: 22, y: 0, width: kScreenWidth - mnemonicsViewLeadingConstraint.constant * 2 - 44, height: 65)
        let lineSpace : CGFloat = 10
        let itemSpace : CGFloat = 10
        let itemWidth : CGFloat = 35
        
        
        var frontRect = CGRect()
        
        for i in 0..<titles.count {
            
            let size = self.calculate(text: titles[i], width: rangeRect.width, fontSize: 14, lineSpace: 0)
            var frame = CGRect()
            
            let label = UILabel()
            label.backgroundColor = JXBlueColor
            label.tag = i
            label.text = titles[i]
            label.textColor = JXFfffffColor
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16)
//            label.layer.cornerRadius = 2
//            label.layer.borderColor = JXSeparatorColor.cgColor
//            label.layer.borderWidth = 1
            
            if i == 0 {
                frame = CGRect(x: rangeRect.minX, y: 15, width: size.width, height: itemWidth)
            } else {
                if frontRect.maxX + itemSpace + size.width <= rangeRect.maxX {
                    frame = CGRect(x: frontRect.maxX + itemSpace, y: frontRect.minY, width: size.width, height: itemWidth)
                } else {
                    frame = CGRect(x: rangeRect.minX, y: frontRect.maxY + lineSpace, width: size.width, height: itemWidth)
                }
            }
            
            label.frame = frame
            mnemonicContentView.addSubview(label)
            frontRect = label.frame
            //unInputMnemonics.append(titles[i])
        }
        //var rect = mnemonicContentView.frame
        //rect.size.height = (frontRect.maxY + 15) <= 65 ? 65 : (frontRect.maxY + 15)
        //mnemonicContentView.frame = rect
        return (frontRect.maxY + 15) <= 65 ? 65 : (frontRect.maxY + 15)
    }
    func calculate(text: String, width: CGFloat, fontSize: CGFloat, lineSpace: CGFloat = -1) -> CGSize {
        
        if text.isEmpty {
            return CGSize()
        }
        
        var attributes : Dictionary<NSAttributedString.Key, Any>
        let paragraph = NSMutableParagraphStyle.init()
        paragraph.lineSpacing = lineSpace
        
        if lineSpace < 0 {
            attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)]
        }else{
            attributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize),NSAttributedString.Key.paragraphStyle:paragraph]
        }
        let rect = text.boundingRect(with: CGSize.init(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: attributes, context: nil)
        
        let height : CGFloat
        if rect.origin.x < 0 {
            height = abs(rect.origin.x) + rect.height
        }else{
            height = rect.height
        }
        
        return CGSize(width: rect.width + 20, height: height)
    }
   
    @IBAction func remembered(_ sender: Any) {

        if isRegister == 0 {
            self.navigationController?.popViewController(animated: true)
        } else {
            if let controllers = self.navigationController?.viewControllers {
                if controllers.count > 1 {
                    self.navigationController?.viewControllers.remove(at: 0)
                }
            }
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "login") as! VIPLoginViewController
            self.navigationController?.pushViewController(login, animated: true)
        }
    }
    @IBAction func remembering(_ sender: Any) {
        if isRegister == 0 {
            self.navigationController?.popViewController(animated: true)
        } else {
            if let controllers = self.navigationController?.viewControllers {
                if controllers.count > 1 {
                    self.navigationController?.viewControllers.remove(at: 0)
                }
            }
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let login = storyboard.instantiateViewController(withIdentifier: "login") as! VIPLoginViewController
            self.navigationController?.pushViewController(login, animated: true)
        }
    }
    
}
