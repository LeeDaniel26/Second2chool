//
//  PosterCollectionViewCell.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/05.
//

import SDWebImage
import UIKit

protocol PosterCollectionViewCellDelegate: AnyObject {
    func posterCollectionViewCellDidTapUsername(_ cell: PosterCollectionViewCell)
}

class PosterCollectionViewCell: UITableViewCell {
    static let identifier = "PosterCollectionViewCell"
    
    private let profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.tintColor = .lightGray
        return imageView
    }()

    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        if let customFont = UIFont(name: "NanumGothicBold", size: 17) {
            label.font = customFont
        }
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        if let customFont = UIFont(name: "NanumGothicBold", size: 14) {
            label.font = customFont
        }
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(profilePictureImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(dateLabel)
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(didTapUsername))
        usernameLabel.isUserInteractionEnabled = true
        usernameLabel.addGestureRecognizer(tap)
        
        contentView.backgroundColor = UIColor(rgb: 0xFCFFE7)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc func didTapUsername() {
//        delegate?.posterCollectionViewCellDidTapUsername(self, index: index)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagePadding: CGFloat = 10
        let imageSize: CGFloat = contentView.height - (imagePadding * 2)
        profilePictureImageView.frame = CGRect(x: imagePadding, y: imagePadding, width: imageSize, height: imageSize)
        profilePictureImageView.layer.cornerRadius = imageSize/2

        usernameLabel.sizeToFit()
        usernameLabel.frame = CGRect(
            x: profilePictureImageView.right+11,
            y: imagePadding,
            width: usernameLabel.width,
            height: usernameLabel.height
        )
        dateLabel.sizeToFit()
        dateLabel.frame = CGRect(
            x: profilePictureImageView.right+11,
            y: contentView.height-imagePadding-dateLabel.height,
            width: dateLabel.width,
            height: dateLabel.height
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        profilePictureImageView.image = nil
        usernameLabel.text = nil
        dateLabel.text = nil
    }

    func configure(with viewModel: PosterCollectionViewCellViewModel) {
//        imageView.sd_setImage(with: viewModel.profilePictureURL, completed: nil)
        usernameLabel.text = viewModel.username
        dateLabel.text = "\(viewModel.editedDate)"
    }
}
