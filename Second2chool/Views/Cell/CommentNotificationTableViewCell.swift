//
//  CommentNotificationTableViewCell.swift
//  Second2chool
//
//  Created by Daniel Lee on 3/6/24.
//

import UIKit

class CommentNotificationTableViewCell: UITableViewCell {
    static let identifier = "CommentNotificationTableViewCell"

    private let profilePictureButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        button.clipsToBounds = true
        button.tintColor = .lightGray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        if let customFont = UIFont(name: "NanumGothicBold", size: 12) {
            label.font = customFont
        }
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    private func setupConstraints() {
        let cellHeight: CGFloat = 60
                
        let profilePictureSize: CGFloat = cellHeight/1.5
        let paddingTopBottom = (cellHeight-profilePictureSize)/2
        let paddingLeftRight: CGFloat = 8
        
        profilePictureButton.layer.cornerRadius = profilePictureSize/2
        label.sizeToFit()
        
        NSLayoutConstraint.activate([
            profilePictureButton.widthAnchor.constraint(equalToConstant: profilePictureSize),
            profilePictureButton.heightAnchor.constraint(equalToConstant: profilePictureSize),
            profilePictureButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            profilePictureButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: paddingTopBottom),
                                            
            label.leadingAnchor.constraint(equalTo: profilePictureButton.trailingAnchor, constant: paddingLeftRight),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -23),
            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -paddingTopBottom)
        ])
    }
    
    func configure(with database: NotificationDatabase) {
        
    }
}
