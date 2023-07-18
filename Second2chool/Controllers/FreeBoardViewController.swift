//
//  FreeBoardViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/03/13.
//

import UIKit

class FreeBoardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
        
    var freeboardManager = FreeBoardManager()
    
    var currentPage = 0
    var size = 10
    var cellCount = 0
    
    var contents: [Contents]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "LilitaOne", size: 36)!]
        
        freeboardManager.delegate = self
        
        freeboardManager.getRequest(page: currentPage, size: size) {
            self.tableView.reloadData()
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "BoardCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
    }
    
    // Go back to the previous ViewController while using Navigation Controller
//    @IBAction func gobackButtonPressed(_ sender: Any) {
//        _ = navigationController?.popViewController(animated: true)
//    }
    
    @IBAction func notificationButtonPressed(_ sender: UIButton) {
//        if currentPage != 0 {
//            currentPage -= 1
//        }
//        freeboardManager.getRequest(page: currentPage, size: size)
//        tableView.reloadData()
    }
    @IBAction func searchButtonPressed(_ sender: UIButton) {
//        currentPage += 1
//        if currentPage == data.totalPages {
//            currentPage = data.totalPages-1
//        }
//        freeboardManager.getRequest(page: currentPage, size: size)
//        tableView.reloadData()
    }
}
    
extension FreeBoardViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! BoardCell
//        cell.selectionStyle = UITableViewCell.SelectionStyle.default

        cell.titleLabel.text = contents![indexPath.row].title
        cell.subtitleLabel.text = (contents![indexPath.row].isAnon == false) ? contents![indexPath.row].writerName : "Anonymity"

        return cell
    }
}

extension FreeBoardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "FreeboardToFreeboardDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? FreeBoardShowViewController {
            destination.contents = contents![tableView.indexPathForSelectedRow!.row]
        }
    }
}

extension FreeBoardViewController: FreeBoardManagerDelegate {
    
    func didUpdateFreeBoard(freeboardModel: FreeBoardModel) {
        contents = freeboardModel.contents
        cellCount = freeboardModel.cellCount
    }
}
