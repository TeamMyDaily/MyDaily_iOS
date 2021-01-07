//
//  RegisterVC.swift
//  Mydaily_iOS
//
//  Created by 이유진 on 2021/01/03.
//

import UIKit

class RegisterVC: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var checkpwTextField: UITextField!
    @IBOutlet weak var validateEmailLabel: UILabel!
    @IBOutlet weak var validatePWLabel: UILabel!
    @IBOutlet weak var checkPWLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var checkValidate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        changeTextFields()
        setUI()
    }
    @IBAction func pwButton(_ sender: Any) {
        securityText(textfield: pwTextField)
    }
    @IBAction func checkpwButton(_ sender: Any) {
        securityText(textfield: checkpwTextField)
    }
}

//MARK: - UI
extension RegisterVC {
    func setUI() {
        nextButton.isEnabled = false
        pwTextField.isSecureTextEntry = true
        checkpwTextField.isSecureTextEntry = true
    }
    
    private func setupNavigationBar() {
        guard let navigationBar = self.navigationController?.navigationBar else { return }
        
        navigationBar.isTranslucent = true
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationBar.shadowImage = UIImage()
        
        self.navigationItem.title = "회원가입"
        
//        let leftButton: UIBarButtonItem = {
//            let button = UIBarButtonItem(image: UIImage(named: "backArrowIc"), style: .plain, target: self, action: #selector(dismissVC))
//            return button
//        }()
//
//        navigationItem.leftBarButtonItem = leftButton
//    }
//
//    @objc
//    func dismissVC() {
//        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - TextField,Button
extension RegisterVC {
    private func changeTextFields() {
        nameTextField.addTarget(self, action: #selector(changeNameTextFieldUI), for: .allEditingEvents)
        emailTextField.addTarget(self, action: #selector(changeEmailTextfiledUI), for: .allEditingEvents)
        pwTextField.addTarget(self, action: #selector(changePWTextfiledUI), for: .allEditingEvents)
        checkpwTextField.addTarget(self, action: #selector(checkPWTextfiledUI), for: .allEditingEvents)
    }
    
    @objc
    func changeNameTextFieldUI(){
        changeTextfieldUI(textfield: nameTextField)
        checkValidateUI()
    }
    
    @objc
    func changeEmailTextfiledUI(){
        changeTextfieldUI(textfield: emailTextField)
        
        if !(emailTextField.text!.validateEmail()) {
            validateEmailLabel.text = "사용 불가능한 이메일이에요!"
        }
        else{
            validateEmailLabel.text = ""
        }
        checkValidateUI()
    }
    
    @objc
    func changePWTextfiledUI(){
        changeTextfieldUI(textfield: pwTextField)
        
        if !(pwTextField.text!.validatePassword()) {
            validatePWLabel.text = "영어와 숫자 조합으로 6자리 이상 입력해 주세요!"
        }
        else{
            if !(pwTextField.text == checkpwTextField.text) {
                checkPWLabel.text = "비밀번호가 서로 맞지 않아요!"
            }
            else{
                checkPWLabel.text = ""
            }

            validatePWLabel.text = ""
        }
        checkValidateUI()
    }
    
    @objc
    func checkPWTextfiledUI(){
        changeTextfieldUI(textfield: checkpwTextField)
        
        if !(pwTextField.text == checkpwTextField.text) {
            checkPWLabel.text = "비밀번호가 서로 맞지 않아요!"
        }
        else{
            checkPWLabel.text = ""
        }
        checkValidateUI()
    }
    
    func changeTextfieldUI(textfield: UITextField){
        if !(textfield.text!.isEmpty){
            textfield.backgroundColor = .white
            textfield.layer.borderColor = UIColor.red.cgColor
            textfield.layer.borderWidth = 1.5
        }
        else{
            textfield.layer.borderColor = UIColor.gray.cgColor
        }
    }
    
    func checkValidateUI(){
        if (pwTextField.text == checkpwTextField.text) && (emailTextField.text!.validateEmail()) && (pwTextField.text!.validatePassword()){
            checkValidate = true
        }
        else{
            checkValidate = false
        }
        
        if !(nameTextField.text!.isEmpty) && !(emailTextField.text!.isEmpty) && !(pwTextField.text!.isEmpty) && !(checkpwTextField.text!.isEmpty) && checkValidate{
            nextButton.isEnabled = true
        }
        else{
            nextButton.isEnabled = false
        }
    }
    
    func securityText(textfield: UITextField){
        if textfield.isSecureTextEntry == true {
            textfield.isSecureTextEntry = false
        }
        else{
            textfield.isSecureTextEntry = true
        }
    }
}

//MARK: - String
extension String {
    // E-mail address validation
//    public func validateEmail() -> Bool {
//        let emailRegEx = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
//        
//        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
//        return predicate.evaluate(with: self)
//    }
    
    // Password validation
    public func validatePassword() -> Bool {
        let passwordRegEx = "^(?=.*[0-9])(?=.*[a-z]).{6,100}$"
        
        let predicate = NSPredicate(format:"SELF MATCHES %@", passwordRegEx)
        return predicate.evaluate(with: self)
    }
}
