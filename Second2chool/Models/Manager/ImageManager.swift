//
//  ImageManager.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/07/26.
//

import UIKit

class ImageManager {
    static let shared = ImageManager()
    
    /// GET photo url
    func getPresignedRequest(completed: @escaping (SinglePostPhotoDatabase?) -> ()) {
        var request = URLRequest(url: URL(string: "https://ceoshomework.store/api/v1/file/presign")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")
        request.addValue("refresh_token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJnQHRlc3QuY29tIiwiZXhwIjoxNzA4Nzk5OTczfQ.xtyMa8vrq9IF4Dqzawzx6OE-QONzcxu8wv7XwpX5GPs", forHTTPHeaderField: "Cookie")
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let decodedData = data.parseJSON(type: SinglePostPhotoDatabase.self)
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
    
    func putChangeProfileImage(profileImageUrl: String, completed: @escaping () -> ()) {
        var request = URLRequest(url: URL(string: "\(Constants.host)/api/v1/user/profile-image")!, timeoutInterval: Double.infinity)
        
        let body: [String: String] = [
            "profileImageUrl": profileImageUrl
        ]
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")

        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
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
