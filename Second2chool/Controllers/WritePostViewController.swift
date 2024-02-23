//
//  WritePostViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2/17/24.
//

import UIKit

class WritePostViewController: UIViewController, UITextViewDelegate {

    private var photos = [WritePostPhotoViewModel]()
    private var photoURLString = [String]()
    private var photoList = [String]()
    
    private var tableViewHeightConstraint: NSLayoutConstraint?
    
    private var anonymousOn = false
    private var commentsOn = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        if let customFont = UIFont(name: "LilitaOne", size: 40) {
            label.font = customFont
        }
        label.text = "FreeBoard"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        if let customFont = UIFont(name: "NanumGothicBold", size: 21) {
            textView.font = customFont
        }
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.borderWidth = 1
        return textView
    }()
    
    private let bodyView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bodyTextView: UITextView = {
        let textView = UITextView()
        textView.isScrollEnabled = false
        if let customFont = UIFont(name: "NanumGothicRegular", size: 14) {
            textView.font = customFont
        }
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let titlePlaceholderLabel: UILabel = {
        let label = UILabel()
        if let customFont = UIFont(name: "NanumGothicBold", size: 21) {
            label.font = customFont
        }
        label.text = "Title"
        label.textColor = .lightGray
        return label
    }()
    
    private let bodyPlaceholderLabel: UILabel = {
        let label = UILabel()
        if let customFont = UIFont(name: "NanumGothicRegular", size: 14) {
            label.font = customFont
        }
        label.text = "Share Some Stuff!"
        label.textColor = .lightGray
        return label
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(WritePostPhotoTableViewCell.self, forCellReuseIdentifier: WritePostPhotoTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
        
    private let postButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.backgroundColor = UIColor(rgb: 0xEB455F)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let anonymousSwitchLabel: UILabel = {
        let label = UILabel()
        label.text = "Anonymous On"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentsSwitchLabel: UILabel = {
        let label = UILabel()
        label.text = "Comments On"
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let anonymousSwitch: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        return button
    }()
    
    private let commentsSwitch: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderWidth = 1
        return button
    }()
    
    private let addPhotoButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "Image_Post_Button"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(titleTextView)
        contentView.addSubview(bodyView)
        bodyView.addSubview(bodyTextView)
        titleTextView.addSubview(titlePlaceholderLabel)
        bodyTextView.addSubview(bodyPlaceholderLabel)
        contentView.addSubview(tableView)
        contentView.addSubview(postButton)
        bodyView.addSubview(anonymousSwitchLabel)
        bodyView.addSubview(commentsSwitchLabel)
        bodyView.addSubview(anonymousSwitch)
        bodyView.addSubview(commentsSwitch)
        bodyView.addSubview(addPhotoButton)
        view.backgroundColor = UIColor(rgb: 0xFCFFE7)
        
        setupConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        titleTextView.delegate = self
        bodyTextView.delegate = self
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(didTapCancel))
        anonymousSwitch.addTarget(self, action: #selector(didTapAnonymousSwitch), for: .touchUpInside)
        commentsSwitch.addTarget(self, action: #selector(didTapCommentsSwitch), for: .touchUpInside)
        postButton.addTarget(self, action: #selector(didTapPost), for: .touchUpInside)
        addPhotoButton.addTarget(self, action: #selector(didTapAddPhoto), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titlePlaceholderLabel.sizeToFit()
        bodyPlaceholderLabel.sizeToFit()
        titlePlaceholderLabel.frame.origin = CGPoint(x: 5, y: 8)
        bodyPlaceholderLabel.frame.origin = CGPoint(x: 5, y: 3)
        
        postButton.layer.cornerRadius = postButton.height/2
    }
        
    private func setupConstraints() {
        
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 0)
        
        let buttonSize: CGFloat = 58
        let switchSize: CGFloat = 16
        addPhotoButton.frame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize)
        addPhotoButton.layer.cornerRadius = buttonSize/2
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.widthAnchor.constraint(equalToConstant: titleLabel.width),
            titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.height),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 27),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            
            titleTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 42),
            titleTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            
            bodyView.heightAnchor.constraint(greaterThanOrEqualToConstant: 465),
            bodyView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bodyView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bodyView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: 16),
            
            anonymousSwitchLabel.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 7),
            anonymousSwitchLabel.bottomAnchor.constraint(equalTo: commentsSwitchLabel.topAnchor, constant: -7),
            
            commentsSwitchLabel.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor, constant: 7),
            commentsSwitchLabel.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -7),
            
//            bodyTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 465),
            bodyTextView.leadingAnchor.constraint(equalTo: bodyView.leadingAnchor),
            bodyTextView.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor),
            bodyTextView.topAnchor.constraint(equalTo: bodyView.topAnchor),
            bodyTextView.bottomAnchor.constraint(equalTo: anonymousSwitchLabel.topAnchor, constant: -20),
                        
            tableViewHeightConstraint!,
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            tableView.topAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: 30),
            
            postButton.heightAnchor.constraint(equalToConstant: 41),
            postButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 45),
            postButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45),
            postButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 15),
            postButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
                        
            anonymousSwitch.centerYAnchor.constraint(equalTo: anonymousSwitchLabel.centerYAnchor),
            anonymousSwitch.widthAnchor.constraint(equalToConstant: switchSize),
            anonymousSwitch.heightAnchor.constraint(equalToConstant: switchSize),
            anonymousSwitch.leadingAnchor.constraint(equalTo: anonymousSwitchLabel.trailingAnchor, constant: 5),
            
            commentsSwitch.centerXAnchor.constraint(equalTo: anonymousSwitch.centerXAnchor),
            commentsSwitch.centerYAnchor.constraint(equalTo: commentsSwitchLabel.centerYAnchor),
            commentsSwitch.widthAnchor.constraint(equalToConstant: switchSize),
            commentsSwitch.heightAnchor.constraint(equalToConstant: switchSize),

            addPhotoButton.widthAnchor.constraint(equalToConstant: buttonSize),
            addPhotoButton.heightAnchor.constraint(equalToConstant: buttonSize),
            addPhotoButton.trailingAnchor.constraint(equalTo: bodyView.trailingAnchor, constant: -7),
            addPhotoButton.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -7)
        ])
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
    
    @objc private func didTapAnonymousSwitch() {
        if anonymousOn == false {
            anonymousSwitch.setBackgroundImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            anonymousSwitch.setBackgroundImage(nil, for: .normal)
        }
        anonymousOn.toggle()
    }
    
    @objc private func didTapCommentsSwitch() {
        if commentsOn == false {
            commentsSwitch.setBackgroundImage(UIImage(systemName: "checkmark"), for: .normal)
        } else {
            commentsSwitch.setBackgroundImage(nil, for: .normal)
        }
        commentsOn.toggle()
    }
    
    @objc private func didTapPost() {
        if photoURLString.count == 0 {
            configurePost()
            dismiss(animated: true)
            return
        }
        for url in photoURLString {
            ImageManager.shared.getPresignedRequest() { decodedData in
                guard let decodedData = decodedData else {
                    return
                }
                let data = decodedData.data
                ImageManager.shared.putPresignedRequest(with: url, data: data) {
                    if let index = data.firstIndex(of: "?") {
                        let urlString = String(data[..<index])
                        self.photoList.append(urlString)
                    }
                    if url == self.photoURLString.last {
                        self.configurePost()
                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    private func configurePost() {
        FreeBoardManager.shared.postRequest(
            title: self.titleTextView.text ?? "No Title",
            content: self.bodyTextView.text ?? " ",
            isAnon: anonymousOn,
            commentOn: commentsOn,
            courseId: nil,
            postType: "FREE",
            reviewScore: nil,
            photoList: self.photoList)
    }
    
    @objc private func didTapAddPhoto() {
        let sheet = UIAlertController(
            title: "Change Picture",
            message: "Update your photo to reflect your best self.",
            preferredStyle: .actionSheet
        )

        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        // Take Photo
        
        // Choose Photo
        sheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            DispatchQueue.main.async {
                let picker = UIImagePickerController()
                picker.allowsEditing = true
                picker.sourceType = .photoLibrary
                picker.delegate = self  // This 'self' is referring to ProfileVC's 'UIImagePickerControllerDelegate' in its extension
                self?.present(picker, animated: true)
            }
        }))
        present(sheet, animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        titlePlaceholderLabel.isHidden = !titleTextView.text.isEmpty
        bodyPlaceholderLabel.isHidden = !bodyTextView.text.isEmpty
    }
}

extension WritePostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WritePostPhotoTableViewCell.identifier, 
                                                 for: indexPath) as! WritePostPhotoTableViewCell
        cell.configure(with: photos[indexPath.row])
        return cell
    }    
}

extension WritePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage, 
              let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL else {
            return
        }
        
        let imageAspectRatio = image.size.height / image.size.width
        let cellImageViewWidth: CGFloat = 100
        let scaledImageHeight = cellImageViewWidth * imageAspectRatio

        self.photoURLString.append(imageUrl.path)
        self.photos.append(WritePostPhotoViewModel(photoURL: imageUrl, scaledPhotoHeight: scaledImageHeight))
        self.tableViewHeightConstraint?.constant += scaledImageHeight + 50
        self.tableView.reloadData()

    }
}
