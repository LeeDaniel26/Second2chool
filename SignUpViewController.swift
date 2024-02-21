//
//  SignUpOneViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/04/29.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nicknameField: UITextField!
    
    private let warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter the nickname"
        label.tintColor = .red
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nicknameField.delegate = self
        
        view.addSubview(warningLabel)
        
        warningLabel.sizeToFit()
        NSLayoutConstraint.activate([
            warningLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 45),
            warningLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            warningLabel.topAnchor.constraint(equalTo: nicknameField.bottomAnchor, constant: 10)
        ])
    }
    
    @IBAction func didTapCheckNickname(_ sender: UIButton) {
        guard let nickname = nicknameField.text else {
            warningLabel.isHidden = false
            return
        }
        LoginManager.shared.getCheckNickname(
            nickname: nickname) { decodedData in
                if decodedData.data == false {
                    let alert  = UIAlertController(title: "Unavailable",
                                                   message: "This nickname is already taken.",
                                                   preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss",
                                                  style: .cancel,
                                                  handler: nil))
                    self.present(alert, animated: true)
                }
                else {
                    self.warningLabel.text = "Nickname available"
                    self.warningLabel.tintColor = .green
                    self.warningLabel.isHidden = false
                }
            }
    }
    
    @IBAction func didTapSignUp(_ sender: UIButton) {
        if nicknameField.text == nil {
            self.warningLabel.text = "Please enter the nickname"
            self.warningLabel.tintColor = .red
            warningLabel.isHidden = false
            return
        }
        let vc = HomeViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        warningLabel.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if nicknameField.text == nil {
            self.warningLabel.text = "Please enter the nickname"
            self.warningLabel.tintColor = .red
            warningLabel.isHidden = false
            return false
        }
        else {
            warningLabel.isHidden = true
            return true
        }
    }
}
