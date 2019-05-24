//
//  ContactViewModel.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/18/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit

class ContactViewModel: BaseVM {
	var contactArr: [UserObj] = []
	var originArr: [UserObj] = []
	var searchMode: Bool = false
	
	func getListContact(){
		guard let vc = self.vc as? ContactListVC else { return }
		vc.showProgress()
		fb.getListUser { (arrUser) in
			vc.hideProgress()
			self.contactArr = arrUser
			self.originArr = arrUser
			vc.reloadData()
		}
	}
	
	func filterUserWithName(name: String){
		guard let vc = self.vc as? ContactListVC else { return }
		searchMode = name.count > 0
		if searchMode == false {
			contactArr = originArr
			vc.reloadData()
			return
		}
		contactArr = contactArr.filter{
			return $0.username.lowercased().contains(name)
		}
		vc.reloadData()
	}
	
	func startChatWithUser(user: UserObj){
		guard let chatVC = UIStoryboard.vcFrom(storyboard: StoryBoardID.Chat, identifier: VCIdentifier.chatVC) as? ChatVC else {return}
		guard let vc = self.vc as? ContactListVC else { return }
		chatVC.user = user
		vc.goto(vc: chatVC)
	}
}
