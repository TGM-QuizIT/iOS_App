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
    @Published public var subjects: [Subject]? = nil
    
    
    
    func login(username: String, password: String, completion: @escaping (String?, Bool) -> Void) {
        let parameters: [String: Any] = [
            "userName": username,
            "password": password
        ]
        
        AF.request("\(self.baseUrl)/user/login", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: Response.self) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            self.user = response.user
                            completion(nil, true)
                        case 400...500:
                            if let reason = response.reason {
                                if reason == "Invalid Credentials" {
                                    completion(reason, false)
                                }
                                else {
                                    completion(reason, false)
                                }
                            }
                        default:
                            completion("Unhandeled HTTP-Code", false)
                        }
                    }
                case .failure(let error):
                    completion("Request failed! Reason: \(error.localizedDescription)", false)
                }
            }
    }
    
    func fetchSubjects(completion: @escaping (String?) -> Void) {
        AF.request("\(self.baseUrl)/subject?id=\(self.user?.id ?? 1)", method: .get, headers: self.headers) //TODO: Sinnvollen Standardwert überlegen
            .validate(statusCode: 200..<300)
            .responseDecodable(of: Response.self) { res in
                switch res.result {
                case .success(let response):
                    self.subjects = response.subjects
                    completion(nil)
                case .failure(let error):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 400...499:
                            completion("Fehlerhafte Anfrage (Code: \(code))")
                        case 500...599:
                            completion("Serverfehler (Code: \(code))")
                        default:
                            completion("Unerwarteter Fehler (Code: \(code))")
                        }
                    }
                    else {
                        completion("Request fehlgeschlagen! Begründung: \(error.localizedDescription)")
                    }
                }
            }
    }

}
