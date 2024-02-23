//
//  ScrappedPostsViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2/22/24.
//

import UIKit

class ScrappedPostsViewController: UIViewController, UITextFieldDelegate {
    
    private var scrappedPosts = [FreeBoardTableViewCellViewModel]()
    private var filteredPosts = [FreeBoardTableViewCellViewModel]()
    
    private var currentPage = 0
    private var size = 1000
    
    private var filtered = true
    
    private let searchBarField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderWidth = 1
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UINib(nibName: "BoardCell", bundle: nil), forCellReuseIdentifier: "FreeBoardCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Scrapped Posts"
        view.backgroundColor = .systemBackground

        view.addSubview(searchBarField)
        view.addSubview(tableView)
        setConstraints()
        
        fetchPosts()
        searchBarField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // (Mock: currentPage, size)
    private func fetchPosts() {
        FreeBoardManager.shared.getRequest(page: currentPage, size: size) { decodedData in
            guard let decodedData = decodedData else {
                print("Error: Faield -> SearchLikedPostsViewController: fetchPosts() decodedData")
                return
            }
            var postsData: [FreeBoardTableViewCellViewModel] = []
            for contents in decodedData.data.contents {
                postsData.append(FreeBoardTableViewCellViewModel(
                    title: contents.title,
                    content: contents.content,
                    subtitle: contents.isAnon == false ? contents.writerName : "Anonymity",
                    likesCount: "\(contents.likeCnt)",
                    commentsCount: "\(contents.commentCnt)",
                    id: contents.id,
                    isLiked: contents.isLiked,
                    isScrapped: contents.isScrapped))
            }
            self.scrappedPosts = postsData.filter({
                $0.isScrapped == true
            })
            self.tableView.reloadData()
        }
    }
    
    private func setConstraints() {
        let searchBarHeight: CGFloat = 45
        NSLayoutConstraint.activate([
            searchBarField.heightAnchor.constraint(equalToConstant: searchBarHeight),
            searchBarField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBarField.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
            
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        filterPosts(query: newText)
        if newText.isEmpty {
            filteredPosts.removeAll()
        }
        tableView.reloadData()
        return true
    }

    
    private func filterPosts(query: String) {
        filteredPosts = scrappedPosts.filter({
            $0.title.lowercased().contains(query.lowercased()) ||
            $0.content.lowercased().contains(query.lowercased())
        })
        if filteredPosts.isEmpty, !query.isEmpty {
            filtered = false
        } else {
            filtered = true
        }
    }
}

extension ScrappedPostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredPosts.isEmpty {
            return filteredPosts.count
        }
        return filtered ? scrappedPosts.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardCell", for: indexPath) as! BoardCell
        if !filteredPosts.isEmpty {
            cell.configure(with: filteredPosts[indexPath.row])
        } else {
            cell.configure(with: scrappedPosts[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var postId: Int
        if !filteredPosts.isEmpty {
            postId = filteredPosts[indexPath.row].id
        } else {
            postId = scrappedPosts[indexPath.row].id
        }
        let vc = FreeBoardPostViewController()
        vc.postId = postId
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var id: Int
        if !filteredPosts.isEmpty {
            id = filteredPosts[indexPath.row].id
        } else {
            id = scrappedPosts[indexPath.row].id
        }
        
        let deleteButton = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            SinglePostManager.shared.postScrap(postId: id, type: .delete) {
//                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.fetchPosts()
            }
            completionHandler(true)
        }
        deleteButton.image = UIImage(systemName: "trash")
        deleteButton.backgroundColor = .red
                
        let configuration = UISwipeActionsConfiguration(actions: [deleteButton])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
