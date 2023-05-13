//
//  SignUpOneViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/04/29.
//

import UIKit

class SignUpOneViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        let loginManager = LoginManager(with: "SignUp")
        loginManager.username = emailTextField.text!
        loginManager.email = emailTextField.text!
        loginManager.password = passwordTextField.text!
        loginManager.postRequest()
    }
}
