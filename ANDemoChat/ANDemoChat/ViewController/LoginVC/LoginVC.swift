//
//  LoginVC.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class LoginVC: BaseVC {
    @IBOutlet weak private var tf_Email: JVFloatLabeledTextField!
    @IBOutlet weak private var tf_Password: JVFloatLabeledTextField!
    
    @IBOutlet weak private var bt_Signup: UIButton!
    @IBOutlet weak private var bt_LogIn: UIButton!
    @IBOutlet weak private var bt_ForgetPassword: UIButton!
    
	
    let kPlaceholdersText = ["lk_email","lk_paswword"]
    var tfArray : [JVFloatLabeledTextField] = []
    var viewModel: LoginViewModel!
    
    var strEmail = ""
    var strPassword = ""
    
    // MARK: - Life cyle
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.hideNavibar()
		guard let storedUID = Utilities.getValueFromUDF(key: DictKey.uid) as? String, storedUID.count > 0 else {return}
		Utilities.showLoading()
		FirebaseHelper.shared.getUserByID(uid: storedUID) { (user, err) in
			Utilities.hideLoading()
			if let error = err {
				Utilities.showAlert(title: Constants.ErrorText, msg: error.localizedDescription)
				return
			}
			appDelegate.user = user
			FirebaseHelper.shared.userRef.child(storedUID).child(DictKey.online).setValue(true)
			self.viewModel.goToChatHistoryVC()
		}
	}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		self.bt_LogIn.setCornerAndShadow()
	}
	
    // MARK: - Private methods
    
    private func setupUI() {
        //Setup textfiled
        tfArray = [tf_Email,tf_Password]
        for (i,tf) in tfArray.enumerated(){
            let placeHolderText = Localize.locString(key: kPlaceholdersText[i])
            tf.configUITextFiledWith(placeholderText: placeHolderText)
            tf.floatingLabel.addCharacterSpacing(kernValue: 0.22)
        }
        
        bt_ForgetPassword.setTitle(Localize.locString(key: "lk_forgot_password"), for: .normal)
        bt_ForgetPassword.setTitleColor(kColor969696, for: .normal)
        bt_ForgetPassword.titleLabel!.font = Fonts.Roboto.bold.toFontWith(size: 15.0)
        bt_ForgetPassword.titleLabel?.addCharacterSpacing(kernValue: 0.5)
        
        bt_LogIn.setTitle(Localize.locString(key: "lk_login"), for: .normal)
        bt_LogIn.setTitleColor(UIColor.white, for: .normal)
        bt_LogIn.titleLabel!.font = Fonts.Roboto.bold.toFontWith(size: 15.0)
        bt_LogIn.titleLabel?.addCharacterSpacing(kernValue: 0.5)
        bt_Signup.setTitle(Localize.locString(key: "lk_do_not_have_an_account"), for: .normal)
		
        bt_Signup.setTitleColor(UIColor.black, for: .normal)
        bt_Signup.titleLabel!.font = Fonts.Roboto.regular.toFontWith(size: 16.0)
        bt_Signup.titleLabel?.addCharacterSpacing(kernValue: 0.3)
        bt_Signup.titleLabel!.setHighlightText(fullString: Localize.locString(key: "lk_do_not_have_an_account"), hightLightString: Localize.locString(key: "lk_create_account"), hightLightColor: kColor32A8A8, hightLightFont: Fonts.Roboto.medium.toFontWith(size: 16.0)!)
        
        tf_Email.delegate = self
        tf_Password.delegate = self
    }
    
    private func setupData() {
        viewModel = LoginViewModel(vc: self)
    }
    
    // MARK: - Public methods
    func defaultValue() {
        strEmail = ""
        strPassword = ""
        
        tf_Email.text = ""
        tf_Password.text = ""
    }
    
    // MARK: - Action
    
    @IBAction func bt_LogInClicked(_ sender: Any) {
        if let validateString = viewModel.validateData(email: strEmail, pass: strPassword) {
            showAlertWithOneButton(title: Constants.WarningText, message: validateString, titleButton: Constants.OKText)
        } else {
            viewModel.doLogin(email: strEmail, pass: strPassword)
        }
    }
    
    @IBAction func bt_SignupClicked(_ sender: Any) {
        viewModel.goToSignUp()
    }
    
    @IBAction func bt_ForgetPasswordClicked(_ sender: Any) {
       viewModel.goToForgetPassword()
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(tf_Email) {
            tf_Password.becomeFirstResponder()
        } else if textField.isEqual(tf_Password) {
            self.bt_LogInClicked(bt_LogIn)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let strText = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField.isEqual(tf_Email) {
            strEmail = strText
        }
        if textField.isEqual(tf_Password) {
            strPassword = strText
        }
        return true
    }
}
