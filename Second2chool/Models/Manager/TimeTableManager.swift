//
//  TimeTableManager.swift
//  Second2chool
//
//  Created by Daniel Lee on 3/3/24.
//

import Foundation

class TimeTableManager {
    static let shared = TimeTableManager()
    
    func postCourse(
        database: CourseDatabase)
    {
        var request = URLRequest(url: URL(string: "\(Constants.host)/api/v1/my/info")!, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "POST"
        
        // Body
        do {
            request.httpBody = try JSONEncoder().encode(database)
        }
        catch {
            print("Error: Data encoding failed -> TimeTableManager: postRequest()")
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(String(describing: error))
                return
            }
            data.prettyPrintJSON()  // response
        }

        task.resume()
    }
    
    func getSingleTimeTable(tableId: Int, completed: @escaping (SingleTimeTableDatabase?) -> ()) {
        var request = URLRequest(url: URL(string: "\(Constants.host)/api/v1/timetable/\(tableId)")!, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completed(nil)
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let decodedData = data.parseJSON(type: SingleTimeTableDatabase.self)
            DispatchQueue.main.async {
                completed(decodedData)
            }
        }
        
        task.resume()
    }
    
    func getMultipleTimeTable(completed: @escaping (MultipleTimeTableDatabase?) -> ()) {
        var request = URLRequest(url: URL(string: "\(Constants.host)/api/v1/my/timetable")!, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")

        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completed(nil)
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let decodedData = data.parseJSON(type: MultipleTimeTableDatabase.self)
            DispatchQueue.main.async {
                completed(decodedData)
            }
        }
        
        task.resume()
    }

}
