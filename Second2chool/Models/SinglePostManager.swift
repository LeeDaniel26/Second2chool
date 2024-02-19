//
//  SinglePostManager.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/06.
//

import Foundation

class SinglePostManager {
        
    static let shared = SinglePostManager()
    
    let freeboardURL = "https://ceoshomework.store/api/v1/post"
    
    func getRequest(with postId: Int, completed: @escaping (SinglePostDatabase?) -> ()) {
        var request = URLRequest(url: URL(string: "\(freeboardURL)/\(postId)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(LoginManager.loginData.token)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completed(nil)
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let decodedData = self.parseJSON(data: data, type: SinglePostDatabase.self)
            DispatchQueue.main.async {
                completed(decodedData)
            }
        }
        
        task.resume()        
    }
    
    /// GET photo url
    func getPresignedRequest(completed: @escaping (SinglePostPhotoDatabase?) -> ()) {
        var request = URLRequest(url: URL(string: "https://ceoshomework.store/api/v1/file/presign")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(LoginManager.loginData.token)", forHTTPHeaderField: "Authorization")
        request.addValue("refresh_token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJnQHRlc3QuY29tIiwiZXhwIjoxNzA4Nzk5OTczfQ.xtyMa8vrq9IF4Dqzawzx6OE-QONzcxu8wv7XwpX5GPs", forHTTPHeaderField: "Cookie")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let decodedData = self.parseJSON(data: data, type: SinglePostPhotoDatabase.self)
            DispatchQueue.main.async {
                completed(decodedData)
            }
        }
        
        task.resume()
    }
    
    func putPresignedRequest(with imageURL: String, data: String, completed: @escaping () -> ()) {
        let postData = try? NSData(contentsOfFile: imageURL, options: []) as Foundation.Data
        
        var request = URLRequest(url: URL(string: data)!,timeoutInterval: Double.infinity)
        request.addValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "PUT"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            DispatchQueue.main.async {
                completed()
            }
        }
        
        task.resume()
    }

    // (중요): Reusable parseJSON for variety of return database types
    func parseJSON<T: Decodable>(data: Foundation.Data, type: T.Type) -> T? {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("*************** parseJSON error: singlePostManager")
            return nil
        }
    }
//    func parseJSON(data: Foundation.Data) -> SinglePostDatabase? {
//        do {
//            let decodedData = try JSONDecoder().decode(SinglePostDatabase.self, from: data)
//            return decodedData
//        } catch {
//            print("*************** parseJSON error: singlePostManager")
//            return nil
//        }
//    }
    
}





















///// PUT upload photo to url got from 'getPresignedRequest'
//func putPresignedRequest(to dataURLString: String, with imageURLString: String, completed: @escaping () -> ()) {
//    let parameters = [
//        [
//            "key": "file",
//            "src": imageURLString,
//            "type": "file"
//        ]] as [[String: Any]]
//    
//    let boundary = "Boundary-\(UUID().uuidString)"
//    var body = NSMutableData()
//    
//    for param in parameters {
//        if param["disabled"] != nil { continue }
//        let paramName = param["key"]!
//        body.append("--\(boundary)\r\n".data(using: .utf8)!)
//        body.append("Content-Disposition:form-data; name=\"\(paramName)\"".data(using: .utf8)!)
//        
//        if param["contentType"] != nil {
//            body.append("\r\nContent-Type: \(param["contentType"] as! String)".data(using: .utf8)!)
//        }
//        
//        let paramType = param["type"] as! String
//        if paramType == "text" {
//            let paramValue = param["value"] as! String
//            body.append("\r\n\r\n\(paramValue)\r\n".data(using: .utf8)!)
//        } else {
//            let paramSrc = param["src"] as! String
//            if let fileData = try? NSData(contentsOfFile: paramSrc, options: []) as Foundation.Data {
//                body.append("; filename=\"\(paramSrc)\"\r\n".data(using: .utf8)!)
//                body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
//                body.append(fileData)
//                body.append("\r\n".data(using: .utf8)!)
//            }
//        }
//    }
//    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//    
//    var request = URLRequest(url: URL(string: dataURLString)!,timeoutInterval: Double.infinity)
//    request.addValue("Bearer \(LoginManager.loginData.token)", forHTTPHeaderField: "Authorization")
//    request.addValue("refresh_token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJnQHRlc3QuY29tIiwiZXhwIjoxNzA4NzgzNTQ5fQ.H_5Tv8Q4vLMt_RTdQPf26mt8EioHXVwYj752wvQFzis", forHTTPHeaderField: "Cookie")
//    request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//    
//    request.httpMethod = "PUT"
//    request.httpBody = body as Foundation.Data
//    
//    let task = URLSession.shared.dataTask(with: request) { data, response, error in
//        guard let data = data else {
//            print(String(describing: error))
//            return
//        }
//        print(String(data: data, encoding: .utf8)!)
//        DispatchQueue.main.async {
//            completed()
//        }
//    }
//    task.resume()
//}
