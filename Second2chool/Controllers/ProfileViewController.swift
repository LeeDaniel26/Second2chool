//
//  ProfileViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/01/28.
//

import UIKit

struct ProfileCellModel {
    let title: String
    let handler: (() -> Void)
}

class ProfileViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .grouped)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        // Get name (unfinished)
        return label
    }()
    
    private let majorLabel: UILabel = {     // (ask)
        let label = UILabel()
        // Get major (unfinished)
        return label
    }()
    
    private let totalPostsLabel: UILabel = {
        let label = UILabel()
        if let customFont = UIFont(name: "NanumGothicBold", size: 14) {
            label.font = customFont
        }
        label.text = "Total Posts"
        label.textColor = .yellow
        return label
    }()
    
    
    private let totalCommentsLabel: UILabel = {
        let label = UILabel()
        if let customFont = UIFont(name: "NanumGothicBold", size: 14) {
            label.font = customFont
        }
        label.text = "Total Comments"
        label.textColor = .yellow
        return label

    }()
    
    private let countTotalPostsLabel: UILabel = {
        let label = UILabel()
        // Get total number of posts (unfinished)
        return label
    }()
    
    private let countTotalCommentsLabel: UILabel = {
        let label = UILabel()
        // Get total number of comments (unfinished)
        return label
    }()
    
    private var models = [[ProfileCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        tableView.tableHeaderView = createTableHeaderView()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    private func createTableHeaderView() -> UIView {
        let header = UIView(frame: CGRect(x: 0,
                                          y: 0,
                                          width: view.width,
                                          height: view.height/4.2).integral)
        header.backgroundColor = UIColor(rgb: 0xEB455F)
        let size = header.height/2.1
        let profilePhotoButton = UIButton(frame: CGRect(x: view.width - size - view.width/32,
                                                        y: (header.height-size)/2,
                                                        width: size,
                                                        height: size))
        header.addSubview(profilePhotoButton)
        profilePhotoButton.layer.masksToBounds = true
        profilePhotoButton.layer.cornerRadius = size/2.0
        
        // TEST
        header.layer.borderWidth = 1
        header.layer.borderColor = UIColor.label.cgColor
        
        profilePhotoButton.tintColor = .label
        profilePhotoButton.addTarget(self,
                                     action: #selector(didTapProfilePhotoButton),
                                     for: .touchUpInside)
        profilePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"),
                                              for: .normal)
        profilePhotoButton.layer.borderWidth = 1
        profilePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        
        header.addSubview(totalPostsLabel)
        header.addSubview(totalCommentsLabel)
        
        var label = totalPostsLabel
        label.sizeToFit()
        label.frame.origin.x = header.width/16
        label.frame.origin.y = header.height - label.frame.size.height - header.height/3.5
        
        label = totalCommentsLabel
        label.sizeToFit()
        label.frame.origin.x = totalPostsLabel.frame.origin.x + label.frame.size.width + 7
        label.frame.origin.y = header.height - label.frame.size.height - header.height/3.5

        
        return header
    }
    
    
    private func configureModels() {
        models.append([
            ProfileCellModel(title: "Options") { [weak self] in
                self?.didTapOptions()
            }
        ])
        
        models.append([
            ProfileCellModel(title: "User Information") { [weak self] in
                self?.didTapUserInformation()
            },
            ProfileCellModel(title: "Change Nickname") { [weak self] in
                self?.didTapChangeNickname()
            }
        ])
        
        models.append([
            ProfileCellModel(title: "My Posts") { [weak self] in
                self?.didTapMyPosts()
            },
            ProfileCellModel(title: "Favorite Posts") { [weak self] in
                self?.didTapFavoritePosts()
            },
            ProfileCellModel(title: "My Comments") { [weak self] in
                self?.didTapMyComments()
            }
        ])
        
        models.append([
            ProfileCellModel(title: "Log Out") { [weak self] in
                self?.didTapLogOut()
            }
        ])
    }
    
    @objc private func didTapProfilePhotoButton() {
        
    }
    
    private func didTapOptions() {
        
    }
    
    private func didTapUserInformation() {
        
    }
    
    private func didTapChangeNickname() {
        
    }
    
    private func didTapMyPosts() {
        
    }
    
    private func didTapFavoritePosts() {
        
    }
    
    private func didTapMyComments() {
        
    }
    
    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "Log Out",
                                            message: "Are you sure you want to log out?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                            style: .destructive, handler: { _ in
            // Logout process (unfinished)
        }))
        
        actionSheet.popoverPresentationController?.sourceView = tableView           // ???
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds    // ???
        // It seems not doiing this results in a crsh in iPad because 'actionSheet' doesn't know how to present itself..?
        present(actionSheet, animated: true)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.section][indexPath.row].title
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        models[indexPath.section][indexPath.row].handler()
    }
}
