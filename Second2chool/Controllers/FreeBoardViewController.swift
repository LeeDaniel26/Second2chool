//
//  FreeBoardViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/03/13.
//

import UIKit
import SwiftUI

struct Post {
    let title: String
    let subtitle: String
    let likesCount: String
    let commentsCount: String
}

class FreeBoardViewController: UIViewController {

    private var posts = [FreeBoardTableViewCellViewModel]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
        
    var currentPage = 0
    var totalPages = 0
    var size = 10
    var cellCount = 0
    
    var contents: [Contents]?
    
    var postId: Int?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "LilitaOne", size: 36)!]
  
        fetchPosts()
//        freeboardManager.getRequest(page: currentPage, size: size) {
//            self.tableView.reloadData()
//        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BoardCell", bundle: nil), forCellReuseIdentifier: "FreeBoardCell")
        
        tableView.layer.borderWidth = 1.2
        tableView.layer.borderColor = UIColor.label.cgColor
        tableView.separatorColor = UIColor.label
        
        prevButton.layer.cornerRadius = prevButton.frame.height / 2.05
        nextButton.layer.cornerRadius = nextButton.frame.height / 2.05
        
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.back(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    // Go back to the previous ViewController while using Navigation Controller
//    @IBAction func gobackButtonPressed(_ sender: Any) {
//        _ = navigationController?.popViewController(animated: true)
//    }
    
    func openSwiftUIScreen() {
        let swiftUIViewController = UIHostingController(rootView: SwiftUIViewTest())
        self.navigationController?.pushViewController(swiftUIViewController, animated: true)
    }
    
    @IBAction func notificationButtonPressed(_ sender: UIButton) {
    }
    @IBAction func profileButtonPressed(_ sender: UIBarButtonItem) {
        openSwiftUIScreen()
    }
    @IBAction func searchButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func prevButtonPressed(_ sender: UIButton) {
        
        if currentPage != 0 {
            currentPage -= 1
        }
        fetchPosts()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        currentPage += 1
        if currentPage == totalPages {
            currentPage = totalPages-1
        }
        fetchPosts()
    }
    
    // ??????
    @objc func back(sender: UIBarButtonItem) {
//        navigationController?.popToViewController(HomeViewController(), animated: true)
        let _ = self.navigationController?.popToViewController((self.navigationController?.viewControllers[1]) as! HomeViewController, animated: true)
    }
    
    private func fetchPosts() {
        FreeBoardManager.shared.getRequest(page: currentPage, size: size) { decodedData in
            guard let decodedData = decodedData else {
                print("Error in fetchPosts() decodedData: FreeBoardViewController")
                return
            }
            var postsData: [FreeBoardTableViewCellViewModel] = []
            for contents in decodedData.data.contents {
                postsData.append(FreeBoardTableViewCellViewModel(
                    title: contents.title,
                    subtitle: contents.isAnon == false ? contents.writerName : "Anonymity",
                    likesCount: "\(contents.likeCnt)",
                    commentsCount: "\(contents.commentCnt)",
                    id: contents.id))
            }
            
            self.posts = postsData
            self.tableView.reloadData()
        }
    }
}
    
extension FreeBoardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FreeBoardCell", for: indexPath) as! BoardCell
        cell.configure(with: posts[indexPath.row])
        return cell
    }
}

extension FreeBoardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        postId = posts[indexPath.row].id
        let vc = FreeBoardPostViewController()
        vc.postId = postId
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? FreeBoardShowViewController {
//            destination.contents = contents![tableView.indexPathForSelectedRow!.row]
//        }
//    }
}

extension FreeBoardViewController: FreeBoardManagerDelegate {
    
    func didUpdateFreeBoard(freeboardModel: FreeBoardModel) {
        contents = freeboardModel.contents
        totalPages = freeboardModel.totalPages
        cellCount = freeboardModel.cellCount
    }
}
