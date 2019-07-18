//
//  Extension.swift
//  test2
//
//  Created by amirhosseinpy on 6/30/1397 AP.
//  Copyright © 1397 amirhosseinpy. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var
    cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            
            // Don't touch the masksToBound property if a shadow is needed in addition to the cornerRadius
            if layer.shadowOpacity <= 0.0 {
                self.layer.masksToBounds = true
            }
        }
    }
    
    func addShadow(shadowColor: CGColor = UIColor.black.cgColor,
                   shadowOffset: CGSize = CGSize(width: 5.0, height: 5.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 5.0) {
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    func addCardShadow() {
        self.addShadow(shadowColor: UIColor(netHex: 0x334e6a).cgColor, shadowOffset: CGSize(width: 1, height: 7), shadowOpacity: 0.1, shadowRadius: 7)
        self.layer.cornerRadius = 5
        self.clipsToBounds = false
    }
}

extension UIColor {
    convenience init(netHex: UInt) {
        let red = (netHex >> 16) & 0xff
        let green = (netHex >> 8) & 0xff
        let blue = netHex & 0xff
        
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}

extension String {
    func estimatedWidth(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    var localized: String {
        return NSLocalizedString(self, tableName: FPLangUtil.lang, bundle: Bundle.main, value: "", comment: "")
    }
    
    func localizedWithArgs(_ args: [CVarArg]) -> String {
        return String(format: self.localized, arguments: args)
    }
    
    var trim: String {
        return self.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        )
    }
    
    func inPersianNumbers() -> String {
        var outStr = self
        
        //convert English numbers to Persian
        outStr = outStr.replacingOccurrences(of: "0", with: "۰")
        outStr = outStr.replacingOccurrences(of: "1", with: "۱")
        outStr = outStr.replacingOccurrences(of: "2", with: "۲")
        outStr = outStr.replacingOccurrences(of: "3", with: "۳")
        outStr = outStr.replacingOccurrences(of: "4", with: "۴")
        outStr = outStr.replacingOccurrences(of: "5", with: "۵")
        outStr = outStr.replacingOccurrences(of: "6", with: "۶")
        outStr = outStr.replacingOccurrences(of: "7", with: "۷")
        outStr = outStr.replacingOccurrences(of: "8", with: "۸")
        outStr = outStr.replacingOccurrences(of: "9", with: "۹")
        
        //convert Arabic numbers to Persian
        outStr = outStr.replacingOccurrences(of: "٠", with: "۰")
        outStr = outStr.replacingOccurrences(of: "١", with: "۱")
        outStr = outStr.replacingOccurrences(of: "٢", with: "۲")
        outStr = outStr.replacingOccurrences(of: "٣", with: "۳")
        outStr = outStr.replacingOccurrences(of: "٤", with: "۴")
        outStr = outStr.replacingOccurrences(of: "٥", with: "۵")
        outStr = outStr.replacingOccurrences(of: "٦", with: "۶")
        outStr = outStr.replacingOccurrences(of: "٧", with: "۷")
        outStr = outStr.replacingOccurrences(of: "٨", with: "۸")
        outStr = outStr.replacingOccurrences(of: "٩", with: "۹")
        
        return outStr
    }
    
    func setTomanFormat() -> String {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.locale = Locale(identifier: "en")
        numberFormatter.numberStyle = .decimal
        numberFormatter.allowsFloats = false
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.groupingSeparator = "٬"
        
        let str = numberFormatter.string(from: NSNumber(value: Double(self) ?? 0)) ?? "0"
        
        return "\(str)".inPersianNumbers()
    }
    
    func setTomanFormatWithToman() -> String {
        return self.setTomanFormat() + " " + "toman".localized
    }
}
