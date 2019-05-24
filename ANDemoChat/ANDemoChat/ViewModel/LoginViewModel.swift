//
//  LoginViewModel.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit

class LoginViewModel: BaseVM {
	func doLogin(email: String, pass: String) {
        let viewModelVC = vc as! LoginVC
        viewModelVC.showProgress()
		fb.loginWithEmail(email: email, pass: pass) { (user, error) in
			viewModelVC.hideProgress()
			if let err = error {
				Utilities.showAlert(title: Localize.locString(key: "lk_Error"), msg: err.localizedDescription)
				return
			}
			
			guard let _ = user else {
				Utilities.showAlert(title: Localize.locString(key: "lk_Error"), msg: Localize.locString(key: "lk_empty_response"))
				return
			}
			appDelegate.user = user
			FirebaseHelper.shared.setUserOnline()
			Utilities.saveValueToUDF(value: user!.uid, key: DictKey.uid)
			//goto app
			self.goToChatHistoryVC()
		}
	}
    
    func validateData(email:String, pass:String) -> String? {
        if !email.hasValue{
            return Localize.locString(key: "lk_please_enter_your_email")
        }else if !email.isEmail{
            return Localize.locString(key: "lk_invalid_email_address")
        }else if !pass.hasValue{
            return Localize.locString(key: "lk_please_enter_your_password")
        }
        return nil
    }
    
    func goToSignUp() {
        guard let dest = UIStoryboard.vcFrom(storyboard: StoryBoardID.Login, identifier: VCIdentifier.createAccountVC) as? CreateAccountVC, let vc = self.vc else {return}
        vc.goto(vc: dest)
    }
    
    func goToForgetPassword() {
        guard let dest = UIStoryboard.vcFrom(storyboard: StoryBoardID.Login, identifier: VCIdentifier.forgetPasswordVC) as? ForgetPasswordVC, let vc = self.vc else {return}
        vc.goto(vc: dest)
    }
	
	func goToChatHistoryVC() {
		guard let dest = UIStoryboard.vcFrom(storyboard: StoryBoardID.Chat, identifier: VCIdentifier.chatHistoryVC) as? ChatHistoryVC, let vc = self.vc else {return}
		vc.goto(vc: dest)
	}
}
