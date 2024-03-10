//
//  FullscreenImageViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 3/1/24.
//

import UIKit

class FullscreenImageViewController: UIViewController {
    
    var currentImageIndex: Int?
    var imageURL: [String]?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.contentInsetAdjustmentBehavior = .never  // This prevents scrollView to move around. Only scroll is available.
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.widthAnchor.constraint(equalToConstant: view.width * CGFloat(imageURL!.count)),
            contentView.heightAnchor.constraint(equalToConstant: view.height),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        // Assume that `images` is an array of your images
        for i in 0..<imageURL!.count {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFit
            imageView.sd_setImage(with: URL(string: imageURL![i]))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(imageView)
            
            let x = view.width * CGFloat(i)
            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: view.width),
                imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: x),
                imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
                imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
           view.addGestureRecognizer(tap)
    }
    
    // This makes Bar disappear smoothly
    @objc func handleTap() {
        if let isHidden = navigationController?.navigationBar.isHidden, isHidden {
            // If the navigation bar is currently hidden, show it
            navigationController?.setNavigationBarHidden(false, animated: false)
            navigationController?.navigationBar.alpha = 0.0
            UIView.animate(withDuration: 0.2) {
                self.navigationController?.navigationBar.alpha = 1.0
                self.view.backgroundColor = .systemBackground
            }
        } else {
            // If the navigation bar is currently shown, hide it
            UIView.animate(withDuration: 0.2, animations: {
                self.navigationController?.navigationBar.alpha = 0.0
                self.view.backgroundColor = .black
            }, completion: { _ in
                self.navigationController?.setNavigationBarHidden(true, animated: false)
            })
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let point = CGPoint(x: view.bounds.width * CGFloat(currentImageIndex!), y: 0)
        scrollView.setContentOffset(point, animated: false)
    }
}
