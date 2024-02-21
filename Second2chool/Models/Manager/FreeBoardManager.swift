//
//  FreeBoardManager.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/04/05.
//

import Foundation

class FreeBoardManager {
    
    static let shared = FreeBoardManager()
            
    let freeboardURL = "https://ceoshomework.store/api/v1/post"
        
    // FreeBoardData
    var contents = [Contents(id: 0, title: "", content: "", writerName: "", isAnon: false, isLiked: false, isScrapped: false, isWriter: false, commentOn: false, createdAt: "", updatedAt: "", commentCnt: 0, likeCnt: 0, scrapCnt: 0, photoCnt: 0)]
    var title = ""
    var content = ""
    var writerName = ""
    var isAnon = false
    var commentOn = false
    var normalType = "FREE"
    var photoList = [""]
    
    var id = 0
    var totalPages = 0
    var cellCount = 0
    
    // ImagePresignedData
    var imagePresignedData: ImagePresignedData?
    
    
    //MARK: - GET
    
    func getRequest(page: Int, size: Int, completed: @escaping (FreeBoardDatabase?) -> ()) {
//        var request = URLRequest(url: URL(string: "\(freeboardURL)/query?title=&content=&writer-name=&normal-type=FREE&page=\(page)&size=0\(size)&sort=id,asc")!,timeoutInterval: Double.infinity)
        var request = URLRequest(url: URL(string: "\(freeboardURL)/query?title=&content=&writer-name=&post-type=FREE&course-id=&page=\(page)&size=\(size)&sort=id,asc")!,timeoutInterval: Double.infinity)

        // Method
        request.httpMethod = "GET"
        // Header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")
        // Body
//        let body: [String: AnyHashable] = [:]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completed(nil)
                return
            }
            data.prettyPrintJSON()
            let decodedData = self.parseJSON(data: data)
            DispatchQueue.main.async {
                completed(decodedData)
            }
        }
        task.resume()
    }
    
    //MARK: - GET IMAGE PRESIGNED
    
    func getImagePresignedRequest() {
        var request = URLRequest(url: URL(string: "https://ceoshomework.store/api/v1/file/presign")!,timeoutInterval: Double.infinity)

        // Method
        request.httpMethod = "GET"
        // Header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")
        // Body
//        let body: [String: AnyHashable] = [:]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            guard let decodedData = data.parseJSON(type: ImagePresignedData.self) else {
                print("Error: Data retrieval failed  -> (getImagePresignedRequest)")
                return
            }
            data.prettyPrintJSON()
        }
        task.resume()
    }
        
    //MARK: - POST
    
    func postRequest(title: String, content: String, isAnon: Bool, commentOn: Bool, courseId: Int?, postType: String, reviewScore: Int?, photoList: [String]) {
        var request = URLRequest(url: URL(string: "\(freeboardURL)")!)
                
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")
        let body: [String: AnyHashable] = [     // --> AnyHashable?
            "title" : title,
            "content" : content,
            "isAnon" : isAnon,
            "commentOn" : commentOn,
            "courseId" : courseId,
            "postType" : postType,
            "reviewScore" : reviewScore,
            "photoList" : photoList
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(String(describing: error))
                return
            }
            let response = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            print(response!)
        }
        task.resume()
    }
    
    //MARK: - PUT IMAGE
    
    func putImageRequest(requestURL: String, imageURL: String) {
        var request = URLRequest(url: URL(string: "\(requestURL)")!)
                
        // Method
        request.httpMethod = "PUT"
        // Header
        request.addValue("image/png", forHTTPHeaderField: "Content-Type")
        // Body
        let parameters = "\(imageURL)"
        let postData = parameters.data(using: .utf8)
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    func parseJSON(data: Foundation.Data) -> FreeBoardDatabase? {   // *** "FreeBoardData?" why optional? --> To use "return nil" at catch.
        do {
            let decodedData = try JSONDecoder().decode(FreeBoardDatabase.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
}
