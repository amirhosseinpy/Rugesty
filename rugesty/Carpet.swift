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
    var designNo: String?
    var density: String?
    var backgroundColor: String?
    var numberOfColors: Int?
    var pileYarn: String?
    var wrapWeftYarn: String?
    
    static func setupCarpets() -> [Carpet] {
        var carpets: [Carpet] = []
        let carpet1 = Carpet()
        carpet1.image = UIImage(named: "carpet_1")
        carpet1.designNo = "A2"
        carpet1.backgroundColor = "Black"
        carpet1.numberOfColors = 11
        carpet1.density = "2 560 000 knots/m2"
        carpet1.pileYarn = "Tencel®-v"
        carpet1.wrapWeftYarn = "Tencel®-v"
        carpets.append(carpet1)
        
        let carpet2 = Carpet()
        carpet2.image = UIImage(named: "carpet_2")
        carpet2.designNo = "16006"
        carpet2.backgroundColor = "Black"
        carpet2.numberOfColors = 11
        carpet2.density = "2 560 000 knots/m2"
        carpet2.pileYarn = "Tencel®-v"
        carpet2.wrapWeftYarn = "Tencel®-v"
        carpets.append(carpet2)
        
        let carpet3 = Carpet()
        carpet3.image = UIImage(named: "carpet_3")
        carpet3.designNo = "16010"
        carpet3.backgroundColor = "White"
        carpet3.numberOfColors = 11
        carpet3.density = "2 560 000 knots/m2"
        carpet3.pileYarn = "Tencel®-v"
        carpet3.wrapWeftYarn = "Tencel®-v"
        carpets.append(carpet3)
        
        let carpet4 = Carpet()
        carpet4.image = UIImage(named: "carpet_4")
        carpet4.designNo = "16006"
        carpet4.backgroundColor = "Black"
        carpet4.numberOfColors = 11
        carpet4.density = "2 560 000 knots/m2"
        carpet4.pileYarn = "Tencel®-v"
        carpet4.wrapWeftYarn = "Tencel®-v"
        carpets.append(carpet4)
        
        let carpet5 = Carpet()
        carpet5.image = UIImage(named: "carpet_5")
        carpet5.designNo = "16019"
        carpet5.backgroundColor = "Dark Violet"
        carpet5.numberOfColors = 11
        carpet5.density = "2 560 000 knots/m2"
        carpet5.pileYarn = "Tencel®-v"
        carpet5.wrapWeftYarn = "Tencel®-v"
        carpets.append(carpet5)
        
        let carpet6 = Carpet()
        carpet5.image = UIImage(named: "carpet_6")
        carpet6.designNo = "16014"
        carpet6.backgroundColor = "Dark Blue"
        carpet6.numberOfColors = 11
        carpet6.density = "2 560 000 knots/m2"
        carpet6.pileYarn = "Tencel®-v"
        carpet6.wrapWeftYarn = "Tencel®-v"
        carpets.append(carpet5)
        return carpets
    }
}
