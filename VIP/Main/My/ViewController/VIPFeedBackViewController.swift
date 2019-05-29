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
        }
    }
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = JXFfffffColor
        
        self.textView.text = "fgyjhkjilujghvjbkl23hhj4k1jgh24hk14jg1jk4g1j24k1jg4hk1j241k24hgh14khl1j241k24kj14g2kh1j4gk1h42h1k24h1g"
    }
    @IBAction func action(_ sender: Any) {
        print(self.textView.text)
    }

}
