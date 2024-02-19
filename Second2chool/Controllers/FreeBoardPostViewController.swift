//
//  FreeBoardPostViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/05.
//

import UIKit

class FreeBoardPostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
        
    private var viewModels: [PostCellType] = []
    
    private let commentBarView = CommentBarView()
    private let singlePostManager = SinglePostManager()
    
    private var observer: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    
    private var post: SinglePostDatabase?
    var contents: Contents?
    
    var postId: Int?
    private var commentId: Int?
    private var isReply = false
    
    private var bottomConstraint: NSLayoutConstraint!
    private var originalBottomConstraint = 0.0
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(
            PosterCollectionViewCell.self,
            forCellReuseIdentifier: PosterCollectionViewCell.identifier
        )
        tableView.register(
            PostTitleCollectionViewCell.self,
            forCellReuseIdentifier: PostTitleCollectionViewCell.identifier
        )
        tableView.register(
            PostBodyCollectionViewCell.self,
            forCellReuseIdentifier: PostBodyCollectionViewCell.identifier
        )
        tableView.register(
            PostPhotosTableViewCell.self,
            forCellReuseIdentifier: PostPhotosTableViewCell.identifier
        )
        tableView.register(
            PostLikesCollectionViewCell.self,
            forCellReuseIdentifier: PostLikesCollectionViewCell.identifier
        )
        tableView.register(
            CommentCollectionViewCell.self,
            forCellReuseIdentifier: CommentCollectionViewCell.identifier
        )
        tableView.register(
            CommentReplyCollectionViewCell.self,
            forCellReuseIdentifier: CommentReplyCollectionViewCell.identifier
        )
        return tableView
    }()
    
    private let replyReceiverUsernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        if let customFont = UIFont(name: "NanumGothicExtraBold", size: 12) {
            label.font = customFont
        }
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let replyReceiverContentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        if let customFont = UIFont(name: "NanumGothicBold", size: 12) {
            label.font = customFont
        }
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let replyCancelButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let replyReceiverView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.alpha = 0.9
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bottomWhiteSpace: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FreeBoard"
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.backgroundColor = .systemBackground
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(replyReceiverView)
        replyReceiverView.addSubview(replyReceiverUsernameLabel)
        replyReceiverView.addSubview(replyReceiverContentLabel)
        replyReceiverView.addSubview(replyCancelButton)
        
        view.addSubview(commentBarView)
        view.addSubview(bottomWhiteSpace)
        commentBarView.delegate = self
        
        fetchPost()
        
        commentBarView.translatesAutoresizingMaskIntoConstraints = false
        bottomConstraint = commentBarView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        NSLayoutConstraint.activate([
            commentBarView.heightAnchor.constraint(greaterThanOrEqualToConstant: 52),
            commentBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomConstraint!
        ])
        
        replyCancelButton.addTarget(self, action: #selector(didTapCancelReply), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBoardPostViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FreeBoardPostViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        bottomWhiteSpace.frame = CGRect(x: 0,
                                        y: view.height-view.safeAreaInsets.bottom,
                                        width: view.width,
                                        height: view.safeAreaInsets.bottom)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        print()
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        originalBottomConstraint = bottomConstraint.constant
        UIView.animate(withDuration: 0.1) {
            self.bottomConstraint.constant = -keyboardFrame.size.height + 34
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        self.bottomConstraint.constant = self.originalBottomConstraint
        self.view.layoutIfNeeded()

        UIView.animate(withDuration: 0.01) {
        }
    }

    private func configureReplyView(receiver: String, content: String) {
        // Configure Data
        replyReceiverUsernameLabel.text = "Reply to \(receiver)"
        replyReceiverContentLabel.text = content
        replyCancelButton.addTarget(self, action: #selector(didTapCancelReply), for: .touchUpInside)
        
        // Set Constraints
        let viewHeight: CGFloat = 60
        let padding: CGFloat = 10
        let buttonSize: CGFloat = 18
        
        replyReceiverUsernameLabel.sizeToFit()
        replyReceiverContentLabel.sizeToFit()
        
        NSLayoutConstraint.activate([
            replyReceiverView.heightAnchor.constraint(equalToConstant: viewHeight),
            replyReceiverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            replyReceiverView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            replyReceiverView.bottomAnchor.constraint(equalTo: commentBarView.topAnchor),

            replyReceiverUsernameLabel.leadingAnchor.constraint(equalTo: replyReceiverView.leadingAnchor, constant: padding),
            replyReceiverUsernameLabel.trailingAnchor.constraint(equalTo: replyReceiverView.trailingAnchor, constant: -padding),
            replyReceiverUsernameLabel.topAnchor.constraint(equalTo: replyReceiverView.topAnchor, constant: 12),
            
            replyReceiverContentLabel.leadingAnchor.constraint(equalTo: replyReceiverView.leadingAnchor, constant: padding),
            replyReceiverContentLabel.trailingAnchor.constraint(equalTo: replyReceiverView.trailingAnchor, constant: -padding),
            replyReceiverContentLabel.topAnchor.constraint(equalTo: replyReceiverUsernameLabel.bottomAnchor, constant: 8),
            
            replyCancelButton.trailingAnchor.constraint(equalTo: replyReceiverView.trailingAnchor, constant: -padding-3),
            replyCancelButton.topAnchor.constraint(equalTo: replyReceiverView.topAnchor, constant: (viewHeight - buttonSize)/2),
            replyCancelButton.bottomAnchor.constraint(equalTo: replyReceiverView.bottomAnchor, constant: -(viewHeight - buttonSize)/2),
        ])
    }
    
    @objc private func didTapCancelReply() {
//        replyReceiverView.removeFromSuperview()
        replyReceiverView.isHidden = true
    }
    
    
    private func configureMockData() {
        let postData: [PostCellType] = [
            .poster(viewModel: PosterCollectionViewCellViewModel(
                profilePictureURL: URL(string: "www.google.com")!,
                username: "@Danny",
                editedDate: "2023-1-26")),
            .postTitle(viewModel: PostTitleCollectionViewCellViewModel(
                title: "This is Title")),
            .postBody(viewModel: PostBodyCollectionViewCellViewModel(
                body: "This is body text ~~~ ")),
            .likesCount(viewModel: PostLikesCollectionViewCellViewModel(
                likesCount: "100000",
                commentsCount: "10000")),
            .comment(viewModel:
                        CommentViewModel(
                            profilePictureURL: URL(string: "www.google.com")!,
                            id: 1,
                            parentId: nil,
                            ancestorId: nil,
                            likeCnt: 0,
                            content: "This is 1st comment.",
                            writerName: "@Dan1",
                            isAnon: false,
                            isLiked: false,
                            isWriter: false,
                            isPostWriter: false,
                            createdAt: "24-01-26",
                            updatedAt: "24-01-27",
                            child: [])
                    ),
            .comment(viewModel:              CommentViewModel(
                profilePictureURL: URL(string: "www.google.com")!,
                id: 2,
                parentId: nil,
                ancestorId: nil,
                likeCnt: 0,
                content: "This is 2nd comment.",
                writerName: "@Dan2",
                isAnon: false,
                isLiked: false,
                isWriter: false,
                isPostWriter: false,
                createdAt: "24-01-26",
                updatedAt: "24-01-27",
                child: [])
            )
        ]
        
        viewModels = postData
        tableView.reloadData()
    }
    
    // (중요) post in this VC and process done in getRequet seems different
    private func fetchPost() {
        SinglePostManager.shared.getRequest(with: postId!) { (decodedData) in
            guard let decodedData = decodedData else {
                print("Data retrieval error: FreeBoardPostViewController")
                return
            }
            self.createViewModel(post: decodedData)
            self.tableView.reloadData()
        }
    }
    
    private func createViewModel(post: SinglePostDatabase) {
        var postData: [PostCellType] = [
            .poster(viewModel: PosterCollectionViewCellViewModel(
                // (Mockdata)
                profilePictureURL: URL(string: "www.google.com")!,
                username: post.data.writerName,
                editedDate: post.data.createdAt)),
            .postTitle(viewModel: PostTitleCollectionViewCellViewModel(
                title: post.data.title)),
            .postBody(viewModel: PostBodyCollectionViewCellViewModel(
                body: post.data.content)),
            .postPhotos(viewModel: PostPhotosViewModel(
                photoList: post.data.photoList )),
            .likesCount(viewModel: PostLikesCollectionViewCellViewModel(
                likesCount: "10000",
                commentsCount: "\(post.data.commentCnt)")),
        ]
        
        for comment in post.data.commentList {
            postData.append(    // (Mock)
                .comment(viewModel: CommentViewModel(
                    profilePictureURL: URL(string: "www.google.com")!,
                    id: comment.id,
                    parentId: comment.parentId,
                    ancestorId: comment.ancestorId,
                    likeCnt: comment.likeCnt,
                    content: comment.content,
                    writerName: comment.writerName,
                    isAnon: comment.isAnon,
                    isLiked: comment.isLiked,
                    isWriter: comment.isWriter,
                    isPostWriter: comment.isPostWriter,
                    createdAt: comment.createdAt,
                    updatedAt: comment.updatedAt,
                    child: comment.child)))
            for reply in comment.child {
                postData.append(    // (Mock)
                    .commentReply(viewModel: CommentViewModel(
                        profilePictureURL: URL(string: "www.google.com")!,
                        id: reply.id,
                        parentId: reply.parentId,
                        ancestorId: reply.ancestorId,
                        likeCnt: reply.likeCnt,
                        content: reply.content,
                        writerName: reply.writerName,
                        isAnon: reply.isAnon,
                        isLiked: reply.isLiked,
                        isWriter: reply.isWriter,
                        isPostWriter: reply.isPostWriter,
                        createdAt: reply.createdAt,
                        updatedAt: reply.updatedAt,
                        child: reply.child)))
            }
        }
        
        
        
        self.viewModels = postData
        self.tableView.reloadData()
    }
    
    // MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = viewModels[indexPath.row]
        switch cellType {
        case .poster(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PosterCollectionViewCell.identifier,
                for: indexPath
            ) as? PosterCollectionViewCell else {
                fatalError()
            }
            //            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .postTitle(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PostTitleCollectionViewCell.identifier,
                for: indexPath
            ) as? PostTitleCollectionViewCell else {
                fatalError()
            }
            //            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .postBody(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PostBodyCollectionViewCell.identifier,
                for: indexPath
            ) as? PostBodyCollectionViewCell else {
                fatalError()
            }
            //            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .postPhotos(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PostPhotosTableViewCell.identifier,
                for: indexPath
            ) as? PostPhotosTableViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        case .likesCount(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: PostLikesCollectionViewCell.identifier,
                for: indexPath
            ) as? PostLikesCollectionViewCell else {
                fatalError()
            }
            //            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .comment(let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentCollectionViewCell.identifier,
                for: indexPath
            ) as? CommentCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        case .commentReply(viewModel: let viewModel):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: CommentReplyCollectionViewCell.identifier,
                for: indexPath
            ) as? CommentReplyCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cellType = viewModels[indexPath.row]
        if case .comment(let viewModel) = cellType {
            isReply = true
            commentId = viewModel.id
            
            // This is to show "Reply to (username) .." view over BarView
            configureReplyView(receiver: viewModel.writerName, content: viewModel.content)
            replyReceiverView.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = viewModels[indexPath.row]
        switch cellType {
        case .poster(_):
            return 60
        case .postTitle(_):
            return 60
        case .postBody(_):
            return UITableView.automaticDimension
        case .postPhotos(_):
            return UITableView.automaticDimension
        case .likesCount(_):
            return 40
        case .comment(_):
            return UITableView.automaticDimension
        case .commentReply(_):
            return UITableView.automaticDimension
        }
    }
}

extension FreeBoardPostViewController: CommentBarViewDelegate {
    func commentBarViewDidTapDone(_ commentBarView: CommentBarView, withText text: String) {
        if isReply == true {
            replyReceiverView.isHidden = true
            
            guard let commentId = commentId else {
                print("Error: commentId is nil")
                return
            }
                        
            CommentManager.shared.postReplyRequest(
                content: text,
                isAnon: false,    // (Mock)
                postId: postId!,
                commentId: commentId) { success in
                    self.fetchPost()
                    self.isReply = false
            }
        }
        else {
            CommentManager.shared.postRequest(
                content: text,
                isAnon: false,   // (Mock)
                postId: postId!) { success in
                    self.fetchPost()
            }
        }
    }
}

