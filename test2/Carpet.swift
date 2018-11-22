//
//  Model.swift
//  test2
//
//  Created by amirhosseinpy on 6/30/1397 AP.
//  Copyright © 1397 amirhosseinpy. All rights reserved.
//

import Foundation
import UIKit

class Carpet {
    var id: String?
    var image: UIImage?
    var name: String?
    var size: String?
    var texturePlace: String?
    var density: String?
    var material: String?
    var color: String?
    
    static func setupCarpets() -> [Carpet] {
        var carpets: [Carpet] = []
        let carpet1 = Carpet()
        carpet1.image = UIImage(named: "carpet_1")
        carpet1.name = "فرش روستایی"
        carpet1.size = "۱۳۵ * ۲۰۳"
        carpet1.texturePlace = "فراهان"
        carpet1.density = "۱۰ گره در ۷ سانتی متر"
        carpet1.material = "نخ و پشم"
        carpet1.color = "کرم - سرمه ای"
        carpets.append(carpet1)
        
        let carpet2 = Carpet()
        carpet2.image = UIImage(named: "carpet_2")
        carpet2.name = "فرش پامچال"
        carpet2.size = "۱۵۰ * ۲۰۰"
        carpet2.texturePlace = "فارس"
        carpet2.density = "۴۰ گره در هر ۱۰ سانتی متر"
        carpet2.material = "پشم"
        carpet2.color = "سبز"
        carpets.append(carpet2)
        
        let carpet3 = Carpet()
        carpet3.image = UIImage(named: "carpet_3")
        carpet3.name = "فرش بیجار"
        carpet3.size = "۱۷۳ * ۲۱۳"
        carpet3.texturePlace = "بیجار"
        carpet3.density = "۳۹ گره در ۷ سانتی متر"
        carpet3.material = "نخ و پشم"
        carpet3.color = "قرمز - سرمه ای"
        carpets.append(carpet3)
        
        let carpet4 = Carpet()
        carpet4.image = UIImage(named: "carpet_4")
        carpet4.name = "فرش زرنشان"
        carpet4.size = "۱۵۱ * ۲۲۲"
        carpet4.texturePlace = "سنه"
        carpet4.density = "۵۰ گره در ۷ سانتی متر"
        carpet4.material = "ابریشم و پشم"
        carpet4.color = "کرم - ابی"
        carpets.append(carpet4)
        
        let carpet5 = Carpet()
        carpet5.image = UIImage(named: "carpet_5")
        carpet5.name = "فرش رضوان"
        carpet5.size = "۲۰۰ * ۲۸۸"
        carpet5.texturePlace =  "قم"
        carpet5.density = "۷۰ گره در ۷ سانتی متر"
        carpet5.material = "ابریشم و کتان"
        carpet5.color = "مشکی"
        carpets.append(carpet5)
        return carpets
    }
}
