//
//  CommentCollectionViewCell.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/06.
//

import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    static let identifier = "CommentCollectionViewCell"
        
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        if let customFont = UIFont(name: "NanumGothicBold", size: 12) {
            label.font = customFont
        }
        return label
    }()
    
    private let replyButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reply", for: .normal)
        button.setTitleColor(.link, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(commentLabel)
        contentView.addSubview(replyButton)
        
        backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        replyButton.sizeToFit()
                replyButton.frame = CGRect(x: width-replyButton.width,
                                           y: (height-replyButton.height)/2,
                                           width: replyButton.width,
                                           height: replyButton.height)
                commentLabel.frame = CGRect(x: 0,
                                            y: 0,
                                            width: width-replyButton.width-5,
                                            height: height)
    }
    
    func configure(with viewModel: CommentViewModel) {
        commentLabel.text = viewModel.content
    }
}
