//
//  HomeViewController.swift
//  Second2chool
//
//  Created by Daniel on 2023/05/03.
//

import UIKit

class HomeViewController: UIViewController {

    var freeboardManager = FreeBoardManager()
    
    var currentPage = 0
    var size = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "LilitaOne", size: 36)!]  //--> UIFont(name: "LilitaOne-Regular", size: 36) doesn't seem to work. How can I specify weight?
        
//        navigationItem.largeTitleDisplayMode = .always
    }
}
