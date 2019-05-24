//
//  ForgetPasswordViewModel.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit

class ForgetPasswordViewModel: BaseVM {
    func doForgetPassword(email:String){
        let viewModelVC = vc as! ForgetPasswordVC
        viewModelVC.showProgress()
        
        
    }
    
    func validateData(email: String) -> String? {
        if !email.hasValue{
            return Localize.locString(key: "lk_please_enter_your_email")
        }else if !email.isEmail{
            return Localize.locString(key: "lk_invalid_email_address")
        }
        return nil
    }
}
