//
//  SearchLikedPostsViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2/21/24.
//

import UIKit

class LikedPostsViewController: UIViewController, UITextFieldDelegate {
    
    private var likedPosts = [FreeBoardTableViewCellViewModel]()
    private var filteredPosts = [FreeBoardTableViewCellViewModel]()
    
    private var currentPage = 0
    private var size = 1000
    
    private var filtered = true
    
    private let searchBarField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search..."
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
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
        title = "Liked Posts"
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
            self.likedPosts = postsData.filter({
                $0.isLiked == true
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
        // (매우 중요):
        // replacingCharacters에서 range는 두가지 property로 location과 length를 갖는다. location은 바뀔(깜박이는 막대기 커서 왼쪽에 위치한)글자의 index(0부터 시작)이며 length는 그 글자를 바꿀 글자의 길이를 나타낸다. 그리고, string은 location이 가리키는 글자를 바꿀 length 길이의 글자를 나타낸다.
        // shouldChangeCharactersIn 함수는 한 character(ex: 'a')를 칠때마다 실행된다. 따라서, length는 1, string은 location이 가리키는 한 char을 대신할 한 char을 나타낸다.
        // 예를들어 currentText == "Hello"이고 키보드로 'o'를 지우는 그 시점에 location은 'o'의 index를 가리키는 4, string은 ' '(빈 글자(?)), length는 1을 나타낸다.
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
        filteredPosts = likedPosts.filter({
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

extension LikedPostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !filteredPosts.isEmpty {
            return filteredPosts.count
        }
        return filtered ? likedPosts.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardCell", for: indexPath) as! BoardCell
        if !filteredPosts.isEmpty {
            cell.configure(with: filteredPosts[indexPath.row])
        } else {
            cell.configure(with: likedPosts[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var postId: Int
        if !filteredPosts.isEmpty {
            postId = filteredPosts[indexPath.row].id
        } else {
            postId = likedPosts[indexPath.row].id
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
            id = likedPosts[indexPath.row].id
        }
        
        let deleteButton = UIContextualAction(style: .normal, title: nil) { [weak self] (action, view, completionHandler) in
            guard let self = self else { return }
            SinglePostManager.shared.postLike(postId: id, type: .delete) {
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
