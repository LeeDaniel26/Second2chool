//
//  PostPhotoTableViewCell.swift
//  Second2chool
//
//  Created by Daniel Lee on 2/17/24.
//

import UIKit

class WritePostPhotoTableViewCell: UITableViewCell {
    static let identifier = "PostPhotoTableViewCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .label
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var cellHeightConstraint: NSLayoutConstraint?
    private var photoDesiredWidth: CGFloat = 100
    let padding: CGFloat = 15
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(photoImageView)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    private func setConstraints() {
//        photoImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        // This cell's height is defined at 'tableView(cellForRowAt)' in WritePostVC
        cellHeightConstraint = contentView.heightAnchor.constraint(equalToConstant: 200)
        NSLayoutConstraint.activate([
            cellHeightConstraint!,
            
            photoImageView.widthAnchor.constraint(equalToConstant: photoDesiredWidth),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding)
        ])
    }

    func configure(with viewModel: WritePostPhotoViewModel) {
        photoImageView.sd_setImage(with: viewModel.photoURL)
        cellHeightConstraint?.constant = viewModel.scaledPhotoHeight + padding*2
    }
}
