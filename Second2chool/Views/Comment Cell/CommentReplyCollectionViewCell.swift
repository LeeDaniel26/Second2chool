//
//  CommentReplyCollectionViewCell.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/06.
//

import UIKit

class CommentReplyCollectionViewCell: UICollectionViewCell {
    static let identifier = "CommentReplyCollectionViewCell"
    
    private let replyLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        replyLabel.frame = contentView.bounds
    }
    
    func configure(with viewModel: CommentReplyViewModel) {
        replyLabel.text = viewModel.commentReply
    }
}
