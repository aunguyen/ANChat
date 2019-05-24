//
//  Conversation.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/19/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit

class Conversation: BaseModel {
	let user: UserObj
	var lastMessage: Message
	
	init(user: UserObj, lastMessage: Message) {
		self.user = user
		self.lastMessage = lastMessage
	}
}
