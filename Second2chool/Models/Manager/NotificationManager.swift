//
//  NotificationManager.swift
//  Second2chool
//
//  Created by Daniel Lee on 3/6/24.
//

import Foundation

class NotificationManager {
        
    enum ReadType {
        case single
        case all
    }
    
    func getAllNotifications(completed: @escaping (NotificationDatabase?) -> ()) {
        var request = URLRequest(url: URL(string: "\(Constants.host)/api/v1/notifications")!, timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")
        request.addValue("refresh_token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJnQHRlc3QuY29tIiwiZXhwIjoxNzA4Nzk5OTczfQ.xtyMa8vrq9IF4Dqzawzx6OE-QONzcxu8wv7XwpX5GPs", forHTTPHeaderField: "Cookie")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(String(describing: error))
                return
            }
            guard let decodedData = data.parseJSON(type: NotificationDatabase.self) else {
                print("Error: Data retrieval failed -> (NotificationManager: getAllNotifications)")
                return
            }
            data.prettyPrintJSON()
            DispatchQueue.main.async {
                completed(decodedData)
            }
        }
        task.resume()
    }
    
    func readNotification(type: ReadType, notificationId: Int?, completed: @escaping () -> ()) {
        // Default type is .single
        var request = URLRequest(url: URL(string: "\(Constants.host)/api/v1/notifications/\(notificationId!)")!, timeoutInterval: Double.infinity)
        if type == .all {
            var request = URLRequest(url: URL(string: "\(Constants.host)/api/v1/notifications")!, timeoutInterval: Double.infinity)
        }
        
        request.httpMethod = "DELETE"
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(String(describing: error))
                return
            }
            guard let decodedData = data.parseJSON(type: NotificationDatabase.self) else {
                print("Error: Data retrieval failed -> (NotificationManager: readNotification)")
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
