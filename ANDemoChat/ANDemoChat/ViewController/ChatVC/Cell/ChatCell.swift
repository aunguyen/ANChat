//
//  ChatCell.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/24/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit
import AVKit

let MediaReceiverCellID = "MediaReceiverCell"
let TextReceiverCellID = "TextReceiverCell"
let LocReceiverCellID = "LocReceiverCell"

let MediaSenderCellID = "MediaSenderCell"
let TextSenderCellID = "TextSenderCell"
let LocSenderCellID = "LocSenderCell"

class ChatCell: UITableViewCell {
	@IBOutlet weak var lblDate: UILabel!
	@IBOutlet weak var message: UITextView!
	@IBOutlet weak var messageBackground: UIImageView!
	@IBOutlet weak var msgStatus: UIImageView!
	var videoURL:URL? {
		didSet{
			guard let url = videoURL, url.absoluteString.count > 0 else {return}
			self.setupVideo()
		}
	}
	
	var status:MsgStatus = .Sent {
		didSet{
			self.updateMsgStatus(status: status)
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
	
	func setupVideo(){
		self.messageBackground.image = self.getThumbnailFrom(path: videoURL!)
		let avplayer = AVPlayer(url: videoURL!)
		let vc = AVPlayerViewController()
		vc.player = avplayer
		vc.entersFullScreenWhenPlaybackBegins = true
		vc.showsPlaybackControls = true
		vc.view.frame = self.messageBackground.bounds
		self.messageBackground.addSubview(vc.view)
		self.viewContainingController()?.addChild(vc)
	}
	
	func getThumbnailFrom(path: URL) -> UIImage? {
		
		do {
			
			let asset = AVURLAsset(url: path , options: nil)
			let imgGenerator = AVAssetImageGenerator(asset: asset)
			imgGenerator.appliesPreferredTrackTransform = true
			let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
			let thumbnail = UIImage(cgImage: cgImage)
			
			return thumbnail
			
		} catch let error {
			
			print("*** Error generating thumbnail: \(error.localizedDescription)")
			return nil
			
		}
		
	}
	
	func clearCellData()  {
		if let msg = self.message {
			msg.text = nil
			msg.isHidden = false
		}
		if let bg = self.messageBackground {
			bg.image = nil
		}
	}
	
	func updateMsgStatus(status: MsgStatus){
		switch status {
		case .Sent:
			self.msgStatus.image = UIImage(named: "ic_sent")
			break
		case .Seen:
			self.msgStatus.image = UIImage(named: "ic_seen")
			break
		}
	}
}

class SenderCell: ChatCell {
	
	@IBOutlet weak var profilePic: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.selectionStyle = .none
		
		switch self.reuseIdentifier {
		case MediaSenderCellID:
			self.messageBackground.layer.cornerRadius = 5
			self.messageBackground.clipsToBounds = true
			break
		default:
			self.message.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
			break
		}
	}
}

enum MsgStatus{
	case Sent
	case Seen
}

class ReceiverCell: ChatCell {
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.selectionStyle = .none
		self.msgStatus.layer.cornerRadius = 5
		self.msgStatus.clipsToBounds = true
		switch self.reuseIdentifier {
			case MediaReceiverCellID:
				self.messageBackground.layer.cornerRadius = 5
				self.messageBackground.clipsToBounds = true
			break
			default:
				self.message.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
			break
		}
	}
}

class ConversationsTBCell: UITableViewCell {
	
	@IBOutlet weak var profilePic: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!
	@IBOutlet weak var messageLabel: UILabel!
	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var topLine: UIView!
	
	var isShowLine:Bool = false{
		didSet{
			self.topLine.isHidden = !isShowLine
		}
	}
	
	func clearCellData()  {
		self.profilePic.layer.borderColor = #colorLiteral(red: 0.7137254902, green: 0, blue: 0.3568627451, alpha: 1)
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.profilePic.layer.cornerRadius = self.profilePic.bounds.height/2.0
		self.profilePic.layer.borderWidth = 1.5
		self.profilePic.layer.borderColor = #colorLiteral(red: 0.7137254902, green: 0, blue: 0.3568627451, alpha: 1)
		self.profilePic.layer.masksToBounds = true
		
	}
	
	
}
