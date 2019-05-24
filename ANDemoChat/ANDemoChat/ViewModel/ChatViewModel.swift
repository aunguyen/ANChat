//
//  ChatViewModel.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/18/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit
import AVKit

class ChatViewModel: BaseVM {
	
	var items = [Message]()
	var chatMessages : [[Message]] {
		var chatMsg = [[Message]]()
		let groupedMsgs = Dictionary(grouping: self.items) { (msg) -> Date in
			return Date(timeIntervalSince1970: TimeInterval(msg.timestamp)).reduceToMonthDayYear()
		}
		
		let sortedKeys = groupedMsgs.keys.sorted()
		sortedKeys.forEach { (key) in
			let values = groupedMsgs[key]
			chatMsg.append(values ?? [])
		}
		return chatMsg
	}
	//MARK: - Fetch Data
	
	func getMessageOfConversation(user: UserObj, complete:@escaping ()->()){
		guard let vc = self.vc as? ChatVC else {
			return
		}
		FirebaseHelper.shared.downloadAllMessages(forUserID: user.uid) { (msg) in
			let ids = self.items.map{$0.timestamp}
			if !ids.contains(msg.timestamp){
				self.items.append(msg)
			}else{
				self.items.last?.mergeWith(msg: msg)
			}
			vc.reloadChatData()
		}
	}
	
	//MARK: - Upload Data

	func composeMessage(type: MessageType, content: Any)  {
		guard let vc = self.vc as? ChatVC,
			  let uid = vc.user?.uid else {return}
		let message = Message.init(type: type, content: content, owner: .sender, timestamp: Int(Date().timeIntervalSince1970), isRead: false)
		FirebaseHelper.shared.send(message: message, toID: uid , completion: {(success) in
			vc.reloadChatData()
		})
	}
	
	//MARK: - Function
	func showImage(fromURL:URL){
		guard let vc = self.vc as? ChatVC else {
				return
		}
		let dest = MediaViewer(nibName: "MediaViewer", bundle: nil)
		dest.url = fromURL
		vc.goto(vc: dest)
	}
	
	func playVideo(fromURL:URL){
		guard let vc = self.vc as? ChatVC else {
			return
		}
		let player = AVPlayer(url: fromURL)
		let playerController = AVPlayerViewController()
		playerController.player = player
		playerController.showsPlaybackControls = true
		vc.present(playerController, animated: true) {
			player.play()
		}
	}
}
