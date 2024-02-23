//
//  HomeViewController.swift
//  Second2chool
//
//  Created by Daniel on 2023/05/03.
//

import GoogleSignIn
import FirebaseAuth
import UIKit

class HomeViewController: UIViewController {
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        if let customFont = UIFont(name: "LilitaOne", size: 40) {
            label.font = customFont
        }
        label.text = "Home"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: titleLabel.width),
            titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.height),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
    }
    
    private func handleNotAuthenticated() {
        // Check auth status
        if Auth.auth().currentUser == nil,
            GIDSignIn.sharedInstance.currentUser == nil {
            // Show login
            performSegue(withIdentifier: "HomeToLogin", sender: self)
        }
    }

    
    @IBAction func didTapProfile(_ sender: UIBarButtonItem) {
        let vc = ProfileViewController()
        vc.title = "Profile"
        navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func didTapNotification(_ sender: UIBarButtonItem) {
        guard let user = GIDSignIn.sharedInstance.currentUser else {
            print("$$$$$$$$$$ No user is currently logged in")
            return
        }
        let email = user.profile?.email
        print("$$$$$$$$$$ Currently looged in user: \(email!)")
        
    }
}
