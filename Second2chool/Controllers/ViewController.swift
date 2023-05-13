//
//  ViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/02/20.
//

import UIKit

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
//        UIApplication.shared.open (URL(string: "https://54.180.6.206:8080/oauth2/authorization/google?redirect_uri=http://54.180.6.206:8080/api/v1/test")!)
    }
    func setTextFieldLayer() {
        
//        for i in 0..<loginTextField.count {
//            loginTextField[i].layer.cornerRadius = 80
//        }
//        //loginInfoStackView.customize(radiusSize: 50)
    }
}

