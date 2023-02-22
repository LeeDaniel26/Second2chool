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

    @IBOutlet var loginTextField: [UITextField]!
    @IBOutlet weak var loginButton: UIButton!
    
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
        loginButton.layer.cornerRadius = 50
    }
    
    func setTextFieldLayer() {
        
        for i in 0..<loginTextField.count {
            loginTextField[i].layer.cornerRadius = 80
        }
        loginInfoStackView.customize(radiusSize: 50)
    }
}

