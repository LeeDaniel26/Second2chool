//
//  ImageManager.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/07/26.
//

import UIKit

class ImageManager {
    
    var imageData = ""

    func getRequest() {
        let parameters = "<file contents here>"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "http://54.180.6.206:8080/api/v1/file/presign")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(LoginManager.loginData.token)", forHTTPHeaderField: "Authorization")
        request.addValue("text/plain", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "GET"
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
    
    func putRequest(imagePath: String) {
        let parameters = imagePath
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: imageData)!,timeoutInterval: Double.infinity)
        request.addValue("image/png", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "PUT"
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

    func parseJSON(data: Foundation.Data) {
        do {
            let decodedData = try JSONDecoder().decode(ImageData.self, from: data)

            // GET
            imageData = decodedData.data
            
        } catch {
            print(error)
        }
    }
}
