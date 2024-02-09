//
//  PostBodyCollectionViewCell.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/05.
//

import UIKit

class PostBodyCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostBodyCollectionViewCell"
        
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        if let customFont = UIFont(name: "NanumGothicBold", size: 12) {
            label.font = customFont
        }
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(bodyLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let labelPadding: CGFloat = 23
        bodyLabel.frame = CGRect(
            x: labelPadding,
            y: 0,
            width: contentView.width - (labelPadding)*2,
            height: contentView.height
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bodyLabel.text = nil
    }
    
    func configure(with viewModel: PostBodyCollectionViewCellViewModel) {
        bodyLabel.text = viewModel.body
    }
}
