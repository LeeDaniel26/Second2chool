//
//  ProfileHeaderView.swift
//  Second2chool
//
//  Created by Daniel Lee on 2/17/24.
//

import UIKit

protocol ProfileHeaderViewDelegate: AnyObject {
    func didTapProfilePicture(_ view: ProfileHeaderView)
}

class ProfileHeaderView: UIView {
    
    weak var delegate: ProfileHeaderViewDelegate?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        // Get name (unfinished)
        return label
    }()
    
    private let majorLabel: UILabel = {     // (ask)
        let label = UILabel()
        // Get major (unfinished)
        return label
    }()
    
    private let totalPostsLabel: UILabel = {
        let label = UILabel()
        if let customFont = UIFont(name: "NanumGothicBold", size: 14) {
            label.font = customFont
        }
        label.text = "Total Posts"
        label.textColor = .yellow
        return label
    }()
    
    private let totalCommentsLabel: UILabel = {
        let label = UILabel()
        if let customFont = UIFont(name: "NanumGothicBold", size: 14) {
            label.font = customFont
        }
        label.text = "Total Comments"
        label.textColor = .yellow
        return label
        
    }()
    
    private let countTotalPostsLabel: UILabel = {
        let label = UILabel()
        // Get total number of posts (unfinished)
        return label
    }()
    
    private let countTotalCommentsLabel: UILabel = {
        let label = UILabel()
        // Get total number of comments (unfinished)
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = .label
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(rgb: 0xEB455F)
        addSubview(profileImageView)
        addSubview(totalPostsLabel)
        addSubview(totalCommentsLabel)

        layer.borderWidth = 1
        layer.borderColor = UIColor.label.cgColor
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        profileImageView.addGestureRecognizer(tap)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let size = height/2.1
        profileImageView.frame = CGRect(x: width - size - width/32,
                                                        y: (height-size)/2,
                                                        width: size,
                                                        height: size)
        profileImageView.layer.cornerRadius = size/2.0
        
        // TEST
        
        totalPostsLabel.sizeToFit()
        totalPostsLabel.frame = CGRect(x: width/16,
                                       y: height - totalPostsLabel.frame.size.height - height/3.5,
                                       width: totalPostsLabel.width,
                                       height: totalPostsLabel.height)
        totalCommentsLabel.sizeToFit()
        totalCommentsLabel.frame = CGRect(x: totalPostsLabel.frame.origin.x + totalCommentsLabel.frame.size.width + 7,
                                          y: height - totalCommentsLabel.frame.size.height - height/3.5,
                                          width: totalCommentsLabel.width,
                                          height: totalCommentsLabel.height)
    }
    
    @objc private func didTapProfileImage() {
        delegate?.didTapProfilePicture(self)
    }
        
    func configure(with viewModel: ProfileHeaderViewModel) {
        profileImageView.sd_setImage(with: viewModel.profilePictureUrl, completed: nil)
        countTotalPostsLabel.text = "\(viewModel.postCount)"
        countTotalCommentsLabel.text = "\(viewModel.commentCount)"
    }
}
