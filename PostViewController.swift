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
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var freeboard = FreeBoardManager()
    
    var userPickedImages = [UIImage]()
    
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
        
    }
    
    @IBAction func notificationButtonPressed(_ sender: UIBarButtonItem) {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0
        
        let phPicker = PHPickerViewController(configuration: config)
        phPicker.delegate = self
        present(phPicker, animated: true)
    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        
        freeboard.postRequest(
            title: titleTextField.text ?? "",
            content: bodyTextView.text ?? "",
            isAnon: false,
            commentOn: true,
            normalType: "FREE",
            photoList: [""]
        )
        
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
    
    
}

// Placeholder for UITextView 'bodyTextView'
extension PostViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
        textView.textColor = UIColor.label
    }
    
}

// Access Photo Library and select photos
extension PostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        for result in results {
            result.itemProvider.loadObject(ofClass: UIImage.self) { object, error in
                if let image = object as? UIImage {
                    self.userPickedImages.append(image)
                }
            }
        }
        for test in userPickedImages {
            print(test)
        }
    }
}
