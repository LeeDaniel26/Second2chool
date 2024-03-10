//
//  PhotoTableViewCell.swift
//  Second2chool
//
//  Created by Daniel Lee on 2/26/24.
//

import UIKit

protocol PhotoTableViewCellDelegate: AnyObject {
    func didSelectCell(from: PhotoTableViewCell, at index: Int, with images: [String])
}

class PhotoTableViewCell: UITableViewCell {
    static let identifier = "PhotoTableViewCell"
    
    weak var delegate: PhotoTableViewCellDelegate?
    
    private var images = [String]()
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in
                let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(1)))

                item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .fractionalWidth(0.33)
                    ),
                    subitem: item,
                    count: 3
                )
                
                let section = NSCollectionLayoutSection(group: group)
                
                return section
            }))
        collectionView.register(PhotoCollectionViewCell.self,
                                forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        collectionView.backgroundColor = UIColor(rgb: 0xFCFFE7)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let paddingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(rgb: 0xFCFFE7)
        return view
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        contentView.addSubview(paddingView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setConstraints() {
        let bottomPadding: CGFloat = 20
        let cellHeight: CGFloat = contentView.width/3
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: (cellHeight + 22) * ceil(Double(images.count)/3) + bottomPadding),
            
            paddingView.heightAnchor.constraint(equalToConstant: bottomPadding),
            paddingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            paddingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            paddingView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: paddingView.topAnchor)
        ])
    }
    
    func configure(with viewModel: PostPhotosViewModel) {
        images = viewModel.photoList
        setConstraints()
    }
}

extension PhotoTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier,
                                                      for: indexPath) as! PhotoCollectionViewCell
        cell.configure(with: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelectCell(from: self, at: indexPath.row, with: images)
    }
}
