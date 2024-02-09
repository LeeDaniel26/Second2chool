//
//  CommentManager.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/06.
//

import Foundation

class CommentManager {
    
    static let shared = CommentManager()
    
    let freeboardURL = "http://54.180.6.206:8080/api/v1/post"
    
    func postRequest(
        content: String,
        isAnon: Bool,
        postId: Int)
    {
        let parameters = "{\n\"content\":\"value1\",\n\"isAnon\":\"value2\",\n\"postId\":\"value2\"\n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "\(freeboardURL)/1/like")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.loginData.token)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "DELETE"
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
}
