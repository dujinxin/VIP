//
//  VIPLanguageAlertController.swift
//  VIP
//
//  Created by 飞亦 on 6/9/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

class VIPLanguageAlertController: VIPBaseViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var chineseLabel: UILabel!
    @IBOutlet weak var englishLabel: UILabel!
    @IBOutlet weak var koreanLabel: UILabel!
    
    @IBOutlet weak var chineseSelectButton: UIButton!{
        didSet{
            self.chineseSelectButton.setImage(UIImage(named: "accessory"), for: .selected)
            self.chineseSelectButton.setImage(UIImage(named: "unSelected"), for: .normal)
            self.chineseSelectButton.tag = 0
        }
    }
    @IBOutlet weak var englishSelectButton: UIButton!{
        didSet{
            self.englishSelectButton.setImage(UIImage(named: "accessory"), for: .selected)
            self.englishSelectButton.setImage(UIImage(named: "unSelected"), for: .normal)
            self.englishSelectButton.tag = 1
        }
    }
    @IBOutlet weak var koreanSelectButton: UIButton!{
        didSet{
            self.koreanSelectButton.setImage(UIImage(named: "accessory"), for: .selected)
            self.koreanSelectButton.setImage(UIImage(named: "unSelected"), for: .normal)
            self.koreanSelectButton.tag = 2
        }
    }
    @IBOutlet weak var cancelButton: UIButton!{
        didSet{
            self.cancelButton.backgroundColor = JXCyanColor
            self.cancelButton.tag = 0
        }
    }
    
    @IBOutlet weak var confirmButton: UIButton!{
        didSet{
            self.confirmButton.backgroundColor = JXCyanColor
            self.cancelButton.tag = 1
        }
    }
    
    @IBAction func clickAction(_ sender: UIButton){
        sender.isSelected = true
        selectRow = sender.tag
        if sender.tag == 0 {
            self.englishSelectButton.isSelected = false
            self.koreanSelectButton.isSelected = false
        } else if sender.tag == 1 {
            self.chineseSelectButton.isSelected = false
            self.koreanSelectButton.isSelected = false
        } else {
            self.chineseSelectButton.isSelected = false
            self.englishSelectButton.isSelected = false
        }
    }
    @IBAction func cancelAction(_ sender: UIButton){
        if let block = self.switchBlock {
            block(false)
        }
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmAction(_ sender: UIButton){
        if selectRow != originRow {
            if selectRow == 0 {
                LanaguageManager.shared.changeLanguage(.chinese)
            } else if selectRow == 1 {
                LanaguageManager.shared.changeLanguage(.english)
            } else {
                LanaguageManager.shared.changeLanguage(.korean)
            }
        }
        if let block = self.switchBlock {
            block(selectRow != originRow)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    var originRow : Int = 0
    var selectRow : Int = 0
    
    var switchBlock: ((_ isChanged: Bool) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        self.customNavigationBar.removeFromSuperview()
        
        self.titleLabel.text = LocalizedString(key: "My_languageChoice")
        self.chineseLabel.text = LocalizedString(key: "My_chinese")
        self.englishLabel.text = LocalizedString(key: "My_english")
        self.koreanLabel.text = LocalizedString(key: "My_korean")
        self.cancelButton.setTitle(LocalizedString(key: "Cancel"), for: .normal)
        self.confirmButton.setTitle(LocalizedString(key: "OK"), for: .normal)
        
        if LanaguageManager.shared.type == .chinese {
            self.chineseSelectButton.isSelected = true
            originRow = 0
            selectRow = 0
        } else if LanaguageManager.shared.type == .english {
            self.englishSelectButton.isSelected = true
            originRow = 1
            selectRow = 1
        } else {
            self.koreanSelectButton.isSelected = true
            originRow = 2
            selectRow = 2
        }
    }
    override func isCustomNavigationBarUsed() -> Bool {
        return false
    }
}
