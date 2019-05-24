//
//  ForgetPasswordVC.swift
//  ANDemoChat
//
//  Created by Au Nguyen on 5/17/19.
//  Copyright © 2019 AuNguyen. All rights reserved.
//

import UIKit
import JVFloatLabeledTextField

class ForgetPasswordVC: BaseVC {
    @IBOutlet weak private var tf_Email: JVFloatLabeledTextField!
    @IBOutlet weak private var bt_Send: UIButton!
    var tfEmail: JVFloatLabeledTextField { return tf_Email }
    var viewModel: ForgetPasswordViewModel!
    var strEmail = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupUI()
    }
    
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		bt_Send.setCornerAndShadow()
	}

    // MARK: - Private methods
    
    private func setupUI() {
		self.title = Localize.locString(key: "lk_forgot_password")
        self.showNavibar()
        //Setup textfiled
        tf_Email.configUITextFiledWith(placeholderText: Localize.locString(key: "lk_email"))
        tf_Email.floatingLabel.addCharacterSpacing(kernValue: 0.22)
        bt_Send.setTitle(Localize.locString(key: "lk_Send"), for: .normal)
        bt_Send.setTitleColor(UIColor.white, for: .normal)
        bt_Send.titleLabel!.font = Fonts.Roboto.bold.toFontWith(size: 16.0)
        tf_Email.delegate = self
    }
    
    private func setupData() {
        viewModel = ForgetPasswordViewModel(vc: self)
    }
    
    // MARK: - Action
    
    @IBAction func bt_SendClicked(_ sender: Any) {
        if let validateString = viewModel.validateData(email: strEmail) {
            showAlertWithOneButton(title: Constants.WarningText, message: validateString, titleButton: Constants.OKText)
        } else {
            viewModel.doForgetPassword(email: strEmail)
        }
    }
}

extension ForgetPasswordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.bt_SendClicked(bt_Send)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let strText = textFieldText.replacingCharacters(in: range, with: string)
        
        strEmail = strText
        return true
    }
}
