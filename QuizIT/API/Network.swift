//
//  Network.swift
//  QuizIT
//
//  Created by Raphael Tarnoczi on 23.12.24.
//

import Foundation
import Alamofire

class Network: ObservableObject {
    private let baseUrl = "http://192.168.0.237:63000"
    private let actualUrl = "https://projekte.tgm.ac.at/quizit/api"
    private let headers: HTTPHeaders = [
        "authorization" : Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
    ]
    @Published public var user: User? = nil
    @Published public var subjects: [Subject]? = nil
    @Published public var friendships: [Friendship]? = nil
    
    init() {
        let user = User(id: 1, name: "rtarnoczi", fullName: "Raphael Tarnoczi", year: 4, uClass: "5AHIT", role: "schueler") //TODO: Raphael um Login zu umgehen
        UserManager.shared.saveUser(user: user)
        self.user = UserManager.shared.loadUser()
    }
    
    /*------------User-Requests---------------*/
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
    
    func editUserYear(newYear: Int, completion: @escaping (String?) -> Void) {
        let parameters: [String: Any] = [
            "userId": self.user?.id as Any,
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
    
    func fetchUserStats(completion: @escaping(Statistic? ,String?) -> Void) {
        AF.request("\(self.baseUrl)/user/stats?id=\(self.user?.id ?? 1)", method: .get, headers: self.headers) //TODO: Sinnvollen Standardwert überlegen
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            completion(response.stats, nil)
                        case 400...500:
                            completion(nil, response.reason)
                        default:
                            completion(nil, "Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion(nil, "Request failed! Reason: \(error.localizedDescription)")
                }
            }
    }
    
    func fetchAllUsers(completion: @escaping([User]? ,String?) -> Void) {
        AF.request("\(self.baseUrl)/user", method: .get, headers: self.headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            completion(response.users, nil)
                        case 400...500:
                            completion(nil, response.reason)
                        default:
                            completion(nil, "Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion(nil, "Request failed! Reason: \(error.localizedDescription)")
                }
            }
    }
    
    /*------------Subject-Requests---------------*/
    func fetchSubjects(completion: @escaping (String?) -> Void) {
        AF.request("\(self.baseUrl)/subject?id=\(self.user?.id ?? 1)", method: .get, headers: self.headers) //TODO: Sinnvollen Standardwert überlegen
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            if let subjects = response.subjects {
                                self.subjects = subjects.sorted {$0.name < $1.name}
                                completion(nil)
                            }
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
    
    /*------------Focus-Requests---------------*/
    func fetchFocus(id: Int, completion: @escaping ([Focus]?) -> Void) {
        AF.request("\(self.baseUrl)/focus?id=\(id)&year=\(self.user?.year ?? 1)&active=1", method: .get, headers: self.headers) //TODO: Sinnvollen Standardwert überlegen
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            if let focuses = response.focuses {
                                completion(focuses.sorted {$0.name < $1.name})
                            }
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
    
    /*------------Quiz-Requests---------------*/

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
    
    func fetchSubjectQuiz(id: Int, completion: @escaping ([Question]?, String?) -> Void) {
        AF.request("\(self.baseUrl)/quiz/subject?id=\(id)", method: .get, headers: self.headers)
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
    
    /*------------Result-Requests---------------*/
    func postFocusResult(score: Double, focusId: Int , completion: @escaping(Result?, String?) -> Void) {
        let parameters: [String: Any] = [
            "resultScore": score*20,
            "userId": self.user?.id as Any,
            "focusId": focusId
        ]
        
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        AF.request("\(self.baseUrl)/result", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: Response.self, decoder: decoder) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 201:
                            completion(response.result, nil)
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
    
    func postSubjectResult(score: Double, subjectId: Int, completion: @escaping(Result?, String?) -> Void) {
        let parameters: [String: Any] = [
            "resultScore": score*20,
            "userId": self.user?.id as Any,
            "subjectId": subjectId
        ]
        
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        AF.request("\(self.baseUrl)/result/subject", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: Response.self, decoder: decoder) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 201:
                            completion(response.result, nil)
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
    
    func fetchResults(fId: Int?, sId: Int?, completion: @escaping([Result]?, String?) -> Void) {
        let url: String
        if let id = fId {
            url = "\(self.baseUrl)/result?userId=\(self.user!.id)&focusId=\(id)"
        } else if let id = sId {
            url = "\(self.baseUrl)/result?userId=\(self.user!.id)&subjectId=\(id)"
        } else {
            completion(nil, "Es wurde keine ID für ein Fach oder Schwerpunkt übergeben.")
            return
        }
        print(url)
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        AF.request(url, method: .get, headers: self.headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self, decoder: decoder) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            completion(response.results, nil)
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
    
    /*------------Friendship-Requests---------------*/
    func fetchFriendships(completion: @escaping([Friendship]?, [Friendship]?, String?) -> Void) {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        AF.request("\(self.baseUrl)/friends?id=\(self.user!.id)", method: .get, headers: self.headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self, decoder: decoder) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            self.friendships = response.acceptedFriendships
                            completion(response.acceptedFriendships, response.pendingFriendships, nil)
                        case 400...500:
                            if let reason = response.reason {
                                completion(nil, nil, reason)
                            }
                        default:
                            completion(nil, nil, "Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(nil, nil, "Request failed! Reason: \(error.localizedDescription)")
                }
            }
    }
    
    func acceptFriendship(id: Int, completion: @escaping(String?) -> Void) {
        let parameters: [String: Any] = [
            "id": id
        ]
        
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        AF.request("\(self.baseUrl)/friends/accept", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200...500)
            .responseString() { response in
                print(response)
            }
            .responseDecodable(of: Response.self, decoder: decoder) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            completion(nil)
                        case 400...500:
                            completion(response.reason)
                        default:
                            completion("Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion("Request failed! Reason: \(error)")
                }
            }
    }
    
    func declineFriendship(id: Int, completion: @escaping(String?) -> Void) {
        AF.request("\(self.baseUrl)/friends?id=\(id)", method: .delete, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: Response.self) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            completion(nil)
                        case 400...500:
                            completion(response.reason)
                        default:
                            completion("Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion("Request failed! Reason: \(error.localizedDescription)")
                }
            }
    }
    // Accept, Decline, Send
    
    /*------------Challenge-Requests---------------*/
    // PostFocus, PostSubject, Delete, assignResult, FriendshipChallenges, SubjectChallenges, DoneChallenges
    
    
}
