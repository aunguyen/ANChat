//
//  AppDelegate.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	var user: UserObj?
	var isInChat: Bool = false
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		setupRootView()
		setupDefaultNavi()
		FirebaseApp.configure()
		Database.database().isPersistenceEnabled = true
		self.observeInternet()
		IQKeyboardManager.shared.enable = true
		IQKeyboardManager.shared.keyboardDistanceFromTextField = 8
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
		
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
		
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		
	}

	func applicationWillTerminate(_ application: UIApplication) {
		FirebaseHelper.shared.setUserOffline()
		
	}
}

extension AppDelegate{
	func setupRootView(){
		let loginVC = UIStoryboard.vcFrom(storyboard: StoryBoardID.Login, identifier:nil) as? LoginVC
		let navi = UINavigationController(rootViewController:loginVC!)
		navi.isNavigationBarHidden = true
		self.window?.rootViewController = navi
	}
	
	func setupDefaultNavi(){
		UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
		UINavigationBar.appearance().tintColor = .white
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
		UINavigationBar.appearance().isTranslucent = false
	}
	
	func observeInternet(){
		let connectedRef = Database.database().reference(withPath: ".info/connected")
		connectedRef.observe(.value, with: { snapshot in
			if let isOnline = snapshot.value as? Bool {
				if isOnline {
					Utilities.postNoti(name: NotificationName.reloadData)
				}
			} else {
			}
		})
	}
}

