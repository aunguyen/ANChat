//
//  Message.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/19/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit

enum MessageOwner {
	case sender
	case receiver
}

enum MessageType {
	case photo
	case video
	case text
	case location
}

class Message: BaseModel {
	var owner: MessageOwner = .sender
	var type: MessageType = .text
	var content: Any = ""
	var timestamp: Int = 0
	var isRead: Bool = false
	var image: UIImage?
	private var toID: String = ""
	private var fromID: String = ""
	
	convenience init(type: MessageType, content: Any, owner: MessageOwner, timestamp: Int, isRead: Bool) {
		self.init()
		self.type = type
		self.content = content
		self.owner = owner
		self.timestamp = timestamp
		self.isRead = isRead
	}
	
	func mergeWith(msg: Message) {
		self.type = msg.type
		self.content = msg.content
		self.owner = msg.owner
		self.timestamp = msg.timestamp
		self.isRead = msg.isRead
	}
}
