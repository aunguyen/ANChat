//
//  CreateAccountVC.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class CreateAccountVC: BaseVC {
    @IBOutlet weak private var tf_FirstName: JVFloatLabeledTextField!
    @IBOutlet weak private var tf_Email: JVFloatLabeledTextField!
    @IBOutlet weak private var tf_Password: JVFloatLabeledTextField!
    
    @IBOutlet weak private var bt_Submit: UIButton!
    @IBOutlet weak private var bt_LogIn: UIButton!
    
    var tfEmail: JVFloatLabeledTextField { return tf_Email }
    var tfPassword: JVFloatLabeledTextField { return tf_Password }
    
    private let kPlaceholdersText = ["lk_user_name","lk_email","lk_paswword"]
    
    var tfArray : [JVFloatLabeledTextField] = []
    var viewModel: CreateAccountViewModel!
    
    var strFirstName = ""
    var strEmail = ""
    var strPassword = ""
    
    // MARK: - Life cyle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		bt_Submit.setCornerAndShadow()
	}

    // MARK: - Private methods
    
    private func setupUI() {
		self.title = Localize.locString(key: "lk_create_account")
		self.showNavibar()
        //Setup textfiled
        tfArray = [tf_FirstName,tf_Email,tf_Password]
        for (i,tf) in tfArray.enumerated(){
            let placeHolderText = Localize.locString(key: kPlaceholdersText[i])
            tf.configUITextFiledWith(placeholderText: placeHolderText)
        }
        
        bt_Submit.setTitle(Localize.locString(key: "lk_Submit"), for: .normal)
        bt_Submit.setTitleColor(UIColor.white, for: .normal)
        bt_Submit.titleLabel!.font = Fonts.Roboto.bold.toFontWith(size: 15.0)
        bt_LogIn.setTitle(Localize.locString(key: "lk_already_have_an_account"), for: .normal)
        bt_LogIn.setTitleColor(UIColor.black, for: .normal)
        bt_LogIn.titleLabel!.font = Fonts.Roboto.regular.toFontWith(size: 16.0)
        bt_LogIn.titleLabel!.setHighlightText(fullString: Localize.locString(key: "lk_already_have_an_account"), hightLightString: Localize.locString(key: "lk_login"), hightLightColor: kColor32A8A8, hightLightFont: Fonts.Roboto.medium.toFontWith(size: 16.0))
        tf_FirstName.delegate = self
        tf_Email.delegate = self
        tf_Password.delegate = self
    }
    
    private func setupData() {
        viewModel = CreateAccountViewModel(vc: self)
    }

    // MARK: - Public methods
    
    func defaultValue() {
        strFirstName = ""
        strEmail = ""
        strPassword = ""
        
        tf_FirstName.text = ""
        tf_Email.text = ""
        tf_Password.text = ""
    }
    
    // MARK: - Action
    
    @IBAction func bt_SubmitClicked(_ sender: Any) {
        if let validateString = viewModel.validateData(fName: strFirstName, email: strEmail, pass: strPassword) {
            showAlertWithOneButton(title: Constants.WarningText, message: validateString, titleButton: Constants.OKText)
        } else {
            viewModel.doRegister(fName: strFirstName, email: strEmail, pass: strPassword)
        }
    }
    
    @IBAction func bt_LogInClicked(_ sender: Any) {
        viewModel.goToSignIn()
    }
}

extension CreateAccountVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.isEqual(tf_FirstName) {
            tf_Email.becomeFirstResponder()
        } else if textField.isEqual(tf_Email) {
            tf_Password.becomeFirstResponder()
        } else if textField.isEqual(tf_Password) {
            self.bt_SubmitClicked(bt_Submit)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let strText = textFieldText.replacingCharacters(in: range, with: string)
        
        if textField.isEqual(tf_FirstName) {
            strFirstName = strText
        }
        if textField.isEqual(tf_Email) {
            strEmail = strText
        }
        if textField.isEqual(tf_Password) {
            strPassword = strText
        }
        return true
    }
}
