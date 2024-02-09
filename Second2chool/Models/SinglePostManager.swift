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
            let decodedData = self.parseJSON(data: data)
            DispatchQueue.main.async {
                completed(decodedData)
            }
        }
        
        task.resume()        
    }
    
    func parseJSON(data: Foundation.Data) -> SinglePostDatabase? {
        do {
            let decodedData = try JSONDecoder().decode(SinglePostDatabase.self, from: data)
            return decodedData
        } catch {
            print("*************** parseJSON error: singlePostManager")
            return nil
        }
    }
    
}
