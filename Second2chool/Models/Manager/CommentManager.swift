//
//  CommentManager.swift
//  Second2chool
//
//  Created by Daniel Lee on 2024/02/06.
//

import Foundation

class CommentManager {
    
    static let shared = CommentManager()
    
    let urlString = "https://ceoshomework.store/api/v1/comment"
    
    func postRequest(
        content: String,
        isAnon: Bool,
        postId: Int,
        completed: @escaping (Bool) -> ())
    {
        var request = URLRequest(url: URL(string: urlString)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")
        request.addValue("refresh_token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhQHRlc3QuY29tIiwiZXhwIjoxNzA4MTcwNjY1fQ.-lD3rRdTCAEq_gREjDjYP2e1kboyGPNbb_WyyXCvK6Y", forHTTPHeaderField: "Cookie")

        request.httpMethod = "POST"

        let body: [String: AnyHashable] = [     // --> AnyHashable?
            "content" : content,
            "isAnon" : isAnon,
            "postId" : postId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(String(describing: error))
                completed(false)
                return
            }
            print("!!!!!!!!!!!!!!!!!!!!\(String(data: data, encoding: .utf8)!)")
            DispatchQueue.main.async {
                completed(true)
            }
        }

        task.resume()
    }

    func postReplyRequest(
        content: String,
        isAnon: Bool,
        postId: Int,
        commentId: Int,
        completed: @escaping (Bool) -> ())
    {
        var request = URLRequest(url: URL(string: "\(urlString)/\(commentId)")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")
        request.addValue("refresh_token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhQHRlc3QuY29tIiwiZXhwIjoxNzA4MTcwNjY1fQ.-lD3rRdTCAEq_gREjDjYP2e1kboyGPNbb_WyyXCvK6Y", forHTTPHeaderField: "Cookie")

        request.httpMethod = "POST"

        let body: [String: AnyHashable] = [     // --> AnyHashable?
            "content" : content,
            "isAnon" : isAnon,
            "postId" : postId
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(String(describing: error))
                completed(false)
                return
            }
            print("!!!!!!!!!!!!!!!\(String(data: data, encoding: .utf8)!)")
            DispatchQueue.main.async {
                completed(true)
            }
        }

        task.resume()
    }

    
    
//    func postReplyRequest(
//        content: String,
//        isAnon: Bool,
//        postId: Int,
//        completed: @escaping (Bool) -> ())
//    {
//        print("$$$$$$$$$$$$$$$$$$$$$$$ \(postId)")
//        var request = URLRequest(url: URL(string: "\(urlString)/12")!,timeoutInterval: Double.infinity)
//
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(LoginManager.loginData.token)", forHTTPHeaderField: "Authorization")
//        request.addValue("refresh_token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhQHRlc3QuY29tIiwiZXhwIjoxNzA4MTcwNjY1fQ.-lD3rRdTCAEq_gREjDjYP2e1kboyGPNbb_WyyXCvK6Y", forHTTPHeaderField: "Cookie")
//
//        request.httpMethod = "POST"
//
//        let body: [String: AnyHashable] = [     // --> AnyHashable?
//            "content" : content,
//            "isAnon" : isAnon,
//            "postId" : postId
//        ]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
//
//        let task = URLSession.shared.dataTask(with: request) { data, response, error in
//            guard let data = data, error == nil else {
//                print(String(describing: error))
//                print("Error: Reply Comment retrieval failed.")
//                completed(false)
//                return
//            }
//            print("!!!!!!!!!!!!\(String(data: data, encoding: .utf8)!)")
//            DispatchQueue.main.async {
//                completed(true)
//            }
//        }
//
//        task.resume()
//    }

}

