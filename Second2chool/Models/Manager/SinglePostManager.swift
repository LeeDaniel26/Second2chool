//
//  SinglePostManager.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/06.
//

import Foundation

enum PostType {
    case post
    case delete
}

class SinglePostManager {
        
    static let shared = SinglePostManager()
    
    let freeboardURL = "https://ceoshomework.store/api/v1/post"
    
    func getRequest(with postId: Int, completed: @escaping (SinglePostDatabase?) -> ()) {
        var request = URLRequest(url: URL(string: "\(freeboardURL)/\(postId)")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completed(nil)
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let decodedData = data.parseJSON(type: SinglePostDatabase.self)
            DispatchQueue.main.async {
                completed(decodedData)
            }
        }
        
        task.resume()        
    }
    
    func postLike(postId: Int, type: PostType, completed: @escaping () -> ()) {
        var request = URLRequest(url: URL(string: "\(Constants.host)/api/v1/post/\(postId)/like")!,timeoutInterval: Double.infinity)

        request.httpMethod = "POST"
        if type == .delete {
            request.httpMethod = "DELETE"
        }
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            data.prettyPrintJSON()
            DispatchQueue.main.async {
                completed()
            }
        }
        
        task.resume()
    }
    
    func postScrap(postId: Int, type: PostType, completed: @escaping () -> ()) {
        var request = URLRequest(url: URL(string: "\(Constants.host)/api/v1/post/\(postId)/scrap")!,timeoutInterval: Double.infinity)

        request.httpMethod = "POST"
        if type == .delete {
            request.httpMethod = "DELETE"
        }
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            data.prettyPrintJSON()
            DispatchQueue.main.async {
                completed()
            }
        }
        
        task.resume()
    }

}
