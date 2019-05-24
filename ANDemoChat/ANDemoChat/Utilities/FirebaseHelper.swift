//
//  FirebaseHelper.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

typealias Dict = [String: Any]
typealias DictHandler = ((Dict?,Error?)->())
typealias UserHandler = ((UserObj?,Error?)->())
typealias SuccessHandler = ((Bool)->())

class FirebaseHelper{
	
	static let shared = FirebaseHelper()
	let auth = Auth.auth()
	let userRef: DatabaseReference = Database.database().reference().child(Path.User)
	let conversationRef: DatabaseReference = Database.database().reference().child(Path.Conversation)
	let photoStorage: StorageReference = Storage.storage().reference().child(Path.photo)
	let videoStorage: StorageReference = Storage.storage().reference().child(Path.video)
	
	var currentUID: String?{
		return appDelegate.user?.uid
	}
	
	//MARK: - Online/Offline handle
	
	func synchronizeData(){
		userRef.keepSynced(true)
		conversationRef.keepSynced(true)
	}
	
	//MARK: - Observation
	
	func removeObserForRef(ref: DatabaseReference){
		ref.removeAllObservers()
	}
	
	//MARK: - Authentication
	
	func createUser(email: String,
					pass: String,
					completion: @escaping UserHandler){
		auth.createUser(withEmail: email, password: pass) { (result, error) in
			if let err = error {
				completion(nil,err)
				return
			}
			guard let email = result?.user.email,
				let uid = result?.user.uid else {
					let error = Utilities.errorWithReason(reason: Localize.locString(key: "lk_Invalid_User"))
					completion(nil,error)
					return
			}
			let user = UserObj(username: "",
							   email: email,
							   uid: uid,
							   online: false )
			completion(user,nil)
		}
	}
	
	func loginWithEmail(email: String,
						pass: String,
						completion:@escaping UserHandler){
		auth.signIn(withEmail: email, password: pass) { (result, error) in
			if let err = error {
				completion(nil,err)
				return
			}
			guard let uid = result?.user.uid else {
				completion(nil,Constants.UserError)
				return
			}
			self.getUserByID(uid: uid, complete: { (user, err) in
				if let error = err {
					completion(nil,error)
					return
				}
				guard let u = user else {
					completion(nil,Constants.UserError)
					return
				}
				completion(u,nil)
			})
		}
	}
	
	func setUserOnline(){
		guard let uid = self.currentUID else {return}
		userRef.child(uid).child(DictKey.online).setValue(true)
	}
	
	func setUserOffline(){
		guard let uid = self.currentUID else {return}
		userRef.child(uid).child(DictKey.online).setValue(false)
	}
	//MARK: - Query user
	
	func getListUser(complete:@escaping ([UserObj])->()){
		userRef.observe(.value) { (snapShot) in
			var tmpArr = [UserObj]()
			if snapShot.hasChildren(){
				for snap in snapShot.children{
					guard let uDict = snap as? DataSnapshot else {continue}
					let user = UserObj(snap: uDict.value as! Dict)
					if user.uid != self.currentUID{
						tmpArr.append(user)
					}
				}
				complete(tmpArr)
			}else{
				complete([])
			}
		}
	}
	
	func getUserByID(uid: String,
					 complete: @escaping UserHandler) {
		userRef.queryOrderedByKey()
			.queryEqual(toValue: uid)
			.observeSingleEvent(of: .value) { (snapshot) in
				if let res = snapshot.value as? Dict,
					let uValue = res[uid] as? Dict {
					let user = UserObj(snap: uValue)
					complete(user,nil)
				}else{
					complete(nil,Constants.UserError)
				}
		}
	}
	
	func insertUserToDB(user:UserObj, completion:@escaping SuccessHandler){
		userRef.child(user.uid).setValue(user.toDict()) { (error, ref) in
			if let _ = error {
				completion(false)
			}else{
				completion(true)
			}
		}
	}
	
	//MARK: - Conversation
	
	func showConversations(completion:@escaping ([Conversation]) -> ()) {
		if let uid = self.currentUID {
			var conversations = [Conversation]()
			userRef.child(uid)
				.child(Path.Conversation)
				.observe(.childAdded, with: { (snapshot) in
					if snapshot.exists() {
						let fromID = snapshot.key
						self.getUserByID(uid: fromID, complete: { (user, error) in
							guard let u = user else {
								completion([])
								return
							}
							let values = snapshot.value as! [String: String]
							let location = values[DictKey.location]!
							let emptyMessage = Message.init(type: .text, content: "", owner: .sender, timestamp: 0, isRead: false)
							let conversation = Conversation.init(user: u, lastMessage: emptyMessage)
							conversations.append(conversation)
							self.getLastMessageOfConversation(cid: location, complete: { (message) in
								conversation.lastMessage = message
								completion(conversations)
							})
						})
					}
				})
		}
	}
	
	func getLastMessageOfConversation(cid: String, complete:@escaping (Message)->()){
		guard let currentUserID = self.currentUID else {
			complete(Message())
			return
		}
		self.conversationRef.child(cid)
			.observe(.value, with: { (snapshot) in
				if snapshot.exists() {
					for snap in snapshot.children {
						let message = Message()
						guard let receivedMessage = (snap as? DataSnapshot)?.value as? Dict else {
							complete(Message())
							return
						}
						
						message.content = receivedMessage[DictKey.content] ?? ""
						message.timestamp = receivedMessage[DictKey.timestamp] as? Int ?? 0
						let messageType = receivedMessage[DictKey.type] as? String ?? ""
						let fromID = receivedMessage[DictKey.fromID] as? String ?? ""
						message.isRead = receivedMessage[DictKey.isRead] as? Bool ?? false
						var type = MessageType.text
						switch messageType {
						case DictKey.text:
							type = .text
							break
						case DictKey.photo:
							type = .photo
							break
						case DictKey.location:
							type = .location
							break
						case DictKey.video:
							type = .video
							break
						default:
							break
						}
						message.type = type
						if currentUserID == fromID {
							message.owner = .receiver
						} else {
							message.owner = .sender
						}
						complete(message)
					}
				}
			})
	}
	
	//MARK: - Chat Message
	func downloadAllMessages(forUserID: String, completion: @escaping (Message) -> ()) {
		if let currentUserID = self.currentUID {
			userRef.child(currentUserID).child(Path.Conversation).child(forUserID).observe(.value, with: { (snapshot) in
				if snapshot.exists() {
					guard let data = snapshot.value as? [String: String] else {
						completion(Message())
						return
					}
					let location = data[Path.location] ?? ""
					self.conversationRef.child(location).observe(.childAdded, with: { (snap) in
						if snap.exists() {
							let receivedMessage = snap.value as! [String: Any]
							let messageType = receivedMessage[DictKey.type] as! String
							var type = MessageType.text
							switch messageType {
								case DictKey.photo:
									type = .photo
								case DictKey.location:
									type = .location
								case DictKey.video:
									type = .video
								default:
								break
							}
							let content = receivedMessage[DictKey.content] as? String ?? ""
							let fromID = receivedMessage[DictKey.fromID] as? String ?? ""
							let timestamp = receivedMessage[DictKey.timestamp] as? Int ?? 0
							let status = receivedMessage[DictKey.isRead] as? Bool ?? false
							if fromID == currentUserID {
								let message = Message.init(type: type, content: content, owner: .receiver, timestamp: timestamp, isRead: status)
								completion(message)
							} else {
								let message = Message.init(type: type, content: content, owner: .sender, timestamp: timestamp, isRead: status)
								completion(message)
							}
						}
					})
					
					//obser for changed
					self.conversationRef.child(location).observe(.childChanged, with: { (snap) in
						if snap.exists() {
							let receivedMessage = snap.value as! [String: Any]
							let messageType = receivedMessage[DictKey.type] as! String
							var type = MessageType.text
							switch messageType {
							case DictKey.photo:
								type = .photo
							case DictKey.location:
								type = .location
							case DictKey.video:
								type = .video
							default: break
							}
							let content = receivedMessage[DictKey.content] as? String ?? ""
							let fromID = receivedMessage[DictKey.fromID] as? String ?? ""
							let timestamp = receivedMessage[DictKey.timestamp] as? Int ?? 0
							let status = receivedMessage[DictKey.isRead] as? Bool ?? false
							if fromID == currentUserID {
								let message = Message.init(type: type, content: content, owner: .receiver, timestamp: timestamp, isRead: status)
								completion(message)
							} else {
								let message = Message.init(type: type, content: content, owner: .sender, timestamp: timestamp, isRead: status)
								completion(message)
							}
						}
					})
				}
			})
		}
	}
	
	func send(message: Message, toID: String, completion: @escaping (Bool) -> ())  {
		if let currentUserID = self.currentUID {
			switch message.type {
			case .location:
				let values = [DictKey.type : DictKey.location,
							  DictKey.content : message.content,
							  DictKey.fromID : currentUserID,
							  DictKey.toID : toID,
							  DictKey.timestamp : message.timestamp,
							  DictKey.isRead: false]
				self.uploadMessage(withValues: values, toID: toID, completion: { (status) in
					completion(status)
				})
			case .photo:
				//place holder message
				let values = [DictKey.type: DictKey.photo,
							  DictKey.content: loadingImage,
							  DictKey.fromID: currentUserID,
							  DictKey.toID: toID,
							  DictKey.timestamp: message.timestamp,
							  DictKey.isRead: false] as Dict
				self.uploadMessage(withValues: values, toID: toID, completion: { (status) in
					completion(status)
				})
				
				//put file
				let child = String(format: "%@.jpg", UUID().uuidString)
				let metadata = StorageMetadata()
				metadata.contentType = "image/jpeg"
				photoStorage.child(child).putData(message.content as! Data, metadata: metadata, completion: { (metadata, error) in
					if error == nil {
						self.photoStorage.child(child).downloadURL(completion: { (url, error) in
							guard let url = url, error == nil else {
								completion(false)
								return
							}
							let values = [DictKey.type: DictKey.photo,
										  DictKey.content: url.absoluteString,
										  DictKey.fromID: currentUserID,
										  DictKey.toID: toID,
										  DictKey.timestamp: message.timestamp,
										  DictKey.isRead: false] as Dict
							self.uploadMessage(withValues: values, toID: toID, completion: { (status) in
								completion(status)
							})
						})
					}else{
						Utilities.showAlert(title: Constants.ErrorText, msg: error!.localizedDescription)
					}
				})
			case .text:
				let values = [DictKey.type: DictKey.text,
							  DictKey.content: message.content,
							  DictKey.fromID: currentUserID,
							  DictKey.toID: toID,
							  DictKey.timestamp: message.timestamp,
							  DictKey.isRead: false] as Dict
				self.uploadMessage(withValues: values, toID: toID, completion: { (status) in
					completion(status)
				})
			case .video:
				let values = [DictKey.type: DictKey.video,
							  DictKey.content: loadingImage,
							  DictKey.fromID: currentUserID,
							  DictKey.toID: toID,
							  DictKey.timestamp: message.timestamp,
							  DictKey.isRead: false] as Dict
				self.uploadMessage(withValues: values, toID: toID, completion: { (status) in
					completion(status)
				})
				
				//put file
				let child = String(format: "%@.mov", UUID().uuidString)
				let metadata = StorageMetadata()
				metadata.contentType = "video/quicktime"
				videoStorage.child(child).putData(message.content as! Data, metadata: metadata, completion: { (metadata, error) in
					if error == nil {
						self.videoStorage.child(child).downloadURL(completion: { (url, error) in
							guard let url = url, error == nil else {
								completion(false)
								return
							}
							let values = [DictKey.type: DictKey.video,
										  DictKey.content: url.absoluteString,
										  DictKey.fromID: currentUserID,
										  DictKey.toID: toID,
										  DictKey.timestamp: message.timestamp,
										  DictKey.isRead: false] as Dict
							self.uploadMessage(withValues: values, toID: toID, completion: { (status) in
								completion(status)
							})
						})
					}else{
						Utilities.showAlert(title: Constants.ErrorText, msg: error!.localizedDescription)
					}
				})
			}
		}
	}
	
	func uploadMessage(withValues: [String: Any], toID: String, completion: @escaping (Bool) -> ()) {
		if let currentUserID = appDelegate.user?.uid {
			self.userRef.child(currentUserID).child(Path.Conversation).child(toID).observeSingleEvent(of: .value, with: { (snapshot) in
				if snapshot.exists() {
					let data = snapshot.value as! [String: String]
					let location = data[DictKey.location]!
					self.conversationRef.child(location).childByAutoId().setValue(withValues, withCompletionBlock: { (error, _) in
						if error == nil {
							completion(true)
						} else {
							completion(false)
						}
					})
				} else {
					Database.database().reference().child(Path.Conversation).childByAutoId().childByAutoId().setValue(withValues, withCompletionBlock: { (error, reference) in
						if error != nil {
							completion(false)
							return
						}
						
						let data : Dict = [DictKey.location: reference.parent!.key!]
						self.userRef.child(currentUserID).child(Path.Conversation).child(toID).updateChildValues(data)
						self.userRef.child(toID).child(Path.Conversation).child(currentUserID).updateChildValues(data)
						completion(true)
					})
				}
			})
		}
	}
	
	func markMessagesRead(forUserID: String)  {
		if let currentUserID = appDelegate.user?.uid {
			userRef.child(currentUserID).child(Path.Conversation).child(forUserID).observeSingleEvent(of: .value, with: { (snapshot) in
				if snapshot.exists() {
					let data = snapshot.value as! [String: String]
					let location = data[DictKey.location]!
					self.conversationRef.child(location).observeSingleEvent(of: .value, with: { (snap) in
						if snap.exists() {
							for (key,dict) in (snap.value as? Dict)!{
								guard let dic = dict as? Dict else {return}
								if dic[DictKey.fromID] as! String == forUserID {
									self.conversationRef
										.child(location)
										.child(key)
										.child(DictKey.isRead)
										.setValue(true)
								}
								
							}
						}
					})
				}
			})
		}
	}
}
