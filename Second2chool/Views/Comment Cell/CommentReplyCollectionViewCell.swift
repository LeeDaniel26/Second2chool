//
//  CommentReplyCollectionViewCell.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/06.
//

import UIKit

class CommentReplyCollectionViewCell: UITableViewCell {
    static let identifier = "CommentReplyCollectionViewCell"
    
    private let profilePictureButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        button.clipsToBounds = true
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor(rgb: 0xEB455F)
        if let customFont = UIFont(name: "NanumGothicBold", size: 10) {
            label.font = customFont
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        if let customFont = UIFont(name: "NanumGothicBold", size: 10) {
            label.font = customFont
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(profilePictureButton)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(commentLabel)
        setupConstraints()  // ??? layoutDidSubviews()에서 실행하면 cell dynamic sizing이 안됨. 한 줄로 끝에서 짤려 보임.
        
        backgroundColor = UIColor(rgb: 0xFCFFE7)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupConstraints() {
        let cellMinimumHeight: CGFloat = 45
        
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: cellMinimumHeight)
        ])
        
        let profilePictureSize: CGFloat = 33
        let paddingTopBottom = (cellMinimumHeight-profilePictureSize)/2
        let paddingLeftRight: CGFloat = 8
        
        profilePictureButton.layer.cornerRadius = profilePictureSize/2
        usernameLabel.sizeToFit()
        commentLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            profilePictureButton.widthAnchor.constraint(equalToConstant: profilePictureSize),
            profilePictureButton.heightAnchor.constraint(equalToConstant: profilePictureSize),
            profilePictureButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 35),
            profilePictureButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingTopBottom),
            
            usernameLabel.leadingAnchor.constraint(equalTo: profilePictureButton.trailingAnchor, constant: paddingLeftRight),
            usernameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -23),
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingTopBottom + 3),
                                
            commentLabel.leadingAnchor.constraint(equalTo: profilePictureButton.trailingAnchor, constant: paddingLeftRight),
            commentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -23),
            commentLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2),
            commentLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingTopBottom)
        ])
    }
    
    func configure(with viewModel: CommentViewModel) {
        usernameLabel.text = viewModel.writerName
        commentLabel.text = viewModel.content
    }
}
