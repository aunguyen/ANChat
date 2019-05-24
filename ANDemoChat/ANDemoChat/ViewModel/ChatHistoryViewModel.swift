//
//  ChatHistoryViewModel.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/19/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatHistoryViewModel: BaseVM {
	var conversations: [Conversation] = []
	
	func getConversationsOfCurrentUser(){
		if let vc = self.vc as? ChatHistoryVC{
			FirebaseHelper.shared.showConversations { (convs) in
				self.conversations = convs
				vc.reloadData()
			}
		}
	}
	
	func showContactList(){
		if let vc = self.vc as? ChatHistoryVC,
			let dest = UIStoryboard.vcFrom(storyboard: StoryBoardID.Chat, identifier: VCIdentifier.contactListVC) as? ContactListVC{
			vc.goto(vc: dest)
		}
	}

	func logout(){
		if let vc = self.vc as? ChatHistoryVC{
			do {
				FirebaseHelper.shared.setUserOffline()
				try FirebaseHelper.shared.auth.signOut()
			} catch {
				print(error.localizedDescription)
			}
			Utilities.removeValueFromUDF(key: DictKey.uid)
			if let storedUID = Utilities.getValueFromUDF(key: DictKey.uid) as? String, storedUID.count > 0{
				FirebaseHelper.shared.userRef.child(storedUID).child(DictKey.online).setValue(false)
			}
			
			guard let dest = UIStoryboard.vcFrom(storyboard: StoryBoardID.Login, identifier: VCIdentifier.loginVC) as? LoginVC else {return}
			vc.goto(vc: dest)
		}
	}
}
