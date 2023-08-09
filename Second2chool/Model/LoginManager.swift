//
//  LoginManager.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/04/29.
//

import Foundation
import GoogleSignIn

//protocol LoginManagerDelegate {
//    func didUpdateLogin(_ loginManager: LoginManager)
//}

class LoginManager {
        
    let postType: String
    
    let loginURL = "http://54.180.6.206:8080/api/v1/auth"
    
    var valid = false
    var username = ""
    var email = ""
    var password = ""
    var token = ""
        
    init(with postType: String) {
        self.postType = postType
    }
    
    
    //MARK: - GET

    func getRequest() {
        var request = URLRequest(url: URL(string: "http://54.180.6.206/oauth2/authorization/google?redirect_uri=http%3A%2F%2F54.180.6.206api%2Fv1%2Ftest")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }

    //MARK: - POST
    
    func postRequest() {
        var request = URLRequest(url: URL(string: "\(loginURL)")!)
        var body: [String: AnyHashable] = [:]
        
        if postType == "Login" {
            request = URLRequest(url: URL(string: "\(loginURL)/login")!,timeoutInterval: Double.infinity)
            body = [     // --> AnyHashable?
                "email": email,
                "password": password
            ]
        }
        if postType == "SignUp" {
            request = URLRequest(url: URL(string: "\(loginURL)/signup")!,timeoutInterval: Double.infinity)
            body = [
                "username": email,
                "email": email,
                "password": password
            ]
        }
        
        // Method
        request.httpMethod = "POST"
        // Header
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // Body
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print(String(data: data, encoding: .utf8)!)
//            let response = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
//            print(response!)
            if (self.postType == "Login") {
                self.parseJSOAN(data: data)
            }
        }
        print(body)
        task.resume()
    }
    
    func parseJSOAN(data: Foundation.Data) {
        do {
            let decodedData = try JSONDecoder().decode(LoginData.self, from: data)
            valid = (decodedData.status == "success") ? true : false
            token = decodedData.data.accessToken
        } catch {
            print(error)
        }
        
    }
    
    static let loginData = LoginManager(with: "Login")
}
