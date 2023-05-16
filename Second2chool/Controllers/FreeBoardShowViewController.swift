//
//  FreeBoardShowViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/05/17.
//

import UIKit

class FreeBoardShowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add bottom border to 'titleView'
        addBottomBorder()
    }
    
    @IBOutlet weak var titleView: UIView!
    
    func addBottomBorder() {
       let thickness: CGFloat = 1.1
       let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: self.titleView.frame.size.height - thickness + 7.5, width: self.titleView.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.label.cgColor
       titleView.layer.addSublayer(bottomBorder)
    }

}
