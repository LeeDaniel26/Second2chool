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
    @IBOutlet weak var countViewBottomConstraint: NSLayoutConstraint!
    /*
     countViewBottomConstraint가 없으면 Scroll View에 다음과 같은 에러가 뜬다:
     "Need constraints for: Y position or height"
    */

    @IBOutlet weak var commentInputView: UIView!
    @IBOutlet weak var commentInput: UIView!
    @IBOutlet weak var commentInputText: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bodyLabelBottomConstraint: NSLayoutConstraint!
    var isReply = false
    
    var originalConstraint = 0.0
    
    var contents: Contents?
    
    var commentViewBottomConstraint: NSLayoutConstraint?
    /*
     commentView가 생성됐을 경우 commentViewBottomConstraint가 없으면 Scroll View에 다음과 같은 에러가 발생할 것이다:
     "Need constraints for: Y position or height".
     commentViewBottomConstraint를 생성했을 경우 countViewBottomConstraint는 conflict를 피하기 위해 없에야 한다.
    */
    var commentViews: [UIView] = []    // 댓글과 대댓글 모음
    var commentReplyButtons: [UIButton] = []    // 몇번째 댓글의 reply 버튼을 눌렀는지 확인하기 위함
    let bottomBorderCommentView = 1.1
    
    var commentViewReplies: [[UIView]] = []
        
//    let commentStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .fillProportionally
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
        
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
        
    }
    
    @IBAction func inputButtonPressed(_ sender: UIButton) {
        addCommentView()
        commentInputText.text = ""
    }
    
    @objc func commentReplyButtonPressed() {
        print("*************** Button pressed.")
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
        print("+++++++++++++++++++++++++ \(contents?.id)")
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
        
    func addCommentView() {
        let commentView = UIView()
        commentView.frame = CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: 54)
        contentView.addSubview(commentView)
        commentView.backgroundColor = .lightGray
        commentViews.append(commentView)
        commentView.translatesAutoresizingMaskIntoConstraints = false
        if commentViews.count == 1 {
            NSLayoutConstraint.deactivate([countViewBottomConstraint!])
            commentView.topAnchor.constraint(equalTo: countView.bottomAnchor).isActive = true
        } else {
            NSLayoutConstraint.deactivate([commentViewBottomConstraint!])
            commentView.topAnchor.constraint(equalTo: commentViews[commentViews.firstIndex(of: commentView)! - 1].bottomAnchor, constant: bottomBorderCommentView).isActive = true   // -1은 다음 댓글을 이전 댓글의 bottomAnchor에 이어붙이기 위함
        }
        commentViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: commentView.bottomAnchor, constant: 54)
        NSLayoutConstraint.activate([
            commentViewBottomConstraint!,
            commentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            commentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            commentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 54)
        ])
        
        let commentProfileImage = UIImageView()
        commentView.addSubview(commentProfileImage)
        commentProfileImage.image = UIImage.init(systemName: "person.circle.fill")
        commentProfileImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentProfileImage.topAnchor.constraint(equalTo: commentView.topAnchor, constant :10),
            commentProfileImage.leadingAnchor.constraint(equalTo: commentView.leadingAnchor, constant: 8),
            commentProfileImage.widthAnchor.constraint(equalToConstant: 34),
            commentProfileImage.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        let commentReplyButton = UIButton(frame: CGRect(x: 0, y: 0, width: 27, height: 27))
        commentReplyButton.addTarget(self, action: #selector(commentReplyButtonPressed), for: .touchUpInside)
        commentView.addSubview(commentReplyButton)
        commentReplyButton.setBackgroundImage(UIImage.init(systemName: "bubble.left.circle"), for: .normal)
        commentReplyButtons.append(commentReplyButton)
        commentReplyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            commentReplyButton.topAnchor.constraint(equalTo: commentView.topAnchor, constant: 13.5),
            commentReplyButton.trailingAnchor.constraint(equalTo: commentView.trailingAnchor, constant: -10),
            commentReplyButton.widthAnchor.constraint(equalToConstant: 27),
            commentReplyButton.heightAnchor.constraint(equalToConstant: 27),
        ])

        let commentText = UILabel()
        commentView.addSubview(commentText);
        commentText.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        commentText.numberOfLines = 0  // For multiline text
        commentText.sizeToFit()
        commentText.translatesAutoresizingMaskIntoConstraints = false
//        commentText.lineBreakMode = .byWordWrapping ;// For wrapping long text into multiple lines
        NSLayoutConstraint.activate([
            commentText.topAnchor.constraint(equalTo: commentView.topAnchor, constant: 5),
            commentText.leadingAnchor.constraint(equalTo: commentProfileImage.trailingAnchor, constant: 6),
            commentText.trailingAnchor.constraint(equalTo: commentReplyButton.leadingAnchor, constant: -8)
//            commentText.trailingAnchor.constraint(equalTo: commentView.trailingAnchor, constant: -8)
        ])
        commentView.bottomAnchor.constraint(equalTo: commentText.bottomAnchor, constant: 10).isActive = true
        commentText.text = commentInputText.text ?? ""
        
        // Add Bottom Border
        let thickness: CGFloat = bottomBorderCommentView
        let bottomBorder = CALayer()
        commentView.layoutIfNeeded() // TEST
        print("**************************\(commentView.bounds.height)")
        bottomBorder.frame = CGRect(x:0, y: commentView.bounds.size.height, width: commentView.bounds.size.width, height: thickness)
        bottomBorder.backgroundColor = UIColor.label.cgColor
        commentView.layer.addSublayer(bottomBorder)
    }
    
//    func addCommentViewReply(idx: Int) {
//        let commentViewReply = UIView()
//        commentViewReply.frame = CGRect(x: 0, y: 200, width: self.view.frame.size.width, height: 54)
//        contentView.addSubview(commentViewReply)
//        commentViewReply.backgroundColor = .lightGray
//        commentViewReplies[commentViews.firstIndex(of: commentView)!].append(commentView)
//        commentViewReply.translatesAutoresizingMaskIntoConstraints = false
//        if commentViews.count == 1 {
//            NSLayoutConstraint.deactivate([countViewBottomConstraint!])
//            commentView.topAnchor.constraint(equalTo: countView.bottomAnchor).isActive = true
//        } else {
//            NSLayoutConstraint.deactivate([commentViewBottomConstraint!])
//            commentView.topAnchor.constraint(equalTo: commentViews[commentViews.firstIndex(of: commentView)! - 1].bottomAnchor, constant: bottomBorderCommentView).isActive = true   // -1은 다음 댓글을 이전 댓글의 bottomAnchor에 이어붙이기 위함
//        }
//        commentViewBottomConstraint = contentView.bottomAnchor.constraint(equalTo: commentView.bottomAnchor, constant: 54)
//        NSLayoutConstraint.activate([
//            commentViewBottomConstraint!,
//            commentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            commentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            commentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 54)
//        ])
//
//        let commentProfileImage = UIImageView()
//        commentView.addSubview(commentProfileImage)
//        commentProfileImage.image = UIImage.init(systemName: "person.circle.fill")
//        commentProfileImage.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            commentProfileImage.topAnchor.constraint(equalTo: commentView.topAnchor, constant :10),
//            commentProfileImage.leadingAnchor.constraint(equalTo: commentView.leadingAnchor, constant: 8),
//            commentProfileImage.widthAnchor.constraint(equalToConstant: 34),
//            commentProfileImage.heightAnchor.constraint(equalToConstant: 34)
//        ])
//    }
    
    override func viewDidLayoutSubviews() {
//        let fixedWidth = commentInputText.frame.size.width
//        let newSize = commentInputText.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
//        commentInputText.frame.size = CGSize(width: fixedWidth, height: newSize.height)

        commentInputText.isScrollEnabled = false;
    }
}
