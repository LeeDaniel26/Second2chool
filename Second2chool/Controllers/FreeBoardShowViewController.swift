//
//  FreeBoardShowViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/05/17.
//

import UIKit

class FreeBoardShowViewController: UIViewController {
    
    @IBOutlet weak var writerName: UILabel!
    @IBOutlet weak var updatedAt: UILabel!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var countView: UIView!
    @IBOutlet weak var commentInputView: UIView!
    @IBOutlet weak var commentInput: UIView!
    @IBOutlet weak var commentInputText: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bodyLabelBottomConstraint: NSLayoutConstraint!
    var isReply = false
    
    
    var originalConstraint = 0.0
    
    var contents: Contents?
    
    let bottomBorderCommentView = 1.1
        
    let commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setValue()
        
        // Add bottom border to 'titleView'
        addBottomBorder()
        // Add top border to 'commentView'
        addTopBorder()
        
        commentInput.layer.borderWidth = 1.2
        commentInput.layer.borderColor = UIColor.label.cgColor
        commentInput.layer.cornerRadius = commentInput.frame.height / 2.05
                
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBoardShowViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBoardShowViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        contentViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: countView.bottomAnchor, constant: 54)
//        contentViewBottomConstraint?.isActive = true
//        previousView = countView
        addCommentStackView()
    }
    
    @IBAction func inputButtonPressed(_ sender: UIButton) {
        addCommentView()
//        comments.append(addCommentView())
//        var count = comments.count
//
//        if count == 1 {
//            print("This is 1 ~~~~~~~~")
//            comments[0].topAnchor.constraint(equalTo: countView.bottomAnchor, constant: 5).isActive = true
////            contentViewBottomConstraint?.isActive = false
//            contentView.removeConstraint(contentViewBottomConstraint!)
//            contentViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: comments[0].bottomAnchor, constant: 54)
//            contentViewBottomConstraint?.isActive = true
//            return
//        }
//
//        comments[count-1].topAnchor.constraint(equalTo: comments[count-2].bottomAnchor, constant: 5).isActive = true
////        contentViewBottomConstraint?.isActive = false
//        contentView.removeConstraint(contentViewBottomConstraint!)
//        contentViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: comments[count-1].bottomAnchor, constant: 54)
//        contentViewBottomConstraint?.isActive = true
//
//        print(" ")
////        print("********************** \(comments[count-1].frame.origin.y)")
////        print("********************** \(comments[count-1])")
//        for comment in comments {
//            print("********************** \(comment)")
//        }
//        print(" ")
    }
    
    
    func addBottomBorder() {
        let thickness: CGFloat = 1.1
        let bottomBorderTitleView = CALayer()
        bottomBorderTitleView.frame = CGRect(x:0, y: self.titleView.frame.size.height - thickness + 7.5, width: self.titleView.frame.size.width, height:thickness)
        bottomBorderTitleView.backgroundColor = UIColor.label.cgColor
        titleView.layer.addSublayer(bottomBorderTitleView)
        
        let bottomBorderCountView = CALayer()
        bottomBorderCountView.frame = CGRect(x:0, y: self.countView.frame.size.height - thickness, width: self.countView.frame.size.width, height:thickness)
        bottomBorderCountView.backgroundColor = UIColor.label.cgColor
        countView.layer.addSublayer(bottomBorderCountView)
    }
    
    func addTopBorder() {
        let thickness: CGFloat = 1.1
        let topBorder = CALayer()
        topBorder.frame = CGRect(x:0, y: thickness, width: self.commentInputView.frame.size.width, height:thickness)
        topBorder.backgroundColor = UIColor.label.cgColor
        commentInputView.layer.addSublayer(topBorder)
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

    //MARK: - SubViews
    
    func addCommentStackView() {
        contentView.addSubview(commentStackView)
        commentStackView.spacing = bottomBorderCommentView
        NSLayoutConstraint.activate([
            commentStackView.topAnchor.constraint(equalTo: countView.bottomAnchor),
            commentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 54),
            commentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            commentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func addCommentView() {
        let commentView = UIView()
        commentView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 54)
        
        commentView.translatesAutoresizingMaskIntoConstraints = false
        
        commentStackView.addArrangedSubview(commentView)
        commentView.backgroundColor = .lightGray
        NSLayoutConstraint.activate([
            commentView.leadingAnchor.constraint(equalTo: commentStackView.leadingAnchor),
            commentView.trailingAnchor.constraint(equalTo: commentStackView.trailingAnchor),
            commentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 54)
        ])
        
        let commentProfileImage = UIImageView()
        commentView.addSubview(commentProfileImage)
        commentProfileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentProfileImage.topAnchor.constraint(equalTo: commentView.topAnchor, constant :10),
            commentProfileImage.leadingAnchor.constraint(equalTo: commentView.leadingAnchor, constant: 8),
            commentProfileImage.widthAnchor.constraint(equalToConstant: 34),
            commentProfileImage.heightAnchor.constraint(equalToConstant: 34)
        ])
        commentProfileImage.image = UIImage.init(systemName: "person.circle.fill")

        let commentText = UILabel()
        commentView.addSubview(commentText);
        commentText.translatesAutoresizingMaskIntoConstraints = false
        commentText.numberOfLines = 0  // For multiline text
//        commentText.lineBreakMode = .byWordWrapping ;// For wrapping long text into multiple lines
        commentText.sizeToFit()
        commentText.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        NSLayoutConstraint.activate([
            commentText.topAnchor.constraint(equalTo: commentView.topAnchor, constant: 5),
            commentText.leadingAnchor.constraint(equalTo: commentProfileImage.trailingAnchor, constant: 6),
            commentText.trailingAnchor.constraint(equalTo: commentView.trailingAnchor, constant: 8)
        ])
        commentView.bottomAnchor.constraint(equalTo: commentText.bottomAnchor, constant: 10).isActive = true
        commentText.text = commentInputText.text ?? ""
        
        // Add Bottom Border
        let thickness: CGFloat = bottomBorderCommentView
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x:0, y: commentView.bounds.size.height, width: commentView.bounds.size.width, height: thickness)
        bottomBorder.backgroundColor = UIColor.label.cgColor
        commentView.layer.addSublayer(bottomBorder)
    }
    
    override func viewDidLayoutSubviews() {
//        let fixedWidth = commentInputText.frame.size.width
//        let newSize = commentInputText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        commentInputText.frame.size = CGSize(width: fixedWidth, height: newSize.height)

        commentInputText.isScrollEnabled = false;
    }
}
