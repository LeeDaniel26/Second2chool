//
//  FreeBoardViewController.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/03/13.
//

import UIKit

class FreeBoardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var freeboardManager = FreeBoardManager()
    
    var currentPage = 0
    var totalPages = 0
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
    
    
    @IBAction func notificationButtonPressed(_ sender: UIButton) {
    }
    @IBAction func searchButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func prevButtonPressed(_ sender: UIButton) {
        
        if currentPage != 0 {
            currentPage -= 1
        }
        freeboardManager.getRequest(page: currentPage, size: size) {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        currentPage += 1
        if currentPage == totalPages {
            currentPage = totalPages-1
        }
        freeboardManager.getRequest(page: currentPage, size: size) {
            self.tableView.reloadData()
        }
    }
    
    // ??????
    @objc func back(sender: UIBarButtonItem) {
//        navigationController?.popToViewController(HomeViewController(), animated: true)
        let _ = self.navigationController?.popToViewController((self.navigationController?.viewControllers[1]) as! HomeViewController, animated: true)
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
        performSegue(withIdentifier: "FreeboardToFreeboardDetails", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
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
        totalPages = freeboardModel.totalPages
        cellCount = freeboardModel.cellCount
    }
}
