//
//  UserManager.swift
//  Second2chool
//
//  Created by Daniel Lee on 2/21/24.
//

import Foundation

class UserManager {
    static let shared = UserManager()
    
    func getRequest(completed: @escaping (UserDatabase) -> ()) {
        var request = URLRequest(url: URL(string: "\(Constants.host)/api/v1/my/info")!, timeoutInterval: Double.infinity)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")
        request.addValue("refresh_token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJnQHRlc3QuY29tIiwiZXhwIjoxNzA4Nzk5OTczfQ.xtyMa8vrq9IF4Dqzawzx6OE-QONzcxu8wv7XwpX5GPs", forHTTPHeaderField: "Cookie")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(String(describing: error))
                return
            }
            guard let decodedData = data.parseJSON(type: UserDatabase.self) else {
                print("Error: Data retrieval failed -> (UserManager: getRequest)")
                return
            }
            data.prettyPrintJSON()
            DispatchQueue.main.async {
                completed(decodedData)
            }
        }
        task.resume()
    }
}
