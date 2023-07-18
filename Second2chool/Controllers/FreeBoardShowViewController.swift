//
//  FreeBoardShowViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/05/17.
//

import UIKit

class FreeBoardShowViewController: UIViewController {

//    let titleText: String
//    let bodyText: String
//
//    init(title: String, body: String) {
//        self.titleText = title
//        self.bodyText = body
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    @IBOutlet weak var writerName: UILabel!
    @IBOutlet weak var updatedAt: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    var contents: Contents?
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
//        print(contents?.title)
//        print(contents?.content)

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

    // **** Ask
    // - createdAt/updatedAt 날짜 뒤 값은 뭐지?
    
    // **** Consider
    // - title/contents가 nil일 경우 어떻게 표시?
    
    func setValue() {
        writerName.text = contents?.writerName
        updatedAt.text = contents?.updatedAt
        titleLabel.text = contents?.title
        bodyLabel.text = contents?.content
    }
}
