//
//  FreeBoardManager.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/04/05.
//

import Foundation

protocol FreeBoardManagerDelegate {
    func didUpdateFreeBoard(freeboardModel: FreeBoardModel)
}

class FreeBoardManager {
    
    static let shared = FreeBoardManager()
            
    let freeboardURL = "https://ceoshomework.store/api/v1/post"
    
    // Delegates
    var delegate: FreeBoardManagerDelegate?
    
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
    
    func getRequest(page: Int, size: Int, completed: @escaping (FreeBoardData?) -> ()) {
//        var request = URLRequest(url: URL(string: "\(freeboardURL)/query?title=&content=&writer-name=&normal-type=FREE&page=\(page)&size=0\(size)&sort=id,asc")!,timeoutInterval: Double.infinity)
        var request = URLRequest(url: URL(string: "\(freeboardURL)/query?title=&content=&writer-name=&post-type=FREE&course-id=&page=\(page)&size=\(size)&sort=id,asc")!,timeoutInterval: Double.infinity)

        // Method
        request.httpMethod = "GET"
        // Header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.loginData.token)", forHTTPHeaderField: "Authorization")
        // Body
//        let body: [String: AnyHashable] = [:]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completed(nil)
                return
            }
            print(String(data: data, encoding: .utf8)!)
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
        request.addValue("Bearer \(LoginManager.loginData.token)", forHTTPHeaderField: "Authorization")
        // Body
//        let body: [String: AnyHashable] = [:]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            self.parseJSONImagePresigned(data: data)
        
        }
        task.resume()
    }
        
    //MARK: - POST
    
    func postRequest(title: String, content: String, isAnon: Bool, commentOn: Bool, courseId: Int?, postType: String, reviewScore: Int?, photoList: [String]) {
        var request = URLRequest(url: URL(string: "\(freeboardURL)")!)
        
//        for imagePath in photoList {
//            getImagePresignedRequest()
//            guard let imageData = self.imagePresignedData else {
//                print("Error occurred while retrieving ImagePresignedData..")
//                return
//            }
//            putImageRequest(requestURL: imageData.data, imageURL: imagePath)
//        }
        
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
    
    func parseJSON(data: Foundation.Data) -> FreeBoardData? {   // *** "FreeBoardData?" why optional? --> To use "return nil" at catch.
        do {
            let decodedData = try JSONDecoder().decode(FreeBoardData.self, from: data)
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
    func parseJSONImagePresigned(data: Foundation.Data) {
        do {
            let decodedData = try JSONDecoder().decode(ImagePresignedData.self, from: data)
            self.imagePresignedData = decodedData
        } catch {
            print(error)
        }
    }
}
