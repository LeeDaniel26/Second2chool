//
//  ViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/02/20.
//

import UIKit
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var autologinLabel: UILabel!
    @IBOutlet weak var forgotButton: UIButton!
    @IBOutlet weak var nonmemberButton: UIButton!
    @IBOutlet weak var dontAccountButton: UIButton!
    @IBOutlet weak var barLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!

    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginLabel.adjustsFontSizeToFitWidth = true
        autologinLabel.adjustsFontSizeToFitWidth = true
        forgotButton.titleLabel!.adjustsFontSizeToFitWidth = true
        nonmemberButton.titleLabel!.adjustsFontSizeToFitWidth = true
        dontAccountButton.titleLabel!.adjustsFontSizeToFitWidth = true
        barLabel.adjustsFontSizeToFitWidth = true
        signupButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        setTextFieldLayer()
        loginButton.layer.cornerRadius = 21
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
    // GoogleSignIn Button
        let googleLoginButton = GIDSignInButton(frame: CGRect(x: loginButton.frame.origin.x, y: 100, width: loginButton.frame.width, height: loginButton.frame.height))
        self.view.addSubview(googleLoginButton)
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        
        // 'SafeAreaLayoutGuide' was intoduced in iOS 11 and above. iOS versions prior to 11, 'TopLayoutGuide' was used.
//        let googleLoginButtonTopAnchorConstant: CGFloat = 236
//        if #available(iOS 11, *) {
//            let guide = self.view.safeAreaLayoutGuide
//            NSLayoutConstraint.activate([
//                googleLoginButton.topAnchor.constraint(equalTo: guide.topAnchor, constant: googleLoginButtonTopAnchorConstant)
//            ])
//        } else {
//            let standardSpacing: CGFloat = googleLoginButtonTopAnchorConstant + topLayoutGuide.length
//            NSLayoutConstraint.activate([
//                googleLoginButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: standardSpacing)
//            ])
//        }
        googleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45).isActive = true
        googleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45).isActive = true
        googleLoginButton.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 50).isActive = true
//            googleLoginButton.bottomAnchor.constraint(equalTo: forgotButton.topAnchor, constant: 12).isActive = true
        googleLoginButton.heightAnchor.constraint(equalToConstant: loginButton.frame.height).isActive = true
            
        googleLoginButton.addTarget(self, action: #selector(googleLogIn), for: .touchUpInside)
    // ---------------
        
    }
    
    
    @objc func googleLogIn() {
        let config = GIDConfiguration.init(clientID: "561227145439-e1uhpali8spt5u0bl3dp6oj5lrnfq39u.apps.googleusercontent.com")
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [weak self] user, error in
            if let error = error {
                print(error)
                return
            }
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken else { return }
            guard
                let email = user?.profile?.email,
                let firstName = user?.profile?.givenName,
                let lastName = user?.profile?.familyName else { return }
            
            print(email)
            print(firstName)
            print(lastName)
            print(idToken)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let loginManager = LoginManager.loginData
        loginManager.email = emailTextField.text!
        loginManager.password = passwordTextField.text!
        loginManager.postRequest()
        
//        let homeVC = HomeViewController()
//        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        googleLogIn()
    }
    
    func setTextFieldLayer() {
        
//        for i in 0..<loginTextField.count {
//            loginTextField[i].layer.cornerRadius = 80
//        }
//        //loginInfoStackView.customize(radiusSize: 50)
    }
}

//MARK: - UITextField Delegate

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
