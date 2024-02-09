//
//  FreeBoardPostViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/05.
//

import UIKit

class FreeBoardPostViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    private var collectionView: UICollectionView?
    
    private var viewModels: [PostCellType] = []
    
    private let commentBarView = CommentBarView()
    private let singlePostManager = SinglePostManager()
    
    private var observer: NSObjectProtocol?
    private var hideObserver: NSObjectProtocol?
    
    private var post: SinglePostDatabase?
    var contents: Contents?
    
    var postId: Int?
    
//    init(
//        post: SinglePostDatabase) {
//        self.post = post
//    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "FreeBoard"
        view.backgroundColor = .systemBackground
        
        view.addSubview(commentBarView)
        commentBarView.delegate = self
        observeKeyboardChange()
        
//        singlePostManager.delegate = self
        
        configureCollectionView()
//        configureMockData()
        fetchPost()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView?.frame = view.bounds
        commentBarView.frame = CGRect(
            x: 0,
            y: view.height-view.safeAreaInsets.bottom-70,
            width: view.width,
            height: 70
        )
    }
    
    private func observeKeyboardChange() {
        observer = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: .main
        ) { notification in
            guard let userInfo = notification.userInfo,
                  let height = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
                return
            }
            UIView.animate(withDuration: 0.2) {
                self.commentBarView.frame = CGRect(
                    x: 0,
                    y: self.view.height-60-height,
                    width: self.view.width,
                    height: 70
                )
            }
        }

        hideObserver = NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            UIView.animate(withDuration: 0.2) {
                self.commentBarView.frame = CGRect(
                    x: 0,
                    y: self.view.height-self.view.safeAreaInsets.bottom-70,
                    width: self.view.width,
                    height: 70
                )
            }
        }
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
        collectionView?.reloadData()
    }
    
    // (중요) post in this VC and process done in getRequet seems different
    private func fetchPost() {
        SinglePostManager.shared.getRequest(with: postId!) { (decodedData) in
            guard let decodedData = decodedData else {
                print("Data retrieval error: FreeBoardPostViewController")
                return
            }
            self.createViewModel(post: decodedData)
            self.collectionView?.reloadData()
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
        }
        
        self.viewModels = postData
        self.collectionView?.reloadData()
    }
    
    // MARK: - CollectionView
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = viewModels[indexPath.row]
        switch cellType {
        case .poster(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PosterCollectionViewCell.identifier,
                for: indexPath
            ) as? PosterCollectionViewCell else {
                fatalError()
            }
//            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .postTitle(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostTitleCollectionViewCell.identifier,
                for: indexPath
            ) as? PostTitleCollectionViewCell else {
                fatalError()
            }
//            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .postBody(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostBodyCollectionViewCell.identifier,
                for: indexPath
            ) as? PostBodyCollectionViewCell else {
                fatalError()
            }
//            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .likesCount(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: PostLikesCollectionViewCell.identifier,
                for: indexPath
            ) as? PostLikesCollectionViewCell else {
                fatalError()
            }
//            cell.delegate = self
            cell.configure(with: viewModel)
            return cell
        case .comment(let viewModel):
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CommentCollectionViewCell.identifier,
                for: indexPath
            ) as? CommentCollectionViewCell else {
                fatalError()
            }
            cell.configure(with: viewModel)
            return cell
//        case .commentReply(viewModel: let viewModel):
//            guard let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: CommentReplyCollectionViewCell.identifier,
//                for: indexPath
//            ) as? CommentReplyCollectionViewCell else {
//                fatalError()
//            }
//            return cell
        }
    }
}

extension FreeBoardPostViewController: CommentBarViewDelegate {
    func commentBarViewDidTapDone(_ commentBarView: CommentBarView, withText text: String) {
        guard let contents = contents else {
            print("NO CONTENTS..")
            return
        }
        CommentManager.shared.postRequest(
            content: text,
            isAnon: contents.isAnon,   // (Mock)
            postId: contents.id
        )
    }
    
    
}

extension FreeBoardPostViewController {
    func configureCollectionView() {
        let sectionHeight: CGFloat = 60*3 + 40 + 150
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { index, _ -> NSCollectionLayoutSection? in

                // Item
                let posterItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )

                let postTitleItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )

                let postBodyItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(150)
                    )
                )

                let likeCountItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(40)
                    )
                )

                let commentItem = NSCollectionLayoutItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(60)
                    )
                )

                // Group
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1),
                        heightDimension: .absolute(sectionHeight)
                    ),
                    subitems: [
                        posterItem,
                        postTitleItem,
                        postBodyItem,
                        likeCountItem,
                        commentItem
                    ]
                )

                // Section
                let section = NSCollectionLayoutSection(group: group)

                section.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0, bottom: 10, trailing: 0)

                return section
            })
        )

        view.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(
            PosterCollectionViewCell.self,
            forCellWithReuseIdentifier: PosterCollectionViewCell.identifier
        )
        collectionView.register(
            PostTitleCollectionViewCell.self,
            forCellWithReuseIdentifier: PostTitleCollectionViewCell.identifier
        )
        collectionView.register(
            PostBodyCollectionViewCell.self,
            forCellWithReuseIdentifier: PostBodyCollectionViewCell.identifier
        )
        collectionView.register(
            PostLikesCollectionViewCell.self,
            forCellWithReuseIdentifier: PostLikesCollectionViewCell.identifier
        )
        collectionView.register(
            CommentCollectionViewCell.self,
            forCellWithReuseIdentifier: CommentCollectionViewCell.identifier)

//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        self.collectionView = collectionView
    }
}

