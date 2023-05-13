//
//  FreeBoardManager.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/04/05.
//

import Foundation

protocol FreeBoardManagerDelegate {
    func didUpdateFreeBoard(_ freeboardManager: FreeBoardManager, dataModel: DataModel)
}

class FreeBoardManager {
        
    let postType: String
    
    let freeboardURL = "http://54.180.6.206:8080/api/v1/post"
    
    var contents = [Contents(id: 0, title: "", content: "", writerName: "", isAnon: false, isLiked: false, isScrapped: false, isWriter: false, commentOn: false, createdTime: "", lastModifiedTime: "", commentCnt: 0, likeCnt: 0, scrapCnt: 0)]
    
    var title = ""
    var content = ""
    var writerName = ""
    var isAnon = false
    var commentOn = false
    var normalType = "FREE"
    
    var id = 0
    var totalPages = 0
    var cellCount = 0

    init(with postType: String) {
        self.postType = postType
    }
    
    //MARK: - GET
    
    func getRequest(page: Int, size: Int) {
        var request = URLRequest(url: URL(string: "\(freeboardURL)/query?title=&content=&writer-name=&normal-type=FREE&page=\(page)&size=\(size)&sort=")!,timeoutInterval: Double.infinity)

        // Method
        request.httpMethod = "GET"
        // Header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.loginData.token)", forHTTPHeaderField: "Authorization")
        // Body
        let body: [String: AnyHashable] = [:]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            self.parseJSON(data: data)
        }
        task.resume()
    }
        
    //MARK: - POST
    
    func postRequest() {
        var request = URLRequest(url: URL(string: "\(freeboardURL)")!)
        
        // Default Value
        isAnon = false
        
        // Method
        request.httpMethod = "POST"
        // Header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.loginData.token)", forHTTPHeaderField: "Authorization")
        // Body
        let body: [String: AnyHashable] = [     // --> AnyHashable?
            "title" : title,
            "content" : content,
            "isAnon" : isAnon,
            "commentOn" : commentOn,
            "normalType" : normalType
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            let response = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            print(response!)
        }
        task.resume()
    }
    
    func parseJSON(data: Foundation.Data) {
        do {
            let decodedData = try JSONDecoder().decode(FreeBoardData.self, from: data)
            // GET
            contents = decodedData.data.contents
            title = decodedData.data.contents[id].title
            writerName = decodedData.data.contents[id].writerName
            isAnon = decodedData.data.contents[id].isAnon
            totalPages = decodedData.data.totalPages
            cellCount = decodedData.data.numberOfElements
        } catch {
            print(error)
        }
    }
    
    static let freeboardData = FreeBoardManager(with: "FreeBoard")
}
