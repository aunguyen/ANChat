//
//  ContactListVC.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/18/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit

class ContactListVC: BaseVC {
	
	@IBOutlet weak private var textField: UITextField!
	@IBOutlet weak private var tableView: UITableView!
	var viewmodel: ContactViewModel!
	
	
	//MARK: - Life cycle
	override func viewDidLoad() {
        super.viewDidLoad()
		self.title = "Contacts"
		self.setNaviLeftBtn(image: #imageLiteral(resourceName: "ic_back"), title: "", handler: #selector(goBack))
		viewmodel = ContactViewModel(vc: self)
		viewmodel.getListContact()
		self.textField.delegate = self
		self.textField.setLeftPaddingPoints(20)
    }
	
	@objc func goBack(){
		self.popViewController()
	}
	
	func reloadData(){
		self.tableView.reloadData()
	}

	@IBAction func textChanged(_ sender: UITextField) {
		viewmodel.filterUserWithName(name: sender.text ?? "")
	}
}

extension ContactListVC: UITextFieldDelegate{
	func textFieldDidEndEditing(_ textField: UITextField) {
		viewmodel.filterUserWithName(name: textField.text ?? "")
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
}

extension ContactListVC: UITableViewDelegate, UITableViewDataSource{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return viewmodel.contactArr.count
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 80.0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: CellID.ContactCell) as? ContactCell{
			cell.contact = viewmodel.contactArr[indexPath.row]
			return cell
		}
		return UITableViewCell()
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewmodel.startChatWithUser(user: viewmodel.contactArr[indexPath.row])
	}
}
