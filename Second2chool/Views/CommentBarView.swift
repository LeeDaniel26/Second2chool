//
//  CommentBarView.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/06.
//

import UIKit

protocol CommentBarViewDelegate: AnyObject {
    func commentBarViewDidTapDone(_ commentBarView: CommentBarView, withText text: String)
}

final class CommentBarView: UIView, UITextViewDelegate {

    weak var delegate: CommentBarViewDelegate?
    
    
    private let paddingTopBottom: CGFloat = 11
    private let paddingLeftRight: CGFloat = 9

    private let viewMinHeight: CGFloat = 52
    private let viewMaxHeight: CGFloat = 138
    private var viewHeightConstraint: NSLayoutConstraint?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let commentInputView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let commentInputTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "paperplane"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(profileImageView)
        addSubview(commentInputView)
        commentInputView.addSubview(commentInputTextView)
        commentInputView.addSubview(button)
        commentInputTextView.delegate = self
        button.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        backgroundColor = UIColor(rgb: 0xFCFFE7)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    @objc func didTapSend() {
        guard let text = commentInputTextView.text, !text.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        delegate?.commentBarViewDidTapDone(self, withText: text)
        commentInputTextView.resignFirstResponder()
        commentInputTextView.text = nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        commentInputView.layer.cornerRadius = (viewMinHeight - paddingTopBottom*2) / 2.05  // commentInputView's initial height / 2.05
    }
        
    private func setConstraints() {
        let profileImageSize: CGFloat = 40
        let buttonSize: CGFloat = 22
        profileImageView.layer.cornerRadius = profileImageSize/2
                        
        viewHeightConstraint = heightAnchor.constraint(equalToConstant: 52)
        
        NSLayoutConstraint.activate([
            viewHeightConstraint!,
            
            profileImageView.widthAnchor.constraint(equalToConstant: profileImageSize),
            profileImageView.heightAnchor.constraint(equalToConstant: profileImageSize),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: paddingLeftRight),
            profileImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingTopBottom + 4.3),
            
            commentInputView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 6),
            commentInputView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -paddingLeftRight),
            commentInputView.topAnchor.constraint(equalTo: topAnchor, constant: paddingTopBottom),
            commentInputView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -paddingTopBottom),
            
            button.widthAnchor.constraint(equalToConstant: buttonSize),
            button.heightAnchor.constraint(equalToConstant: buttonSize),
            button.trailingAnchor.constraint(equalTo: commentInputView.trailingAnchor, constant: -10),
            button.bottomAnchor.constraint(equalTo: commentInputView.bottomAnchor, constant: -4),

            commentInputTextView.leadingAnchor.constraint(equalTo: commentInputView.leadingAnchor, constant: 8),
            commentInputTextView.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -8),
            commentInputTextView.topAnchor.constraint(equalTo: commentInputView.topAnchor),
            commentInputTextView.bottomAnchor.constraint(equalTo: commentInputView.bottomAnchor),
        ])
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = commentInputTextView.frame.size.width
        let newSize = commentInputTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if newSize.height + paddingTopBottom*2 > viewMaxHeight {
            commentInputTextView.isScrollEnabled = true
            viewHeightConstraint?.constant = viewMaxHeight
        }
        else if newSize.height + paddingTopBottom*2 < viewMinHeight{
            commentInputTextView.isScrollEnabled = false
            viewHeightConstraint?.constant = viewMinHeight
        }
        else {
            commentInputTextView.isScrollEnabled = false
            viewHeightConstraint?.constant = newSize.height + paddingTopBottom*2
        }
    }
}
