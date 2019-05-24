//
//  ChatHistoryVC.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/18/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit

class ChatHistoryVC: BaseVC {
	var viewmodel: ChatHistoryViewModel!
	@IBOutlet weak private var tableView: UITableView!
	private let refresher: UIRefreshControl = UIRefreshControl()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Conversations"
		self.showNavibar()
		viewmodel = ChatHistoryViewModel(vc: self)
		self.setNaviRightBtn(image: #imageLiteral(resourceName: "ic_chat"), title: "", handler: #selector(searchContact))
		self.setNaviLeftBtn(image: #imageLiteral(resourceName: "ic_logout"), title: "", handler: #selector(logout))
		self.refresher.addTarget(self, action: #selector(fetchData), for: .valueChanged)
		self.tableView.refreshControl = refresher
		self.fetchData()
    }
	
	@objc func fetchData() {
		self.viewmodel.getConversationsOfCurrentUser()
	}
	
	@objc func searchContact() {
		viewmodel.showContactList()
	}
	
	@objc func logout(){
		viewmodel.logout()
	}
	
	func reloadData(){
		refresher.endRefreshing()
		self.tableView.reloadData()
	}

}

//MARK: - Tableview
extension ChatHistoryVC: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewmodel.conversations.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: CellID.ChatHistoryCell) as? ChatHistoryCell{
			cell.configWithConversation(conversation: viewmodel.conversations[indexPath.row])
			return cell
		}
		
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let conver = viewmodel.conversations[indexPath.row] as? Conversation, let chatVC = UIStoryboard.vcFrom(storyboard: StoryBoardID.Chat, identifier: VCIdentifier.chatVC) as? ChatVC {
			chatVC.user = conver.user
			self.goto(vc: chatVC)
		}
	}
}
