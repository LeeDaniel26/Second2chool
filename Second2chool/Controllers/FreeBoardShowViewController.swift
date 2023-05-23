//
//  FreeBoardShowViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/05/17.
//

import UIKit

class FreeBoardShowViewController: UIViewController {

    let titleText: String
    let bodyText: String
    
    init(title: String, body: String) {
        self.titleText = title
        self.bodyText = body
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(titleText)
        print(bodyText)

        setValue()
        
        // Add bottom border to 'titleView'
        addBottomBorder()
    }
    
    func addBottomBorder() {
       let thickness: CGFloat = 1.1
       let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: self.titleView.frame.size.height - thickness + 7.5, width: self.titleView.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.label.cgColor
       titleView.layer.addSublayer(bottomBorder)
    }

    
    func setValue() {
//        titleLabel.text = titleText
//        bodyLabel.text = bodyText
    }
}
