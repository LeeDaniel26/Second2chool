//
//  FreeBoardViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/03/13.
//

import UIKit

class FreeBoardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
        
    let data = FreeBoardManager.freeboardData
    
    var currentPage = 0
    var size = 10
    var cellCount = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BoardCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "LilitaOne", size: 36)!]

        data.getRequest(page: currentPage, size: size)
    }
    
    // Go back to the previous ViewController while using Navigation Controller
    @IBAction func gobackButtonPressed(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func notificationButtonPressed(_ sender: UIButton) {
        if currentPage != 0 {
            currentPage -= 1
        }
        data.getRequest(page: currentPage, size: size)
        tableView.reloadData()
    }
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        currentPage += 1
        if currentPage == data.totalPages {
            currentPage = data.totalPages-1
        }
        data.getRequest(page: currentPage, size: size)
        tableView.reloadData()
    }
}
    
extension FreeBoardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.cellCount = self.data.cellCount
        DispatchQueue.main.async {
            tableView.reloadData()
        }
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! BoardCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.default
        cell.titleLabel.text = self.data.contents[indexPath.row].title
        cell.subtitleLabel.text = (self.data.contents[indexPath.row].isAnon == false) ? self.data.contents[indexPath.row].writerName : "Anonymity"
        DispatchQueue.main.async {
            tableView.reloadData()
        }
        return cell
    }
}

extension FreeBoardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print("===============================================")
        print(data.contents[indexPath.row].title)
        print(data.contents[indexPath.row].content)
        print(data.contents[indexPath.row].isAnon)

//        let freeboardShowVC = FreeBoardShowViewController(title: data.contents[indexPath.row].title, body: data.contents[indexPath.row].content)
//        navigationController?.pushViewController(freeboardShowVC, animated: true)
    }
}
