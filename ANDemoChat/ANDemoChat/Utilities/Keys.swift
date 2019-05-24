//
//  Keys.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//
import Foundation


struct VCIdentifier {
	static let createAccountVC = "CreateAccountVC"
	static let loginVC = "LoginVC"
    static let forgetPasswordVC = "ForgetPasswordVC"
	static let contactListVC = "ContactListVC"
	static let chatHistoryVC = "ChatHistoryVC"
	static let chatVC = "ChatVC"
}

struct StoryBoardID {
	static let Login = "Login"
	static let Chat = "Chat"

}

struct CellID {
	static let ContactCell = "ContactCell"
	static let ChatHistoryCell = "ChatHistoryCell"
}

struct Path {
	static let User = "User"
	static let Conversation = "Conversation"
	static let location = "location"
	static let photo = "photo"
	static let video = "video"
	static let audio = "audio"
}

struct DictKey {
	static let username = "username"
	static let uid = "uid"
	static let email = "email"
	static let online = "online"
	static let location = "location"
	static let content = "content"
	static let timestamp = "timestamp"
	static let type = "type"
	static let fromID = "fromID"
	static let toID = "toID"
	static let isRead = "isRead"
	static let text = "text"
	static let photo = "photo"
	static let video = "video"
	
}

struct NotificationName {
	static let reloadData = "reloadData"
}

let loadingImage = ""
