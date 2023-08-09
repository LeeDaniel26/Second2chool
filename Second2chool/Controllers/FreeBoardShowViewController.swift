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
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentInputView: UIView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    var originalConstraint = 0.0
    
    var contents: Contents?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setValue()
        
        // Add bottom border to 'titleView'
        addBottomBorder()
        // Add top border to 'commentView'
        addTopBorder()
        
        commentInputView.layer.borderWidth = 1.2
        commentInputView.layer.borderColor = UIColor.label.cgColor
        commentInputView.layer.cornerRadius = commentInputView.frame.height / 2.05
        
        
        // TEST
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBoardShowViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBoardShowViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func addBottomBorder() {
        let thickness: CGFloat = 1.1
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: self.titleView.frame.size.height - thickness + 7.5, width: self.titleView.frame.size.width, height:thickness)
        bottomBorder.backgroundColor = UIColor.label.cgColor
        titleView.layer.addSublayer(bottomBorder)
    }
    
    func addTopBorder() {
        let thickness: CGFloat = 1.1
        let topBorder = CALayer()
        topBorder.frame = CGRect(x:0, y: thickness, width: self.commentView.frame.size.width, height:thickness)
        topBorder.backgroundColor = UIColor.label.cgColor
        commentView.layer.addSublayer(topBorder)
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
    
    
    // TEST
    @objc func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        originalConstraint = bottomConstraint.constant
        UIView.animate(withDuration: 0.1) {
            self.bottomConstraint.constant = keyboardFrame.size.height - 34
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.1) {
            self.bottomConstraint.constant = self.originalConstraint
            self.view.layoutIfNeeded()
        }
    }

    override func viewDidLayoutSubviews() {
        let fixedWidth = commentTextView.frame.size.width
        let newSize = commentTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        commentTextView.frame.size = CGSize(width: fixedWidth, height: newSize.height)

//        commentTextView.frame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        commentTextView.isScrollEnabled = false;
    }
}
