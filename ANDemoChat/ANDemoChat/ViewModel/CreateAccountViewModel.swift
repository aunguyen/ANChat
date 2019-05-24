//
//  CreateAccountViewModel.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit

class CreateAccountViewModel: BaseVM{
    private func defaultValue(viewModelVC: CreateAccountVC) {
        viewModelVC.strEmail = ""
        viewModelVC.strPassword = ""
        viewModelVC.tfEmail.text = ""
        viewModelVC.tfPassword.text = ""
        viewModelVC.tfEmail.becomeFirstResponder()
    }
    
    func doRegister(fName:String, email:String, pass:String){
        let viewModelVC = vc as! CreateAccountVC
        viewModelVC.showProgress()
		fb.createUser(email: email, pass: pass) { (user, error) in
			viewModelVC.hideProgress()
			if let err = error {
				Utilities.showAlert(title: Localize.locString(key: "lk_Error"), msg: err.localizedDescription)
				return
			}
			guard let u = user else {
				Utilities.showAlert(title: Localize.locString(key: "lk_Error"), msg: Constants.LoginError.localizedDescription)
				return
			}
			u.username = fName
			appDelegate.user = u
			FirebaseHelper.shared.insertUserToDB(user: u, completion: { (success) in
				if success {
					//goto ChatList
					Utilities.saveValueToUDF(value: u.uid, key: DictKey.uid)
					guard let dest = UIStoryboard.vcFrom(storyboard: StoryBoardID.Chat, identifier: VCIdentifier.chatHistoryVC) as? ChatHistoryVC else { return }
					viewModelVC.goto(vc:dest)
				}else{
					Utilities.showAlert(title: Localize.locString(key: "lk_Error"), msg: Localize.locString(key: "lk_Create_User_Error"))
				}
			})
		}
    }
    
    func validateData(fName: String, email: String, pass: String) -> String? {
        if !fName.hasValue {
            return Localize.locString(key: "lk_please_enter_user_name")
        }else if !email.hasValue{
            return Localize.locString(key: "lk_please_enter_your_email")
        }else if !email.isEmail{
            return Localize.locString(key: "lk_invalid_email_address")
        }else if !pass.hasValue{
            return Localize.locString(key: "lk_please_enter_your_password")
        }
        return nil
    }
    
    func goToSignIn(){
		guard let dest = UIStoryboard.vcFrom(storyboard: StoryBoardID.Login, identifier: VCIdentifier.loginVC) as? LoginVC, let vc = self.vc else {return}
        vc.goto(vc: dest)
    }
}
