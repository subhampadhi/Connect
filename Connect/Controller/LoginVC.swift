//
//  LoginVC.swift
//  Connect
//
//  Created by Subham Padhi on 21/02/19.
//  Copyright © 2019 Subham Padhi. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController ,UITextFieldDelegate {
    
    let emailTextField:UITextField = {
        let e = UITextField()
        e.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        let centeredParagraphStyle = NSMutableParagraphStyle()
        centeredParagraphStyle.alignment = .left
        let attributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 17)! // Note the !
            ] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any]
        e.attributedPlaceholder = NSAttributedString(string: "Email",
                                                     attributes: attributes)
        e.layer.borderColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        e.layer.borderWidth = 2
        e.textAlignment = .left
        e.setLeftPaddingPoints(10)
        return e
    }()
    
    var signInlabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "L O G I N"
        view.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        view.font = UIFont(name: "IBMPlexSans-BoldItalic", size: 20)
        view.textAlignment = .center
        return view
    }()
    
    let icon:UIImageView = {
        let l = UIImageView()
          l.image = #imageLiteral(resourceName: "ICON")
        l.contentMode = .scaleAspectFit
        l.layer.masksToBounds = true
        l.layer.cornerRadius = 20
        return l
    }()
    
    let passwordTextField:UITextField = {
        let p = UITextField()
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 17)!
            ] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any]
        
        p.attributedPlaceholder = NSAttributedString(string: "Password", attributes: attributes)
        p.keyboardType = .emailAddress
        p.layer.borderColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        p.layer.borderWidth = 2
        p.textAlignment = .left
        p.setLeftPaddingPoints(10)
        p.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        p.isSecureTextEntry = true
        return p
    }()
    
    let loginbutton:UIButton = {
        let l = UIButton(type: .system)
        l.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        l.setTitle("Log In", for: .normal)
        l.backgroundColor = #colorLiteral(red: 0.4078431373, green: 0.1176470588, blue: 0.4392156863, alpha: 1)
        l.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return l
    }()
    
    let forgotPasswordbutton:UIButton = {
        let f = UIButton(type: .system);
        f.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal);
        f.setTitle("Forgot Password?", for: .normal);
        f.titleLabel?.font = UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 14)!
        return f
    }()
    
    let haveAnAccountButton:UIButton = {
        let color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        let font = UIFont.systemFont(ofSize:14)
        let h = UIButton(type: .system)
        let attributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "IBMPlexSans-SemiBoldItalic", size: 14)! // Note the !
            ] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any]
        
        
        let attributedTitle = NSMutableAttributedString(string: "Don't Have an account? ", attributes: attributes)
        h.setAttributedTitle(attributedTitle, for: .normal);
        
        let signUpAttributes = [
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "IBMPlexSans-BoldItalic", size: 14)! // Note the !
            ] as [NSAttributedString.Key : Any] as [NSAttributedString.Key : Any]
        
        attributedTitle.append(NSAttributedString(string:"Sign Up",attributes:signUpAttributes))
        h.addTarget(self, action: #selector(signupAction), for: .touchUpInside)
        h.setAttributedTitle(attributedTitle, for: .normal)
        return h
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setupAddLogo()
        setupTextFieldComponents()
        setupLoginButton()
        setupForgotPasswordButton()
        setuphaveAnAccountbutton()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func setupTextFieldComponents(){
        setupEmailField()
        setupPasswordField()
    }
    
    func setupAddLogo(){
        view.addSubview(icon)
        view.addSubview(signInlabel)
        if #available(iOS 11.0, *) {
            icon.anchors(top: view.safeAreaLayoutGuide.topAnchor, topPad: 40, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, height: 150, width: 150)
        } else {
            icon.anchors(top: view.topAnchor, topPad: 40, bottom: nil, bottomPad: 0, left: nil, leftPad: 0, right: nil, rightPad: 0, height: 150, width: 150)
        }
        icon.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive=true
        
        signInlabel.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 20).isActive = true
        signInlabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        signInlabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
    }
    
    func setupEmailField(){
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.topAnchor.constraint(equalTo: signInlabel.bottomAnchor, constant: 10).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        emailTextField.layer.cornerRadius = 20
    }
    
    func setupPasswordField(){
        view.addSubview(passwordTextField);
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false;
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive=true;
        passwordTextField.leftAnchor.constraint(equalTo: emailTextField.leftAnchor, constant:0).isActive=true;
        passwordTextField.rightAnchor.constraint(equalTo: emailTextField.rightAnchor, constant: 0).isActive = true;
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true;
        passwordTextField.layer.cornerRadius = 20
    }
    
    func setupLoginButton(){
        view.addSubview(loginbutton)
        loginbutton.translatesAutoresizingMaskIntoConstraints = false;
        loginbutton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 12).isActive = true;
        loginbutton.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor, constant: 0).isActive = true;
        loginbutton.rightAnchor.constraint(equalTo: passwordTextField.rightAnchor, constant: 0).isActive = true;
        loginbutton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        loginbutton.layer.cornerRadius = 20
    }
    
    func setupForgotPasswordButton(){
        view.addSubview(forgotPasswordbutton)
        forgotPasswordbutton.translatesAutoresizingMaskIntoConstraints = false;
        forgotPasswordbutton.topAnchor.constraint(equalTo: loginbutton.bottomAnchor, constant: 8).isActive = true;
        forgotPasswordbutton.leftAnchor.constraint(equalTo: loginbutton.leftAnchor, constant: 0).isActive = true;
        forgotPasswordbutton.rightAnchor.constraint(equalTo: loginbutton.rightAnchor, constant: 0).isActive = true;
        forgotPasswordbutton.heightAnchor.constraint(equalToConstant: 30).isActive = true;
    }
    
    func setuphaveAnAccountbutton(){
        view.addSubview(haveAnAccountButton)
        haveAnAccountButton.translatesAutoresizingMaskIntoConstraints = false
        if #available(iOS 11.0, *) {
            haveAnAccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        } else {
            haveAnAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        }
        haveAnAccountButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 12).isActive = true
        haveAnAccountButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -12).isActive = true
        haveAnAccountButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    @objc func signupAction(){
        
        let vc = SignupVC()
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func loginAction(){
        
        guard let email = emailTextField.text , let password = passwordTextField.text else {
            Utils.showAlert(title:"Oops", message: "Please don't leave any field blank", presenter: self)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                Utils.showAlert(title:"Oops", message: "\((error)!)", presenter: self)
            }
            else{
                print("Login Success")
                UserDefaults.standard.set(true, forKey: "Login")
                let controller = TabBarController()
                guard let window = UIApplication.shared.keyWindow else {
                    return
                }
                window.rootViewController = controller
            }
        }
    }
    
}


extension UITextField {
    func setPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.width - 4))
        self.leftView = paddingView
        
        self.leftViewMode = .always
    }
    
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 0.0
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}


extension String {
    func attributedStringOne(aligment: NSTextAlignment) -> NSAttributedString {
        return NSAttributedString(text: self, aligment: aligment)
    }
}

extension NSAttributedString {
    convenience init(text: String, aligment: NSTextAlignment) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = aligment
        self.init(string: text, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle])
    }
}

extension UIView{
    func anchors(top: NSLayoutYAxisAnchor?, topPad: CGFloat, bottom: NSLayoutYAxisAnchor?, bottomPad: CGFloat,
                 left: NSLayoutXAxisAnchor?, leftPad: CGFloat, right: NSLayoutXAxisAnchor?, rightPad: CGFloat,
                 height: CGFloat, width: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: topPad).isActive = true
        }
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomPad).isActive = true
        }
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: leftPad).isActive = true
        }
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -rightPad).isActive = true
        }
        if height > 0 { self.heightAnchor.constraint(equalToConstant: height).isActive = true }
        if width > 0 { self.widthAnchor.constraint(equalToConstant: width).isActive = true }
    }
}

