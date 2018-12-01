//
//  Helper.swift
//  test2
//
//  Created by amirhosseinpy on 6/30/1397 AP.
//  Copyright © 1397 amirhosseinpy. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    static var images: [UIImage] = []
    static var selectedIndex: Int = 0
    
    static func setupImages() {
        for i in 1...5 {
            if let image = UIImage(named: "carpet_\(i)") {
                Helper.images.append(image)
            }
        }
    }
}
