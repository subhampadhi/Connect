//
//  SignupVC.swift
//  Connect
//
//  Created by Subham Padhi on 21/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class SignupVC: UIViewController , UITextFieldDelegate {
    
    
    let userNameTextField:UITextField = {
        let u = UITextField()
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 18)! // Note the !
            ] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any]
        
        let attributedPlaceholder = NSAttributedString(string:"Name",attributes:attributes)
        u.attributedPlaceholder = attributedPlaceholder
        u.textColor = .black
        u.layer.borderWidth = 2
        u.layer.borderColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        u.setLeftPaddingPoints(10)
        return u
    }()
    
    let icon:UIImageView = {
        let l = UIImageView()
          l.image = #imageLiteral(resourceName: "ICON")
        l.contentMode = .scaleAspectFit
        l.layer.masksToBounds = true
        l.layer.cornerRadius = 20;
        return l
    }()
    
    let emailTextField:UITextField = {
        
        let u = UITextField()
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 18)! // Note the !
            ] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any]
        
        let attributedPlaceholder = NSAttributedString(string:"Email",attributes:attributes)
        u.attributedPlaceholder = attributedPlaceholder
        u.textColor = .black
        u.layer.borderWidth = 2
        u.layer.borderColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        u.setLeftPaddingPoints(10)
        return u
    }()
    
    let mobileTextField:UITextField = {
        let u = UITextField()
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 18)! // Note the !
            ] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any]
        
        let attributedPlaceholder = NSAttributedString(string:"Mobile Number",attributes:attributes)
        u.attributedPlaceholder = attributedPlaceholder
        u.textColor = .black
        u.layer.borderWidth = 2
        u.layer.borderColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        u.setLeftPaddingPoints(10)
        return u
    }()
    
    let passwordTextField:UITextField = {
        let u = UITextField()
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 18)! 
            ] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any]
        
        let attributedPlaceholder = NSAttributedString(string:"Password",attributes:attributes)
        u.attributedPlaceholder = attributedPlaceholder
        u.textColor = .black
        u.layer.borderWidth = 2
        u.layer.borderColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        u.setLeftPaddingPoints(10)
        u.isSecureTextEntry = true
        return u
    }()
    
    let confirmPasswordTextField:UITextField = {
        
        let u = UITextField()
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 18)! // Note the !
            ] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any]
        
        let attributedPlaceholder = NSAttributedString(string:"Confirm Password",attributes:attributes)
        u.attributedPlaceholder = attributedPlaceholder
        u.textColor = .black
        u.layer.borderWidth = 2
        u.layer.borderColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        u.setLeftPaddingPoints(10)
        u.isSecureTextEntry = true
        return u
    }()
    
    let haveAnAccountButton:UIButton = {
        let color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        let font = UIFont.systemFont(ofSize:14)
        let h = UIButton(type: .system);
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 14)! // Note the !
            ] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any]
        
        let attributedTitle = NSMutableAttributedString(string: "Already Have an account? ", attributes: attributes)
        h.setAttributedTitle(attributedTitle, for: .normal);
        h.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let attributes1 = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 14)! // Note the !
            ] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any]
        
        attributedTitle.append(NSAttributedString(string:"Sign In",attributes:attributes1))
        h.addTarget(self, action: #selector(signinAction), for: .touchUpInside)
        h.setAttributedTitle(attributedTitle, for: .normal)
        return h
    }()
    
    let registerButton:UIButton = {
        
        let r = UIButton(type: .system)
        r.setTitleColor(.black, for: .normal)
        r.setTitle("Register", for: .normal)
        r.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        r.layer.cornerRadius = 20
        r.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
        return r
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.isNavigationBarHidden = true
       // setupAddLogo()
        setuphaveAccountButton()
        setuptextfieldComponents()
        setupRegisterButton()
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        confirmPasswordTextField.delegate = self
        mobileTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder();
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func signinAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setuphaveAccountButton(){
        view.addSubview(haveAnAccountButton)
        if #available(iOS 11.0, *) {
            haveAnAccountButton.anchors(top: nil, topPad: 0, bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomPad: 8, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, height: 20, width: 0)
        } else {
            haveAnAccountButton.anchors(top: nil, topPad: 0, bottom: view.bottomAnchor, bottomPad: 8, left: view.leftAnchor, leftPad: 0, right: view.rightAnchor, rightPad: 0, height: 20, width: 0)
        };
    }
    
    fileprivate func setuptextfieldComponents(){
        
        setupMobileNumberField()
        setupPasswordField()
        setupUserNameField()
        setupEmailField()
        setupConfirmPasswordField()
    }
    
    func setupAddLogo(){
        view.addSubview(icon)
        if #available(iOS 11.0, *) {
            icon.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, height: 150, width: 150)
        } else {
            icon.anchors(top: view.topAnchor, topPad: 10, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, height: 150, width: 150)
        }
        icon.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive=true
    }
    
    fileprivate func setupMobileNumberField(){
        view.addSubview(mobileTextField)
        mobileTextField.translatesAutoresizingMaskIntoConstraints = false
        mobileTextField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true;
        mobileTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true;
        mobileTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true;
        mobileTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        mobileTextField.layer.cornerRadius = 20

    }
    
    fileprivate func setupPasswordField(){
        view.addSubview(passwordTextField)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.topAnchor.constraint(equalTo: mobileTextField.bottomAnchor, constant: 30).isActive = true;
        passwordTextField.leftAnchor.constraint(equalTo: mobileTextField.leftAnchor, constant: 0).isActive = true;
        passwordTextField.rightAnchor.constraint(equalTo: mobileTextField.rightAnchor, constant: 0).isActive = true;
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordTextField.layer.cornerRadius = 20

    }
    
    fileprivate func setupUserNameField(){
        view.addSubview(userNameTextField)
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false;
        userNameTextField.bottomAnchor.constraint(equalTo: mobileTextField.topAnchor, constant: -30).isActive = true;
        userNameTextField.leftAnchor.constraint(equalTo: mobileTextField.leftAnchor, constant: 0).isActive = true;
        userNameTextField.rightAnchor.constraint(equalTo:  mobileTextField.rightAnchor, constant: 0).isActive = true;
        userNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        userNameTextField.layer.cornerRadius = 20
    }
    
    fileprivate func setupConfirmPasswordField(){
        view.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false;
        confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30).isActive = true;
        confirmPasswordTextField.leftAnchor.constraint(equalTo:  passwordTextField.leftAnchor, constant: 0).isActive = true;
        confirmPasswordTextField.rightAnchor.constraint(equalTo:  passwordTextField.rightAnchor, constant: 0).isActive = true;
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        confirmPasswordTextField.layer.cornerRadius = 20
    }
    
    fileprivate func setupEmailField(){
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false;
        emailTextField.bottomAnchor.constraint(equalTo: userNameTextField.topAnchor, constant: -30).isActive = true;
        emailTextField.leftAnchor.constraint(equalTo: userNameTextField.leftAnchor, constant: 0).isActive = true;
        emailTextField.rightAnchor.constraint(equalTo: userNameTextField.rightAnchor, constant: 0).isActive = true;
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        emailTextField.layer.cornerRadius = 20
    }
    
    fileprivate func setupRegisterButton(){
        view.addSubview(registerButton)
        registerButton.translatesAutoresizingMaskIntoConstraints = false;
        registerButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant:30).isActive = true;
        registerButton.leftAnchor.constraint(equalTo: confirmPasswordTextField.leftAnchor, constant: 0).isActive = true;
        registerButton.rightAnchor.constraint(equalTo: confirmPasswordTextField.rightAnchor, constant: 0).isActive = true;
        registerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    @objc func signupAction() {
        guard let email = emailTextField.text , let password = passwordTextField.text , let username =  userNameTextField.text , let mobileNumber = mobileTextField.text else {
            print("Issue !!")
            return
        }
        print(email)
        print(password)
        Auth.auth().createUser(withEmail: email   , password: password) { authResult, error in
            
            if error != nil {
                print("error occured!")
                print(error)
                return
            }else {
                let ref = Database.database().reference()
        
                guard let userID = Auth.auth().currentUser?.uid else {return}

                let userRefrence = ref.child("users").child(userID)
                let values = ["name": username , "email": email , "phone": mobileNumber]
                userRefrence.updateChildValues(values, withCompletionBlock: { (err, ref) in
                    
                    if err != nil {
                        print(err)
                        return
                    }else {
                        self.dismiss(animated: true, completion: nil)
                        print("Saved user into db")
                    }
                    
                })
                
                
            }
        }
    }
    
    
}

extension UITextField {
    
    func setBottomBorder(backGroundColor: UIColor, borderColor: UIColor) {
        self.layer.backgroundColor = backGroundColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
        self.layer.shadowColor = borderColor.cgColor
    }
}
