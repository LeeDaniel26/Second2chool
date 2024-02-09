//
//  PostTitleCollectionViewCell.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/05.
//

import UIKit

class PostTitleCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostTitleCollectionViewCell"
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        if let customFont = UIFont(name: "NanumGothicBold", size: 21) {
            label.font = customFont
        }
        return label
    }()
    
    private let bottomBorder: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.label.cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
        contentView.layer.addSublayer(bottomBorder)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let labelPadding: CGFloat = 23
        titleLabel.frame = CGRect(
            x: labelPadding,
            y: 0,
            width: contentView.width - (labelPadding)*2,
            height: contentView.height
        )
        
        let thickness: CGFloat = 1.1
        bottomBorder.frame = CGRect(
            x: labelPadding,
            y: titleLabel.height - 10,
            width: titleLabel.width,
            height: thickness
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    func configure(with viewModel: PostTitleCollectionViewCellViewModel) {
        titleLabel.text = viewModel.title
    }
}
