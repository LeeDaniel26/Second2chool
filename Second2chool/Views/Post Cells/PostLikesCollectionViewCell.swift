//
//  PostLikesCollectionViewCell.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/05.
//

import UIKit

class PostLikesCollectionViewCell: UITableViewCell {
    static let identifier = "PostLikesCollectionViewCell"
    
    private let likesImage: UIImageView = {
        var imageView = UIImageView()
        let image = UIImage(systemName: "heart.fill",
                        withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))!
        imageView.image = image
        imageView.tintColor = UIColor(rgb: 0xEB455F)
        return imageView
    }()
    
    private let likesCountLabel: UILabel = {
        let label = UILabel()
        if let customFont = UIFont(name: "NanumGothicBold", size: 10) {
            label.font = customFont
        }
        return label
    }()
    
    private let commentsImage: UIImageView = {
        var imageView = UIImageView()
        let image = UIImage(systemName: "bubble.left.and.bubble.right",
                        withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))!
        imageView.image = image
        imageView.tintColor = .label
        return imageView
    }()
    
    private let commentsCountLabel: UILabel = {
        let label = UILabel()
        if let customFont = UIFont(name: "NanumGothicBold", size: 10) {
            label.font = customFont
        }
        return label
    }()
    
    private let bottomBorder: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.label.cgColor
        return layer
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(likesImage)
        contentView.addSubview(likesCountLabel)
        contentView.addSubview(commentsImage)
        contentView.addSubview(commentsCountLabel)
        contentView.layer.addSublayer(bottomBorder)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let imagePadding: CGFloat = 5
        let imageSize: CGFloat = contentView.height - (imagePadding * 2)
        likesImage.frame = CGRect(x: contentView.left+10,
                                  y: imagePadding,
                                  width: imageSize,
                                  height: imageSize)
        likesCountLabel.sizeToFit()
        likesCountLabel.frame = CGRect(x: likesImage.right+7,
                                       y: (contentView.height-likesCountLabel.height)/2,
                                       width: likesCountLabel.width,
                                       height: likesCountLabel.height)
        commentsImage.frame = CGRect(x: likesCountLabel.right+10,
                                     y: imagePadding,
                                     width: imageSize,
                                     height: imageSize)
        commentsCountLabel.sizeToFit()
        commentsCountLabel.frame = CGRect(x: commentsImage.right+7,
                                          y: (contentView.height-commentsCountLabel.height)/2,
                                          width: commentsCountLabel.width,
                                          height: commentsCountLabel.height)
        let thickness: CGFloat = 1.1
        bottomBorder.frame = CGRect(x: 0,
                                    y: contentView.height,
                                    width: contentView.width,
                                    height: thickness)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        likesCountLabel.text = nil
        commentsCountLabel.text = nil
    }
    
    func configure(with viewModel: PostLikesCollectionViewCellViewModel) {
        likesCountLabel.text = viewModel.likesCount
        commentsCountLabel.text = viewModel.commentsCount
    }
    
}
