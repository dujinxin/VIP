//
//  VIPExchangeViewController.swift
//  VIP
//
//  Created by 飞亦 on 5/28/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit
import JXFoundation

class VIPExchangeViewController: VIPBaseViewController {
    //MARK: system xib view
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!{
        didSet{
            self.topConstraint.constant = kNavStatusHeight
        }
    }
    @IBOutlet weak var fromBalanceLabel: UILabel!{
        didSet{
            self.fromBalanceLabel.textColor = JXRedColor
        }
    }
    @IBOutlet weak var toBalanceLabel: UILabel!{
        didSet{
            self.toBalanceLabel.textColor = JXGreenColor
        }
    }
    @IBOutlet weak var exchangeImageView: UIImageView!{
        didSet{
            self.exchangeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(exchangeTwo(_:))))
        }
    }
    @IBOutlet weak var fromCoinLabel: UILabel!
    @IBOutlet weak var toCoinLabel: UILabel!
    @IBOutlet weak var fromButton: UIButton!
    @IBOutlet weak var toButton: UIButton!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var totalNumLabel: UILabel!
    
    @IBOutlet weak var numTextField: UITextField!
    @IBOutlet weak var coinNumLabel: UILabel!
    
    @IBOutlet weak var fromNameLabel: UILabel!
    @IBOutlet weak var toNameLabel: UILabel!
    
    @IBOutlet weak var allButton: UIButton!{
        didSet{
            self.allButton.layer.borderColor = JXGrayTextColor.cgColor
            self.allButton.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var exchangeButton: UIButton!{
        didSet{
            self.exchangeButton.isEnabled = false
            self.exchangeButton.backgroundColor = JXlightBlueColor
        }
    }
    //MARK: custom view
    lazy var keyboard: JXKeyboardToolBar = {
        let k = JXKeyboardToolBar(frame: CGRect(), views: [self.numTextField])
        k.showBlock = { (height, rect) in
            print(height,rect)
        }
        k.tintColor = JXGrayTextColor
        k.toolBar.barTintColor = JXViewBgColor
        k.backgroundColor = JXViewBgColor
        k.textFieldDelegate = self
        return k
    }()
    lazy var selectView: JXSelectView = {
        let s = JXSelectView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 216), style: .pick)
        s.backgroundColor = JXFfffffColor
        s.delegate = self
        s.dataSource = self
        s.isUseSystemItemBar = true
        return s
    }()
    //MARK: custom Value
    var walletListEntity : VIPWalletListEntity!
   
    var leftLists = Array<VIPCoinPropertyEntity>()
    var rightLists = Array<VIPCoinPropertyEntity>()
    
    var currentSide : Int = 0 //0左，1右
    var currentLeftEntity : VIPCoinPropertyEntity!
    var currentRightEntity : VIPCoinPropertyEntity!
    
    var vm = VIPPropertyVM()
    
    //MARK: custom methods
    func dataInit() {
        self.leftLists.removeAll()
        self.rightLists.removeAll()
        
        self.walletListEntity.list.forEach { (entity) in
            if entity.currency_type == 3 {
                self.leftLists.append(entity)
            } else {
                self.rightLists.append(entity)
            }
        }
        if self.leftLists.count > 0 && self.rightLists.count > 0 {
            self.setValues(leftEntity: self.leftLists[0], rightEntity: self.rightLists[0])
        }
    }
    func setValues(leftEntity: VIPCoinPropertyEntity, rightEntity: VIPCoinPropertyEntity) {
        
        self.currentLeftEntity = leftEntity
        self.currentRightEntity = rightEntity
        
        self.setLeftValues(leftEntity)
        self.setRightValues(rightEntity)
        self.setOtherValues(leftEntity: leftEntity, rightEntity: rightEntity)
    }
    func setLeftValues(_ entity: VIPCoinPropertyEntity) {
        self.fromBalanceLabel.text = "余额：\(entity.available_qty)"
        self.fromCoinLabel.text = "\(entity.short_name ?? "")"
    }
    func setRightValues(_ entity: VIPCoinPropertyEntity) {
        self.toBalanceLabel.text = "余额：\(entity.available_qty)"
        self.toCoinLabel.text = "\(entity.short_name ?? "")"
    }
    func setOtherValues(leftEntity: VIPCoinPropertyEntity, rightEntity: VIPCoinPropertyEntity) {
        
        let rateStr = String(format: "%.6f", leftEntity.price / rightEntity.price)
        self.rateLabel.text = "1 \(leftEntity.short_name ?? "") ≈ \(rateStr) \(rightEntity.short_name ?? "")"
        self.totalNumLabel.text = "\(leftEntity.available_qty) \(leftEntity.short_name ?? "")"
        self.numTextField.text = "0"
        self.coinNumLabel.text = "0"
        self.fromNameLabel.text = "\(leftEntity.short_name ?? "")"
        self.toNameLabel.text = "\(rightEntity.short_name ?? "")"
        
        self.exchangeButton.isEnabled = false
        self.exchangeButton.backgroundColor = JXlightBlueColor
    }
    @objc func textChange(notify: NSNotification) {
        
        if let textField = notify.object as? UITextField, textField == self.numTextField {
            if
                let text = textField.text, text.isEmpty == false,
                let num = Float(text), num > 0 {
                
                let numStr = String(format: "%.6f", num * self.currentLeftEntity.price / self.currentRightEntity.price)
                self.coinNumLabel.text = numStr
                
                self.exchangeButton.isEnabled = true
                self.exchangeButton.backgroundColor = JXMainColor
                
            } else {
                self.coinNumLabel.text = "0"
                
                self.exchangeButton.isEnabled = false
                self.exchangeButton.backgroundColor = JXlightBlueColor
            }
        }
    }
    //MARK: system methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            self.mainScrollView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        self.customNavigationItem.rightBarButtonItem = UIBarButtonItem(customView: ({ () -> UIButton in
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 88, height: 30))
            //button.backgroundColor = UIColor.lightGray
            button.setTitle("兑换记录", for: .normal)
            button.setImage(UIImage(named: "copy"), for: .normal)
            button.setTitleColor(JXBlueColor, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            //button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2.5, bottom: 0, right: 2.5)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
            button.layer.cornerRadius = 4
            button.addTarget(self, action: #selector(record(button:)), for: .touchUpInside)
            return button
            }()))
        

        NotificationCenter.default.addObserver(self, selector: #selector(textChange(notify:)), name: UITextField.textDidChangeNotification, object: nil)
        
        self.view.addSubview(self.keyboard)
        
        self.dataInit()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func record(button: UIButton) {
        self.view.endEditing(true)
        
        let vc = VIPExRecordsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    //MARK: click actions
    @objc func exchangeTwo(_ sender: Any) {
        let arr = self.leftLists
        self.leftLists = self.rightLists
        self.rightLists = arr
        
        self.setValues(leftEntity: self.currentRightEntity, rightEntity: self.currentLeftEntity)
    }
    @IBAction func selectFrom(_ sender: Any) {
        self.view.endEditing(true)
        
        self.currentSide = 0
        self.selectView.show()
    }
    @IBAction func selectTo(_ sender: Any) {
        self.view.endEditing(true)
        
        self.currentSide = 1
        self.selectView.show()
    }
    @IBAction func allAction(_ sender: Any) {
        self.numTextField.text = "\(self.currentLeftEntity.available_qty)"
        
        if let text = self.numTextField.text, let num = Float(text) {
            let numStr = String(format: "%.6f", num * self.currentLeftEntity.price / self.currentRightEntity.price)
            self.coinNumLabel.text = numStr
        } else {
            self.coinNumLabel.text = "0"
        }
    }
    @IBAction func exchangeAction(_ sender: Any) {
        guard let text = self.numTextField.text, let num = Float(text) else {
            return
        }
        
        let alertVC = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        //键盘的返回键 如果只有一个非cancel action 那么就会触发 这个按钮，如果有多个那么返回键只是单纯的收回键盘
        alertVC.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "请输入交易密码"
        })
        alertVC.addAction(UIAlertAction(title: "确定", style: .destructive, handler: { (action) in
            
            guard
                let textField = alertVC.textFields?[0],
                let psd = textField.text,
                psd.isEmpty == false else {
                    return
            }
            
            
            self.showMBProgressHUD()
            self.vm.propertyExchange(l_currency_id: self.currentLeftEntity.id, l_currency_qty: num, r_currency_id: self.currentRightEntity.id, pay_password: psd, completion: { (_, msg, isSuc) in
                self.hideMBProgressHUD()
                ViewManager.showNotice(msg)
                if isSuc {
                    if let block = self.backBlock {
                        block()
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            })
            
        }))
        alertVC.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
        }))
        
        self.present(alertVC, animated: true, completion: nil)

    }
}
extension VIPExchangeViewController: JXKeyboardTextFieldDelegate {
    func keyboardTextFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func keyboardTextField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}
extension VIPExchangeViewController: JXSelectViewDelegate,JXSelectViewDataSource{
    func jxSelectView(selectView: JXSelectView, didSelectRowAt row: Int, inSection section: Int) {
        print(row)
        
        if currentSide == 0 {
            
            let entity = self.leftLists[row]
            self.setValues(leftEntity: entity, rightEntity: self.currentRightEntity)
        } else {
            let entity = self.rightLists[row]
            self.setValues(leftEntity: self.currentLeftEntity, rightEntity: entity)
        }
    }
    
    func jxSelectView(selectView: JXSelectView, numberOfRowsInSection section: Int) -> Int {
        if currentSide == 0 {
            return leftLists.count
        } else {
            return rightLists.count
        }
    }
    
    func jxSelectView(selectView: JXSelectView, heightForRowAt row: Int) -> CGFloat {
        return 36
    }
    
    func jxSelectView(selectView: JXSelectView, contentForRow row: Int, InSection section: Int) -> String {
        if currentSide == 0 {
            let entity = leftLists[row]
            return entity.short_name ?? ""
        } else {
            let entity = rightLists[row]
            return entity.short_name ?? ""
        }
    }
    
    
}
