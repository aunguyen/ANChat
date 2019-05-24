//
//  ChatHistoryCell.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/19/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit

class ChatHistoryCell: UITableViewCell {
	
	@IBOutlet weak var imgAvt: UIImageView!
	@IBOutlet weak var lblSender: UILabel!
	@IBOutlet weak var lblLastMsg: UILabel!
	@IBOutlet weak var lblTime: UILabel!
	
	var conversation: Conversation?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func configWithConversation(conversation: Conversation){
		self.conversation = conversation
		
		switch conversation.lastMessage.type {
			case .text:
				let message = conversation.lastMessage.content as? String ?? ""
				lblLastMsg.text = message
			case .location:
				lblLastMsg.text = "Location"
			case .photo:
				lblLastMsg.text = "Image"
			default:
				lblLastMsg.text = "Video"
		}
		self.imgAvt.setImage(string: conversation.user.username,
							 color: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1),
							 circular: true,
							 textAttributes: nil)
		self.lblSender.text = conversation.user.username
		let messageDate = Date.init(timeIntervalSince1970: TimeInterval(conversation.lastMessage.timestamp))
		
		lblTime.text = messageDate.formatChatDateToDate()
	}
}
