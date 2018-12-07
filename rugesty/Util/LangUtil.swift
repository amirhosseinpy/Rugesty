//
//  LangUtil.swift
//  Rugesty
//
//  Created by amirhosseinpy on 9/15/1397 AP.
//  Copyright © 1397 amirhosseinpy. All rights reserved.
//

import UIKit

class FPLangUtil: NSObject {
    
    static var lang = "Base"
    
    static func changeLanguage(newLang: String) {
        UserDefaults.standard.setValue(newLang, forKey: "selectedLanguage")
        UserDefaults.standard.synchronize()
        
        lang = newLang
    }
    
    static func loadLanguage() {
        let targetLang = UserDefaults.standard.object(forKey: "selectedLanguage") as? String
        lang = targetLang ?? "Base"
    }
}
