//
//  PostViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/03/14.
//

import UIKit

class PostViewController: UIViewController {

    @IBOutlet var titleTextField: UITextField!
//    @IBOutlet var bodyTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    let data = FreeBoardManager.freeboardData
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bodyTextView.translatesAutoresizingMaskIntoConstraints = false
//        bodyTextView.sizeToFit()
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "LilitaOne", size: 36)!]
        

        // TEST

        NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
           
        NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
//    @IBAction func gobackButtonPressed(_ sender: UIButton) {
//
//        _ = navigationController?.popViewController(animated: true)
//
//    }
    
    @IBAction func postButtonPressed(_ sender: UIButton) {
        data.title = titleTextField.text!   //--> If UITextField is empty, it's not nil.. but "" instead. WTF???
//        data.content = bodyTextField.text!
        data.postRequest()
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
