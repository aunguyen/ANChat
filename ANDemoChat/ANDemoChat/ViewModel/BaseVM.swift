//
//  BaseVM.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit

class BaseVM: NSObject {
	var vc:BaseVC?
	var model:BaseModel?
	let fb = FirebaseHelper.shared
	
	convenience init(vc:BaseVC) {
		self.init()
		self.vc = vc
	}
}
