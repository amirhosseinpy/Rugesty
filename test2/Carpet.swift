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
    var ownerName: String?
    var size: String?
    var texturePlace: String?
    var density: String?
    var material: String?
    var color: String?
    
    static func setupCarpets() -> [Carpet] {
        var carpets: [Carpet] = []
        let carpet4 = Carpet()
        carpet4.image = UIImage(named: "carpet_4")
        carpet4.name = "فرش زرنشان"
        carpet4.ownerName = "امین سلیمانی"
        carpet4.size = "۱۵۱ * ۲۲۲"
        carpet4.texturePlace = "سنه"
        carpet4.density = "۵۰ گره در ۷ سانتی متر"
        carpet4.material = "ابریشم و پشم"
        carpet4.color = "کرم - ابی"
        carpets.append(carpet4)
        
        return carpets
    }
}


