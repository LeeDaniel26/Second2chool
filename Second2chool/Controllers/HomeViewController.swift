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
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
