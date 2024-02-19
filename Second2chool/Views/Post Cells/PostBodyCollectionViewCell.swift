//
//  PostBodyCollectionViewCell.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/05.
//

import UIKit

class PostBodyCollectionViewCell: UITableViewCell {
    static let identifier = "PostBodyCollectionViewCell"
        
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .label
        if let customFont = UIFont(name: "NanumGothicBold", size: 12) {
            label.font = customFont
        }
        label.translatesAutoresizingMaskIntoConstraints = false // This enables Autolayout for the label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(bodyLabel)
        contentView.backgroundColor = UIColor(rgb: 0xFCFFE7)
        setupConstraints()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        let labelPadding: CGFloat = 23
        NSLayoutConstraint.activate([
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: labelPadding),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -labelPadding),
            bodyLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bodyLabel.text = nil
    }
    
    func configure(with viewModel: PostBodyCollectionViewCellViewModel) {
        bodyLabel.text = viewModel.body
    }
}
