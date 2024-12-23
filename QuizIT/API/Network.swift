//
//  Network.swift
//  QuizIT
//
//  Created by Raphael Tarnoczi on 23.12.24.
//

import Foundation
import Alamofire

class Network: ObservableObject {
    private let baseUrl = "https://projekte.tgm.ac.at/quizit/api"
    private let headers: HTTPHeaders = [
        "authorization": ProcessInfo.processInfo.environment["API_KEY"] ?? ""
    ]
    @Published public var user: User? = nil
    
    
    
    func login(username: String, password: String, completion: @escaping (String?, Bool) -> Void) {
        let parameters: [String: Any] = [
            "userName": username,
            "password": password
        ]
        
        AF.request("\(self.baseUrl)/user/login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200..<300) 
            .responseDecodable(of: Response.self) { res in
                switch res.result {
                case .success(let response):
                    self.user = response.user
                    completion(nil, true)
                case .failure(let error):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 400...499:
                            print(res.data)
                            completion("Fehlerhafte Anfrage (Code: \(code))", false)
                        case 500...599:
                            completion("Serverfehler (Code: \(code))", false)
                        default:
                            print(error.localizedDescription)
                            completion("Unerwarteter Fehler (Code: \(code))", false)
                        }
                    } else {
                        completion("Request fehlgeschlagen! Begründung: \(error.localizedDescription)", false)
                    }
                }
            }
    }

}
