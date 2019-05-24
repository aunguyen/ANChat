//
//  BaseVC.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseVC: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	// MARK: - Other methods
	
	func showNavibar() {
		self.navigationController?.isNavigationBarHidden = false
	}
	
	func hideNavibar() {
		self.navigationController?.isNavigationBarHidden = true
	}
	
	func registerCell(id:String,for table:UITableView) {
		table.register(UINib(nibName:id, bundle: nil), forCellReuseIdentifier: id)
	}
	
	// MARK: - Alert
	
	func showAlertWithOneButton(title: String?, message: String?, titleButton: String, handler: ((UIAlertAction) -> Void)? = nil) {
		let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: titleButton, style: UIAlertAction.Style.default, handler: handler))
		self.present(alert, animated: true, completion: nil)
	}
	
	func showSharePopup(){
		let firstActivityItem = "Share file, url, string..."
		
		let activityViewController : UIActivityViewController = UIActivityViewController(
			activityItems: [firstActivityItem], applicationActivities: nil)
		
		activityViewController.excludedActivityTypes = []
		activityViewController.completionWithItemsHandler = { (type,complete,items,error) in
		}
		self.present(activityViewController, animated: true, completion: nil)
	}
	
	// MARK: - Indicator
	
	func showProgress() {
		MBProgressHUD.showAdded(to: view, animated: true)
	}
	
	func hideProgress() {
		MBProgressHUD.hide(for: view, animated: true)
	}

}
