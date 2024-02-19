//
//  PostViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/03/14.
//

import UIKit
import PhotosUI

class PostViewController: UIViewController {

    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var bodyTextViewBottomConstraint: NSLayoutConstraint?
    
    @IBOutlet weak var imagePostButton: UIButton!
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
        
    var userPickedImages = [UIImage]()
    var imageURL = [URL]()
    
    let imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    let imageStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = 3
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
//        bodyTextView.sizeToFit()
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "LilitaOne", size: 36)!]
        

        // TEST
        NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        // Bottom border of UITextField 'titleTextField'
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.label.cgColor
        border.frame = CGRect(x: 0, y: titleTextField.frame.size.height, width: titleTextField.frame.size.width, height: width)

        border.borderWidth = width
        titleTextField.backgroundColor = UIColor.clear
        titleTextField.layer.addSublayer(border)
        titleTextField.layer.masksToBounds = true
        titleTextField.textColor = UIColor.label
        titleTextField.borderStyle = UITextField.BorderStyle.none
        
        // Placeholder for UITextView 'bodyTextView'
        // (--> more code at extension below..)
        
        bodyTextView.text = "Share Some Stuff!"
        bodyTextView.textColor = UIColor.lightGray
        
        // Delegates
        bodyTextView.delegate = self
        
        // Constraints
        imagePostButtonConstraints()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .plain,  // ???
                                                            target: self,
                                                            action: #selector(didTapCancel))
    }
    
    @IBAction func notificationButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func imagePostButtonPressed(_ sender: UIButton) {
        let vc = CameraViewController()
        navigationController?.pushViewController(vc, animated: true)
        
//        var config = PHPickerConfiguration()
//        config.selectionLimit = 0
//        let phPicker = PHPickerViewController(configuration: config)
//        phPicker.delegate = self
//        present(phPicker, animated: true)
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
//        let urlStringArray = imageURL.map { $0.absoluteString }
        
        FreeBoardManager.shared.postRequest(
            title: titleTextField.text ?? "",
            content: bodyTextView.text ?? "",
            isAnon: false,    // (Mock)
            commentOn: true,
            courseId: nil,
            postType: "FREE",
            reviewScore: nil,
            photoList: [])
                
        // Upload an Image
        
        
        performSegue(withIdentifier: "PostToFreeboard", sender: self)
        
    }
    

    // TEST
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
          // if keyboard size is not available for some reason, dont do anything
          return
        }

        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)


        // reset back the content inset to zero after keyboard is gone
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true,
                completion: nil)
    }
    
    func imagePostButtonConstraints() {
        imagePostButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imagePostButton.rightAnchor.constraint(equalTo: bodyTextView.rightAnchor, constant: -7),
            imagePostButton.bottomAnchor.constraint(equalTo: bodyTextView.bottomAnchor, constant: -10)
        ])
    }
}

// Placeholder for UITextView 'bodyTextView'
extension PostViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.label
    }

}

extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)

        self.view.addSubview(self.imageScrollView)
        self.imageScrollView.addSubview(imageStackView)

        for result in results {
            result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { url, error in
                if let error = error {
                    print("Error loading file representation: \(error)")
                } else if let url = url {
                    do {
                        self.imageURL.append(url)
                        
                        let data = try Foundation.Data(contentsOf: url)
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self.userPickedImages.append(image)

                                let scrollViewHeight = 100.0

                                NSLayoutConstraint.activate([
                                    self.imageScrollView.topAnchor.constraint(equalTo: self.bodyTextView.bottomAnchor, constant: 25),
                                    self.imageScrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
                                    self.imageScrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
                                    self.imageScrollView.bottomAnchor.constraint(equalTo: self.postButton.topAnchor, constant: -23),
                                    self.imageScrollView.heightAnchor.constraint(equalToConstant: scrollViewHeight)
                                ])
                                self.imageScrollView.backgroundColor = .lightGray

                                if let constraint = self.bodyTextViewBottomConstraint {
                                    constraint.isActive = false
                                }

                                NSLayoutConstraint.activate([
                                    self.imageStackView.topAnchor.constraint(equalTo: self.imageScrollView.topAnchor),
                                    self.imageStackView.leadingAnchor.constraint(equalTo: self.imageScrollView.leadingAnchor),
                                    self.imageStackView.trailingAnchor.constraint(equalTo: self.imageScrollView.trailingAnchor),
                                    self.imageStackView.bottomAnchor.constraint(equalTo: self.imageScrollView.bottomAnchor)
                                ])
                                self.imageStackView.backgroundColor = .lightGray

                                let originalHeight = image.size.height
                                let originalWidth = image.size.width
                                let scaleFactor = scrollViewHeight / originalHeight

                                let imageView = UIImageView(image:image)
                                imageView.contentMode = .scaleAspectFit
                                imageView.clipsToBounds = true
                                self.imageStackView.addArrangedSubview(imageView)
                                NSLayoutConstraint.activate([
                                    imageView.heightAnchor.constraint(equalToConstant: scrollViewHeight),
                                    imageView.widthAnchor.constraint(equalToConstant: originalWidth * scaleFactor)
                                    // (??) heightAnchor만 설정하면 이미지가 안보인다.
                                    // (??) 'scrollViewHeight'와 같은 absolute value가 아닌 self.imageScrollView.frame.height로 하면 이미지가 안보인다. (Answer): UIKit의 LIfecycle에서 object의 constraint가 언제 calculate 되는지 알아볼 필오가 있다.
                                ])
                            }
                        } else {
                            print("Could not create UIImage from data")
                        }
                    } catch {
                        print("Error creating Data object from URL: \(error)")
                    }
                }
            }
            self.imageScrollView.contentSize.width=CGFloat(userPickedImages.count*210)
        }
    }
}
