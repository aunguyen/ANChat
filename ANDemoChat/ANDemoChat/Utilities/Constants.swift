//
//  Constants.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import Foundation
import UIKit

let defaultNotification = NotificationCenter.default
let appDelegate = UIApplication.shared.delegate as! AppDelegate

struct Constants {
	
	static let WarningText = Localize.locString(key: "lk_Warning")
	static let OKText = Localize.locString(key: "lk_OK")
	static let ErrorText = Localize.locString(key: "lk_Error")
	static let UnknowErrorText = Localize.locString(key: "lk_Unkonw_error")
	static let UserError = Utilities.errorWithReason(reason: Localize.locString(key: "lk_Invalid_User"))
	static let LoginError = Utilities.errorWithReason(reason: Localize.locString(key: "lk_Login_Error"))
    
    struct Device {
        static let deviceScale = UIScreen.main.scale
        static let screenSize = UIScreen.main.bounds.size
        static let screenWidth = Device.screenSize.width
        static let screenHeight = Device.screenSize.height
        static let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        static let navBarHeight = UINavigationController().navigationBar.frame.size.height
        static let tabbarHeight = UITabBarController().tabBar.frame.size.height
    }
    
    struct DateFormater {
        static let StandardWithMilisecond = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        static let OnlyTime12h = "HH:mm a"
        static let OnlyTime24h = "HH:mm"
        static let FullDateDisplayWithTime = "yyyy/MMMM/dd hh:mm a"
        static let YearOnly = "yyyy"
        static let BirthDay = "dd-MM-yyyy"
        static let DateMonth = "MMMM/dd"
        static let DayOfWeek = "EEE"
    }
	
	struct Path {
		static let DayOfWeek = "EEE"
	}
}

