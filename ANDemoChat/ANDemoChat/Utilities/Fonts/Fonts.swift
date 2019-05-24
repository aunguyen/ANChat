//
//  Fonts.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import Foundation
import UIKit

let fontScaleWithWidth = 375.0

struct Fonts {
    enum Roboto: String {
        case regular = "Roboto-Regular"
        case light = "Roboto-Light"
        case thin = "Roboto-Thin"
        case bold = "Roboto-Bold"
        case medium = "Roboto-Medium"
        
        func toFontWith(size: Double) -> UIFont? {
            return UIFont(name: self.rawValue, size: (CGFloat(size) * Constants.Device.screenWidth / CGFloat(fontScaleWithWidth)))
        }
        
        var fontName: String {
            return rawValue
        }
    }
    
    enum RobotoSlab: String {
        case bold = "RobotoSlab-Bold"
        case regular = "RobotoSlab-Regular"
        case thin = "RobotoSlab-Thin"
        case light = "RobotoSlab-Light"
        
        func toFontWith(size: Double) -> UIFont? {
            return UIFont(name: self.rawValue, size: (CGFloat(size) * Constants.Device.screenWidth / CGFloat(fontScaleWithWidth)))
        }
        
        var fontName: String {
            return rawValue
        }
    }
    
    enum Museo: String {
        case regular700 = "Museo-700"
        case regular300 = "Museo-300"
        
        func toFontWith(size: Double) -> UIFont? {
            return UIFont(name: self.rawValue, size: (CGFloat(size) * Constants.Device.screenWidth / CGFloat(fontScaleWithWidth)))
        }
        
        var fontName: String {
            return rawValue
        }
    }
    
    enum SFProDisplay: String {
        case regular = "SFProDisplay-Regular"
        case bold = "SFProDisplay-Bold"
        case semiBold = "SFProDisplay-Semibold"
        case light = "SFProDisplay-Light"
        
        func toFontWith(size: Double) -> UIFont? {
            return UIFont(name: self.rawValue, size: (CGFloat(size) * Constants.Device.screenWidth / CGFloat(fontScaleWithWidth)))
        }
        
        var fontName: String {
            return rawValue
        }
    }
    
    enum SFProText: String {
        case medium = "SFProText-Medium"
        case bold = "SFProText-Bold"
        
        func toFontWith(size: Double) -> UIFont? {
            return UIFont(name: self.rawValue, size: (CGFloat(size) * Constants.Device.screenWidth / CGFloat(fontScaleWithWidth)))
        }
        
        var fontName: String {
            return rawValue
        }
    }
}
