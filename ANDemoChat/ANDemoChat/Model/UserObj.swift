//
//  UserObj.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/18/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserObj: BaseModel {
	var username: String = ""
	var email: String = ""
	var uid: String = ""
	var online: Bool = false
	
	convenience init(username: String,
					 	email: String,
						 uid: String,
						 online: Bool) {
		self.init()
		self.username = username
		self.email = email
		self.uid = uid
		self.online = online
	}
	
	convenience init(snap: Dict) {
		let username = snap[DictKey.username] as? String ?? ""
		let email = snap[DictKey.email] as? String ?? ""
		let uid = snap[DictKey.uid] as? String ?? ""
		let online = snap[DictKey.online] as? Bool ?? false
		self.init(username: username ,
				  email: email,
				  uid: uid,
				  online: online)
	}
	
	func toDict() -> Dict{
		return [ DictKey.username: self.username,
				 DictKey.email: self.email,
				 DictKey.uid: self.uid,
				 DictKey.online: self.online]
	}
}
