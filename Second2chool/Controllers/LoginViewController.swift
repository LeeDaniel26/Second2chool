//
//  ViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/02/20.
//

import GoogleSignIn
import Firebase
import UIKit

class LoginViewController: UIViewController {

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
        
        navigationItem.hidesBackButton = true
        
        // (Mock)
        emailTextField.text = "g@test.com"
        passwordTextField.text = "g"
        
        loginLabel.adjustsFontSizeToFitWidth = true
        autologinLabel.adjustsFontSizeToFitWidth = true
        forgotButton.titleLabel!.adjustsFontSizeToFitWidth = true
        nonmemberButton.titleLabel!.adjustsFontSizeToFitWidth = true
        dontAccountButton.titleLabel!.adjustsFontSizeToFitWidth = true
        barLabel.adjustsFontSizeToFitWidth = true
        signupButton.titleLabel!.adjustsFontSizeToFitWidth = true
        
        setTextFieldLayer()
        loginButton.layer.cornerRadius = 21
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
        // GoogleSignIn Button
        let googleLoginButton = GIDSignInButton()
        googleLoginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(googleLoginButton)
        
        NSLayoutConstraint.activate([
            googleLoginButton.heightAnchor.constraint(equalToConstant: loginButton.frame.height),
            googleLoginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            googleLoginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            googleLoginButton.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 50),
        ])
        googleLoginButton.addTarget(self, action: #selector(googleLogIn), for: .touchUpInside)
    }
    
    @objc func googleLogIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { user, error in
            guard error == nil else { return }
            
            // 인증을 해도 계정은 따로 등록을 해주어야 한다.
            // 구글 인증 토큰 받아서 -> 사용자 정보 토큰 생성 -> 파이어베이스 인증에 등록
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            // 사용자 정보 등록
            Auth.auth().signIn(with: credential) { _, _ in
                // 사용자 등록 후에 처리할 코드
            }
            print("$$$$$$$$$$ idToken: \(idToken)")
            LoginManager.shared.postGoogleSignIn(
                signinType: "LogIn",
                nickname: nil,
                tokenString: idToken,
                clientId: clientID) { decodedData in
                    if decodedData.status == "fail" {
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "LoginToSignup", sender: self)
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true)
                        }
                    }
                }
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
//        let loginManager = LoginManager.shared.loginData
//        loginManager.email = emailTextField.text!
//        loginManager.password = passwordTextField.text!
//        loginManager.postRequest()
        
//        let vc = HomeViewController()
//        let navVC = UINavigationController(rootViewController: vc)
//        navVC.modalPresentationStyle = .fullScreen
//        self.present(navVC, animated: true)
        let homeVC = SignUpViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
    }
    
    func setTextFieldLayer() {
        
//        for i in 0..<loginTextField.count {
//            loginTextField[i].layer.cornerRadius = 80
//        }
//        //loginInfoStackView.customize(radiusSize: 50)
    }
}

//MARK: - UITextField Delegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
}
