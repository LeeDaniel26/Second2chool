//
//  PostPhotosTableViewCell.swift
//  Second2chool
//
//  Created by Daniel Lee on 2/17/24.
//

import UIKit

class PostPhotosTableViewCell: UITableViewCell {
    static let identifier = "PostPhotosTableViewCell"
    
    private var userPickedImages = [UIImage]()
    
    let topPadding: CGFloat = 200    // This is a space between this cell and PostBodyTableViewCell
    let bottomPadding: CGFloat = 20  // This is a space between this cell and PostLikesTableViewCell
    let cellHeight = 100.0 + 200 + 20
        
    let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .lightGray
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 3
        stackView.backgroundColor = .lightGray
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(imageScrollView)
        imageScrollView.addSubview(imageStackView)
        setCellHeightConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        userPickedImages = []
    }
    
    private func setCellHeightConstraint() {
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: cellHeight)
        ])
    }
    
    private func setConstraints() {
        
        NSLayoutConstraint.activate([
            imageScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageScrollView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topPadding),
            imageScrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -bottomPadding),
        ])
        
        NSLayoutConstraint.activate([
            self.imageStackView.topAnchor.constraint(equalTo: self.imageScrollView.topAnchor),
            self.imageStackView.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor),
            self.imageStackView.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor),
            self.imageStackView.bottomAnchor.constraint(equalTo: self.imageScrollView.bottomAnchor)
        ])
        for image in userPickedImages {
            let originalHeight = image.size.height
            let originalWidth = image.size.width
            let scaleFactor = cellHeight / originalHeight
        
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
            self.imageStackView.addArrangedSubview(imageView)
            NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalToConstant: cellHeight),
                imageView.widthAnchor.constraint(equalToConstant: originalWidth * scaleFactor)
            ])
        }
    }
    
    private func getImageFromURL(imageURL: URL, completed: @escaping (UIImage) -> ())  {
        let task = URLSession.shared.dataTask(with: imageURL) { (data, response, error) in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            if let image  = UIImage(data: data) {
                DispatchQueue.main.async {
                    completed(image)
                }
            }
        }
        task.resume()
        
//        // This is example of use of async/await in URLSession
//        do {
//            let (data, response) = try await URLSession.shared.data(from: imageURL)
//            if let image = UIImage(data: data) {
//                return image
//            }
//        }
//        catch {
//            print("Error: Failed to retrieve image from url")
//            return nil
//        }
//        return nil
    }
    
    func configure(with viewModel: PostPhotosViewModel) {
        print("************ CONFIGURE WORKED")
        if viewModel.photoList.count == 0 {
            return
        }
        getImage(index: 0, photoList: viewModel.photoList)
    }
    
    func getImage(index: Int, photoList: [String]) {
        if index == photoList.count {
            self.setConstraints()
            return
        }
        getImageFromURL(imageURL: URL(string: photoList[index])!) { image in
            self.userPickedImages.append(image)
            self.getImage(index: index+1, photoList: photoList)
        }
    }
}
