//
//  Utilities.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import MBProgressHUD

class Utilities: NSObject {

	class func isConnectedToNetwork() -> Bool {
		
		var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
		zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
		zeroAddress.sin_family = sa_family_t(AF_INET)
		
		let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
				SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
			}
		}
		
		var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
		if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
			return false
		}
		
		// Working for Cellular and WIFI
		let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
		let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
		let ret = (isReachable && !needsConnection)
		
		return ret
	}
	
	static func errorWithReason(reason: String) -> Error{
		let err = NSError(domain: "ErrorDomain", code: -1, userInfo: [NSLocalizedDescriptionKey : reason])
		return err
	}
	
	class func showAlert(title:String,msg:String){
		let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
		let actionOk = UIAlertAction(title: "OK", style: .default, handler: nil )
		alert.addAction(actionOk)
		UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
	}
	
	class func showLoading(){
		guard let view = UIApplication.topViewController()?.view else {return}
		MBProgressHUD.showAdded(to:view , animated: true)
	}
	
	class func hideLoading(){
		guard let view = UIApplication.topViewController()?.view else {return}
		MBProgressHUD.hide(for: view, animated: true)
	}
	
	class func saveValueToUDF(value:Any, key:String){
		UserDefaults.standard.set(value, forKey: key)
		UserDefaults.standard.synchronize()
	}
	
	class func getValueFromUDF(key: String) -> Any{
		return UserDefaults.standard.value(forKey: key) as Any
	}
	
	class func removeValueFromUDF(key:String){
		UserDefaults.standard.removeObject(forKey: key)
		UserDefaults.standard.synchronize()
	}
	
	class func postNoti(name:String){
		
	}
	
}

class DateHeaderLabel: UILabel {
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		backgroundColor = .black
		textColor = .white
		textAlignment = .center
		translatesAutoresizingMaskIntoConstraints = false
		font = UIFont.boldSystemFont(ofSize: 14)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override var intrinsicContentSize: CGSize {
		let originalContentSize = super.intrinsicContentSize
		let height = originalContentSize.height + 12
		layer.cornerRadius = height / 2
		layer.masksToBounds = true
		return CGSize(width: originalContentSize.width + 20, height: height)
	}
	
}
