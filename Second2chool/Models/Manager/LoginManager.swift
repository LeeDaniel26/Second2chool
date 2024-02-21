//
//  LoginManager.swift
//  Second2chool
//
//  Created by Daniel Lee on 2023/04/29.
//

import GoogleSignIn
import FirebaseAuth
import Foundation

//protocol LoginManagerDelegate {
//    func didUpdateLogin(_ loginManager: LoginManager)
//}

class LoginManager {
    static let shared = LoginManager()
        
    private let host = "https://ceoshomework.store"
    
    var valid = false
    var username = ""
    var email = ""
    var password = ""
    var token = ""
    
    //MARK: - Google SignUp
    
    func postGoogleSignIn(
        signinType: String,
        nickname: String?,
        tokenString: String,
        clientId: String,
        completed: @escaping (GoogleSignInDatabase) -> ()
    ) {
        // Default signinType is LogIn
        var request = URLRequest(url: URL(string: "\(host)/api/v1/auth/login-mobile")!, timeoutInterval: Double.infinity)
        
        var body: [String:String] = [:]
        body = [
            "tokenString": tokenString,
            "clientId": clientId
        ]
        
        if signinType == "SignUp" {
            request = URLRequest(url: URL(string: "\(host)/api/v1/auth/signup-mobile")!, timeoutInterval: Double.infinity)
            body = [
                "nickname": nickname!,
                "tokenString": tokenString,
                "clientId": clientId
            ]
        }
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("refresh_token=eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzaGFya3NsZXlAZ21haWwuY29tIiwiZXhwIjoxNzA4OTkyNzMxfQ.ZFUgSwwQpryBdu16je6HAggyEjLNcjea-bszpNQHZnE", forHTTPHeaderField: "Cookie")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .fragmentsAllowed)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(String(describing: error))
                return
            }
            guard let decodedData = data.parseJSON(type: GoogleSignInDatabase.self) else {
                print("Error: Data retrieval failed -> (postGoogleSignUp)")
                return
            }
            data.prettyPrintJSON()
            self.token = decodedData.data.accessToken
            completed(decodedData)
        }
        task.resume()
    }
    
    //MARK: - GET
    
    func getCheckNickname(nickname: String, completed: @escaping (NicknameCheckDatabase) -> ()) {
        var request = URLRequest(url: URL(string: "\(host)/api/v1/auth/duplicate-nickname?nickname=a")!, timeoutInterval: Double.infinity)
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(String(describing: error))
                return
            }
            guard let decodedData = data.parseJSON(type: NicknameCheckDatabase.self) else {
                print("Error: Data retrieval failed -> (postGoogleSignUp)")
                return
            }
            data.prettyPrintJSON()
            DispatchQueue.main.async {
                completed(decodedData)
            }
        }
    }
    
    func logOut(completion: (Bool) -> ()) {
        do {
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            completion(true)
            return
        }
        catch {
            print(error)
            completion(false)
            return
        }
    }

}
