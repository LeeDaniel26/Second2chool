//
//  NotificationViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 3/6/24.
//

import UIKit

class NotificationViewController: UIViewController {

    private var models = [NotificationCellType]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CommentNotificationTableViewCell.self, 
                           forCellReuseIdentifier: CommentNotificationTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
}

extension NotificationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = models[indexPath.row]
        switch cellType {
        case .comment(database: let database):
            let cell = tableView.dequeueReusableCell(withIdentifier: CommentNotificationTableViewCell.identifier) as! CommentNotificationTableViewCell
            
        }
    }
}
