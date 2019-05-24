//
//  ChatVC.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/19/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreLocation
import SDWebImage
import NYTPhotoViewer

class ChatVC: BaseVC {

	@IBOutlet weak private var textViewInput: UITextView!
	@IBOutlet weak private var tableView: UITableView!
	@IBOutlet weak private var btnSend: UIButton!
	@IBOutlet weak private var btnMore: UIButton!
	@IBOutlet weak private var menuView: UIView!
	@IBOutlet weak private var btn_Library: UIButton!
	@IBOutlet weak private var btnCamera: UIButton!
	
	private var viewmodel: ChatViewModel!
	private var msgType: MessageType = .text
	private var videoData:Data?
	private var photoData:Data?
	private var location:CLLocationCoordinate2D?
	var user: UserObj?
	var isShowMenu:Bool = false
	
	//MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		appDelegate.isInChat = true
		viewmodel = ChatViewModel(vc: self)
		self.title = user?.username ?? ""
		self.setNaviLeftBtn(image: #imageLiteral(resourceName: "ic_back"), title: "", handler: #selector(back))
		self.registerNoti(name: NotificationName.reloadData, selector: #selector(reloadChatData))
		self.textViewInput.delegate = self
		self.fetchData()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		guard let frUid = user?.uid else {return}
		appDelegate.isInChat = true
		FirebaseHelper.shared.markMessagesRead(forUserID: frUid )
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		textViewDidChange(textViewInput)
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		guard let myUid = appDelegate.user?.uid,
		      let frUid = user?.uid else {return}
		FirebaseHelper.shared
			.removeObserForRef(ref: FirebaseHelper.shared
												  .userRef
										   		  .child(myUid)
												  .child(Path.Conversation)
												  .child(frUid))
		FirebaseHelper.shared
			.removeObserForRef(ref:FirebaseHelper.shared
												 .conversationRef)
		appDelegate.isInChat = false
	}
	
	//MARK: - Data
	@objc func reloadChatData() {
		if appDelegate.isInChat{
			FirebaseHelper.shared.markMessagesRead(forUserID: user?.uid ?? "" )
			self.tableView.reloadData()
			self.tableView.scrollToBottomRow()
		}
	}
	
	private func fetchData() {
		guard let user = user else { return }
		viewmodel.getMessageOfConversation(user: user,complete: {
			self.tableView.reloadData()
			self.tableView.scrollToBottomRow()
		})
	}
	
	//MARK: - Action
	
	@objc func back(){
		self.popViewController()
	}
	
	@IBAction private func sendMessage(_ sender: Any) {
		var content: Any
		switch self.msgType {
		case .text:
			guard let msg = textViewInput.text, msg.count > 0 else { return }
			content = msg
			viewmodel.composeMessage(type: msgType, content: content)
			textViewInput.text = ""
			self.textViewInput.resignFirstResponder()
			break
		case .video:
			content = videoData as Any
			break
		case .photo:
			content = photoData as Any
			break
		case .location:
			content = location as Any
			break
		}
	}
	
	@IBAction private func showMoreMenu(_ sender: Any) {
		isShowMenu = !isShowMenu
		UIView.animate(withDuration: 0.5) {
			self.menuView.isHidden = !self.isShowMenu
		}
	}
	
	@IBAction func openCamera(_ sender: Any) {
		if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
			self.showPhotoPicker(type: .camera)
		}
	}
	
	@IBAction func openLibrary(_ sender: Any) {
		self.showPhotoPicker(type: .photoLibrary)
	}
	
	func showPhotoPicker(type:  UIImagePickerController.SourceType ){
		self.menuView.isHidden = true
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.sourceType = type
		picker.mediaTypes =  ["public.image","public.movie"]
		present(picker, animated: true, completion:nil)
	}
}

//MARK: - Photopicker delegate
extension ChatVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		picker.dismiss(animated: true, completion:nil)
		
		//case video
		
		if info[.mediaType] as? String == "public.movie"{
			if let videoUrl = info[.mediaURL] as? NSURL{
				print("videourl: ", videoUrl)
				//trying compression of video
				guard let data = NSData(contentsOf: videoUrl as URL) else {return}
				print("File size before compression: \(Double(data.length / 1048576)) mb")
				self.viewmodel.composeMessage(type: .video, content: data)
			}
			else{
				print("Something went wrong in  video")
			}
			
		}else{
			guard let image = info[.originalImage] as? UIImage else {
				fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
			}
			
			guard let imageData = image.jpegData(compressionQuality: 0.75) else {return}
			self.viewmodel.composeMessage(type: .photo, content: imageData)
		}
	}
	
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion:nil)
	}
	
}

//MARK: - Textview Delegate
extension ChatVC: UITextViewDelegate{
	func textViewDidChange(_ textView: UITextView) {
		self.msgType = .text
		let size = CGSize(width: view.frame.width, height: .infinity)
		let estimatedSize = textView.sizeThatFits(size)
		textView.constraints.forEach { (constraint) in
			if constraint.firstAttribute == .height {
				constraint.constant = estimatedSize.height
			}
		}
	}
}

//MARK: - Tableview
extension ChatVC: UITableViewDelegate, UITableViewDataSource{
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return viewmodel.chatMessages.count
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 50
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		if let firstMessageInSection = viewmodel.chatMessages[section].first {
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "dd/MM/YYYY"
			let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(firstMessageInSection.timestamp)))
			let label = DateHeaderLabel()
			label.text = dateString
			let containerView = UIView()
			containerView.addSubview(label)
			label.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
			label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
			return containerView
		}
		return nil
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewmodel.chatMessages[section].count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item = viewmodel.chatMessages[indexPath.section][indexPath.row]
		
		//Self messages
		switch item.owner {
		case .receiver:
			switch item.type {
			case .text:
				let cell = tableView.dequeueReusableCell(withIdentifier: TextReceiverCellID, for: indexPath) as! ReceiverCell
				cell.clearCellData()
				cell.message.text = item.content as? String
				cell.lblDate.text = ""
				self.formatMsgTime(msg: item, forCell: cell)
				self.updateStatus(msg: item, forCell: cell)
				return cell
			case .photo:
				let cell = tableView.dequeueReusableCell(withIdentifier: MediaReceiverCellID, for: indexPath) as! ReceiverCell
				cell.clearCellData()
				if let url = URL(string: item.content as? String ?? "") {
					cell.messageBackground.sd_setImage(with: url, placeholderImage: UIImage(named: "ic_download"), options: SDWebImageOptions.scaleDownLargeImages, context: nil)
				}
				cell.lblDate.text = ""
				self.formatMsgTime(msg: item, forCell: cell)
				self.updateStatus(msg: item, forCell: cell)
				return cell
			case .location:
				let cell = tableView.dequeueReusableCell(withIdentifier: LocReceiverCellID, for: indexPath) as! ReceiverCell
				return cell
			case .video:
				let cell = tableView.dequeueReusableCell(withIdentifier: MediaReceiverCellID, for: indexPath) as! ReceiverCell
				cell.clearCellData()
				cell.messageBackground.image = UIImage(named: "ic_play")
				cell.messageBackground.backgroundColor = .darkGray
				cell.lblDate.text = ""
				self.formatMsgTime(msg: item, forCell: cell)
				self.updateStatus(msg: item, forCell: cell)
				return cell
			}
			
		// Other's Messages
		case .sender:
			switch item.type {
				
			case .text:
				let cell = tableView.dequeueReusableCell(withIdentifier: TextSenderCellID, for: indexPath) as! SenderCell
				cell.clearCellData()
				cell.profilePic.setImage(string: user?.username ?? " ", color: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), circular: true, textAttributes: nil)
				cell.message.text = item.content as? String
				cell.lblDate.isHidden = true
				self.formatMsgTime(msg: item, forCell: cell)
				return cell
				
			case .photo:
				let cell = tableView.dequeueReusableCell(withIdentifier: MediaSenderCellID, for: indexPath) as! SenderCell
				cell.clearCellData()
				cell.profilePic.setImage(string: "A/N", color: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), circular: true, textAttributes: nil)
				if let url = URL(string: item.content as? String ?? "") {
					cell.messageBackground.sd_setImage(with: url, placeholderImage: UIImage(named: "ic_download"), options: SDWebImageOptions.scaleDownLargeImages, context: nil)
				}
				cell.lblDate.text = ""
				self.formatMsgTime(msg: item, forCell: cell)
				return cell
				
			case .location:
				let cell = tableView.dequeueReusableCell(withIdentifier: LocSenderCellID, for: indexPath) as! SenderCell
				return cell
				
			case .video:
				let cell = tableView.dequeueReusableCell(withIdentifier: MediaSenderCellID, for: indexPath) as! SenderCell
				cell.clearCellData()
				cell.profilePic.setImage(string: "A/N", color: #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1), circular: true, textAttributes: nil)
				cell.messageBackground.image = UIImage(named: "ic_play")
				cell.messageBackground.backgroundColor = .darkGray
				cell.lblDate.text = ""
				self.formatMsgTime(msg: item, forCell: cell)
				return cell
			}
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return UITableView.automaticDimension
	}
	
	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return 100
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if  viewmodel.chatMessages[indexPath.section].isEmpty{
			return
		}
		let item = viewmodel.chatMessages[indexPath.section][indexPath.row]
		if item.type == .photo{
			guard let url = URL(string: item.content as? String ?? "") else {return}
			viewmodel.showImage(fromURL:url )
		}else if item.type == .video{
			guard let url = URL(string: item.content as? String ?? "") else {return}
			viewmodel.playVideo(fromURL:url )
		}
	}
	
	private func formatMsgTime(msg:Message,
							   forCell cell:ChatCell){
		if (msg === viewmodel.chatMessages.last?.last){
			cell.lblDate.isHidden = false
			let messageDate = Date.init(timeIntervalSince1970: TimeInterval(msg.timestamp))
			cell.lblDate.text = messageDate.formatChatDateToTime()
		}
	}
	
	private func updateStatus(msg: Message,
							  forCell cell:ChatCell){
		if (msg === viewmodel.chatMessages.last?.last){
			cell.msgStatus.isHidden = false
			cell.updateMsgStatus(status: msg.isRead ? .Seen : .Sent)
		}else{
			cell.msgStatus.isHidden = true
		}
	}
}
