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
        "authorization" : Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
    ]
    @Published public var user: User? = nil
    @Published public var subjects: [Subject]? = nil
    
    init() {
        self.user = UserManager.shared.loadUser()
    }
    
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
                                completion(reason, false)
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
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            self.subjects = response.subjects
                            completion(nil)
                        case 400...500:
                            if let reason = response.reason {
                                completion(reason)
                            }
                        default:
                            completion("Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion("Request failed! Reason: \(error.localizedDescription)")
                }
            }
    }
    
    func fetchFocus(id: Int, completion: @escaping ([Focus]?) -> Void) {
        AF.request("\(self.baseUrl)/focus?id=\(id)&year=\(self.user?.year ?? 1)&active=1", method: .get, headers: self.headers) //TODO: Sinnvollen Standardwert überlegen
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            completion(response.focus)
                        case 400...500:
                            if let reason = response.reason {
                                //TODO: Fehlerbehandlung
                                completion(nil)
                            }
                        default:
                            completion(nil)
                        }
                    }
                case .failure(let error):
                    completion(nil)
                }
            }
    }
    
    func editUserYear(newYear: Int, completion: @escaping (String?) -> Void) {
        let parameters: [String: Any] = [
            "userId": self.user?.id,
            "userYear": newYear
        ]
        
        AF.request("\(self.baseUrl)/user", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: Response.self) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            self.user = response.user
                            if let user = self.user {
                                UserManager.shared.saveUser(user: user)
                            }
                            completion(nil)
                        case 400...500:
                            if let reason = response.reason {
                                completion(reason)
                            }
                        default:
                            completion("Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion("Request failed! Reason: \(error.localizedDescription)")
                }
            }
    }
    
    func fetchFocusQuiz(id: Int, completion: @escaping ([Question]?, String?) -> Void) {
        AF.request("\(self.baseUrl)/quiz/focus?id=\(id)", method: .get, headers: self.headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            completion(response.questions, nil)
                        case 400...500:
                            if let reason = response.reason {
                                completion(nil, reason)
                            }
                        default:
                            completion(nil, "Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion(nil, "Request failed! Reason: \(error.localizedDescription)")
                }
            }
    }
    
    func fetchSubjectQuiz(id: Int, completion: @escaping ([Question]?, String?) -> Void) {}
    
    func postFocusResult(result: Result, completion: @escaping(String?) -> Void) {
        let parameters: [String: Any] = [
            "resultScore": result.score,
            "userId": result.userId,
            "focusId": result.focus?.id ?? 1 //TODO: Sinnvoller Standardwert
        ]
        
        AF.request("\(self.baseUrl)/result", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: Response.self) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 201:
                            completion(nil)
                        case 400...500:
                            if let reason = response.reason {
                                completion(reason)
                            }
                        default:
                            completion("Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion("Request failed! Reason: \(error.localizedDescription)")
                }
            }
    }

}
