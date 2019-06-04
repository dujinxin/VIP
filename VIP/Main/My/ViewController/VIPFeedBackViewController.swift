//
//  VIPFeedBackViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

class VIPFeedBackViewController: VIPBaseViewController {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight + 10
        }
    }
    
    @IBOutlet weak var textView: JXPlaceHolderTextView!{
        didSet{
            self.textView.backgroundColor = UIColor.clear
            self.textView.placeHolderText = "请填写您的宝贵建议！"
        }
    }
    @IBOutlet weak var submitButton: UIButton!{
        didSet{
            self.submitButton.isEnabled = false
            self.submitButton.backgroundColor = JXlightBlueColor
        }
    }
    
    var vm = VIPFeedBackVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = JXFfffffColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(placeHolderTextChange(nofiy:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
    @IBAction func action(_ sender: Any) {
        print(self.textView.text)
        self.showMBProgressHUD()
        self.vm.feedback(text: self.textView.text) { (_, msg, isSuc) in
            self.hideMBProgressHUD()
            ViewManager.showNotice(msg)
            if isSuc {
                self.navigationController?.popViewController(animated: true)
            }
            ViewManager.showNotice(msg)
        }
    }

}
extension VIPFeedBackViewController : UITextViewDelegate,UITextFieldDelegate{
    
    //MARK:UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        //限制字数不可以限制回车，删除键，所以要优先响应，然后再限制
        //删除键
        if text == "" {
            return true
        }
        //return键 收键盘
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        //限制输入字符数
        if let string = textView.text, string.count >= 200 {
            textView.text = String(string.prefix(upTo: string.index(string.startIndex, offsetBy: 200)))
            //textView.text = string.substring(to: string.index(string.startIndex, offsetBy: 500))
            ViewManager.showNotice("字符个数不能大于\(200)")
            return false
        }
        return true
    }
    
    /// 添加通知，是为了确保用户修改值时placeHolder正常显示
    @objc func placeHolderTextChange(nofiy:Notification) {
        
        if self.textView.text.isEmpty == true {
            self.submitButton.isEnabled = false
            self.submitButton.backgroundColor = JXlightBlueColor
        }else{
            self.submitButton.isEnabled = true
            self.submitButton.backgroundColor = JXMainColor
        }
    }
}
