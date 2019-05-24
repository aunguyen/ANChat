//
//  Colors.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import Foundation
import UIKit

enum Colors: Int {
    case color_135e62 = 0x135e62
    case color_24b1b8 = 0x24b1b8
    case color_92dce0 = 0x92dce0
    case color_233740 = 0x233740
    case color_969696 = 0x969696
    case color_2D2D2D = 0x2D2D2D
    case color_32A8A8 = 0x32A8A8
    case color_F8F8F8 = 0xF8F8F8
    
    func color(alpha: CGFloat = 1) -> UIColor {
        return UIColor(netHex: self.rawValue, alpha: alpha)
    }
}

let kColor969696 = Colors.color_969696.color()
let kColor969696Alpha12 = Colors.color_969696.color(alpha: 0.12)
let kColor2D2D2D = Colors.color_2D2D2D.color()
let kColor32A8A8 = Colors.color_32A8A8.color()
let kColorF8F8F8Alpha82 = Colors.color_F8F8F8.color(alpha: 0.82)
