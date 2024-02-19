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
    
    private let profileHeaderView = ProfileHeaderView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero,
                                    style: .grouped)
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var models = [[ProfileCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureModels()
        tableView.tableHeaderView = profileHeaderView
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
        
        profileHeaderView.frame = CGRect(x: 0,
                                         y: 0,
                                         width: view.width,
                                         height: view.height/4.2)
        profileHeaderView.delegate = self
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

extension ProfileViewController: ProfileHeaderViewDelegate {
    func didTapProfilePicture(_ view: ProfileHeaderView) {
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
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
//        StorageManager.shared.uploadProfilePicture(
//            username: user.username,
//            data: image.pngData()
//        ) { [weak self] success in
//            if success {
//                self?.headerViewModel = nil
//                self?.posts = []
//                self?.fetchProfileInfo()
//            }
//        }
    }
}

