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
