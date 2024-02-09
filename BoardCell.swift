//
//  BoardCell.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/03/14.
//

import UIKit

class BoardCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var numberOfLikes: UILabel!
    @IBOutlet weak var numberOfComments: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        numberOfLikes.text = nil
        numberOfComments.text = nil
    }
    
    func configure(with viewModel: FreeBoardTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        numberOfLikes.text = viewModel.likesCount
        numberOfComments.text = viewModel.commentsCount
    }
}
