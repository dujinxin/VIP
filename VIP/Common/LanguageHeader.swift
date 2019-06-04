//
//  LanguageHeader.swift
//  VIP
//
//  Created by 飞亦 on 5/29/19.
//  Copyright © 2019 飞亦. All rights reserved.
//

import UIKit

enum LanguageType : String{
    case chinese = "zh-Hans"
    case english = "en"
}

var charBundle : Int8 = 0


func LocalizedString(key: String?) -> String {
    return NSLocalizedString(key ?? "", comment: "")
}

class LanaguageManager: NSObject {
    
    static let shared = LanaguageManager()
    
    var languageStr : String = "en"
    
    override init() {
        super.init()
        
        if let language = UserDefaults.standard.object(forKey: "myLanguage") as? String, language.isEmpty == false {
            if language == LanguageType.chinese.rawValue {
                languageStr = "zh"
            } else if language == LanguageType.english.rawValue {
                languageStr = "en"
            }
            Bundle.main.setLanguage(language)
        }
    }
    
    func changeLanguage(_ key: LanguageType) {
        UserDefaults.standard.set(key.rawValue, forKey: "myLanguage")
        UserDefaults.standard.synchronize()
        
        if key == .chinese {
            languageStr = "zh"
        } else if key == .english {
            languageStr = "en"
        }
        
        Bundle.main.setLanguage(key.rawValue)
        
        let mainSb = UIStoryboard(name: "Main", bundle: nil)
        let rootViewC = mainSb.instantiateInitialViewController() as! VIPTabBarViewController
        rootViewC.selectedIndex = 3  //回到设置页面
        UIApplication.shared.delegate!.window!!.rootViewController = rootViewC
    }
}




class LocalizedBundle : Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = self.getCurrentBundle() {
            
            return bundle.localizedString(forKey: key, value: value, table: tableName)
        } else {
          
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
//        if let bundle = objc_getAssociatedObject(self, &charBundle) as? Bundle {
//            return bundle.localizedString(forKey: key, value: value, table: tableName)
//        } else {
//            return super.localizedString(forKey: key, value: value, table: tableName)
//        }
    }
}

extension Bundle {
    func getCurrentLanguage() -> String {
        if let language = UserDefaults.standard.object(forKey: "myLanguage") as? String, language.isEmpty == false {
            Bundle.main.setLanguage(language)
            return language
        } else {
            if let languageArr = UserDefaults.standard.object(forKey: "AppleLanguages") as? Array<String>, languageArr.isEmpty == false {
                return languageArr[0]
            }
        }
        return "en"
    }
    func getCurrentBundle() -> Bundle? {
        guard
            let languageBundlePath = Bundle.main.path(forResource: self.getCurrentLanguage(), ofType: "lproj"),
            let languageBundle = Bundle.init(path: languageBundlePath) else {
              
            return nil
        }
    
        return languageBundle
    }
    func setLanguage(_ key: String) {
        DispatchQueue.once {
            object_setClass(Bundle.main, LocalizedBundle.self)
        }
        
//        objc_setAssociatedObject(Bundle.main, &charBundle, Bundle.main.path(forResource: key, ofType: "lproj"), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
//
//        print(Bundle.main.path(forResource: key, ofType: "lproj"))
    }
}
extension DispatchQueue {
    private static var _onceTracker = [String]()
    
    public class func once(file: String = #file, function: String = #function, line: Int = #line, block: ()->Void) {
        let token = file + ":" + function + ":" + String(line)
        once(token: token, block: block)
    }

    public class func once(token: String, block: ()->Void) {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        
        
        if _onceTracker.contains(token) {
            return
        }
        
        _onceTracker.append(token)
        block()
    }
}
