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
    private let decoder: JSONDecoder
    
    @Published public var user: User? = nil
    @Published public var subjects: [Subject]? = nil
    @Published public var friendships: [Friendship]? = nil //all friendships of a user, which are accepted by both parties
    
    init() {
        self.user = UserManager.shared.loadUser()
        self.decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        decoder.dateDecodingStrategy = .formatted(formatter)
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
                    completion("Request failed! Reason: \(error)", false)
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
                    completion("Request failed! Reason: \(error)")
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
                    completion(nil, "Request failed! Reason: \(error)")
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
                    completion(nil, "Request failed! Reason: \(error)")
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
                    completion("Request failed! Reason: \(error)")
                }
            }
    }
    
    /*------------Focus-Requests---------------*/
    func fetchFocus(id: Int, completion: @escaping ([Focus]?, String?) -> Void) {
        AF.request("\(self.baseUrl)/focus?id=\(id)&year=\(self.user?.year ?? 1)&active=1", method: .get, headers: self.headers) //TODO: Sinnvollen Standardwert überlegen
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            if let focuses = response.focuses {
                                completion(focuses.sorted {$0.name < $1.name}, nil)
                            }
                        case 400...500:
                            if let reason = response.reason {
                                completion(nil, reason)
                            }
                        default:
                            completion(nil, "Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion(nil, "Request failed! Reason: \(error)")
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
                    completion(nil, "Request failed! Reason: \(error)")
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
                    completion(nil, "Request failed! Reason: \(error)")
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
        
        AF.request("\(self.baseUrl)/result", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: Response.self, decoder: self.decoder) { res in
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
                    completion(nil, "Request failed! Reason: \(error)")
                }
            }
    }
    
    func postSubjectResult(score: Double, subjectId: Int, completion: @escaping(Result?, String?) -> Void) {
        let parameters: [String: Any] = [
            "resultScore": score*20,
            "userId": self.user?.id as Any,
            "subjectId": subjectId
        ]
        
        AF.request("\(self.baseUrl)/result/subject", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: Response.self, decoder: self.decoder) { res in
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
                    completion(nil, "Request failed! Reason: \(error)")
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
        
        AF.request(url, method: .get, headers: self.headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self, decoder: self.decoder) { res in
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
                    completion(nil, "Request failed! Reason: \(error)")
                }
            }
    }
    
    /*------------Friendship-Requests---------------*/
    func fetchFriendships(completion: @escaping([Friendship]?, [Friendship]?, String?) -> Void) {
        
        AF.request("\(self.baseUrl)/friends?id=\(self.user!.id)", method: .get, headers: self.headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self, decoder: self.decoder) { res in
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
                    completion(nil, nil, "Request failed! Reason: \(error)")
                }
            }
    }
    
    func acceptFriendship(id: Int, completion: @escaping(String?) -> Void) {
        let parameters: [String: Any] = [
            "id": id
        ]
        
        AF.request("\(self.baseUrl)/friends/accept", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: Response.self, decoder: self.decoder) { res in
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
                    completion("Request failed! Reason: \(error)")
                }
            }
    }
    
    func sendFriendshipRequest(id: Int, completion: @escaping(Bool?,String?) -> Void) {
        let parameters: [String: Any] = [
            "user1Id": self.user?.id ?? 1, //TODO: Sinnvollen Standardwert bzw. Fehlerbehandlung überlegen
            "user2Id": id
        ]
        
        AF.request("\(self.baseUrl)/friends", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: Response.self, decoder: self.decoder) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 201:
                            completion(true, nil)
                        case 400:
                            if ((response.reason?.contains("already")) != nil) {
                                completion(false, nil)
                            } else {
                                completion(nil, response.reason)
                            }
                        case 401...500:
                            completion(nil, response.reason)
                        default:
                            completion(nil, "Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion(nil, "Request failed! Reason: \(error)")
                }
            }
    }
    
    /*------------Challenge-Requests---------------*/
    func postFocusChallenge(friendshipId: Int, focusId: Int, completion: @escaping(Challenge?, String?) -> Void) {
        let parameters: [String: Any] = [
            "friendshipId": friendshipId,
            "focusId": focusId,
            "userId": self.user?.id ?? 1 //TODO: Sinnvollen Standardwert überlegen
        ]
        
        AF.request("\(self.baseUrl)/challenge", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: Response.self, decoder: self.decoder) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 201:
                            completion(response.challenge, nil)
                        case 400...500:
                            if let reason = response.reason {
                                completion(nil, reason)
                            }
                        default:
                            completion(nil, "Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion(nil, "Request failed! Reason: \(error)")
                }
            }
    }
    
    func postSubjectChallenge(friendshipId: Int, subjectId: Int, completion: @escaping(Challenge?, String?) -> Void) {
        let parameters: [String: Any] = [
            "friendshipId": friendshipId,
            "subjectId": subjectId,
            "userId": self.user?.id ?? 1 //TODO: Sinnvollen Standardwert überlegen
        ]
        
        AF.request("\(self.baseUrl)/challenge/subject", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: Response.self, decoder: self.decoder) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 201:
                            completion(response.challenge, nil)
                        case 400...500:
                            if let reason = response.reason {
                                completion(nil, reason)
                            }
                        default:
                            completion(nil, "Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion(nil, "Request failed! Reason: \(error)")
                }
            }
    }
    
    func deleteChallenge(challengeId: Int, completion: @escaping(String?) -> Void) {
        AF.request("\(self.baseUrl)/challenge?id=\(challengeId)", method: .delete, headers: self.headers)
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
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
                    completion("Request failed! Reason: \(error)")
                }
            }
    }
    
    func assignResultToChallenge(challengeId: Int, resultId: Int, completion: @escaping(Challenge?, String?) -> Void) {
        let parameters: [String: Any] = [
            "challengeId": challengeId,
            "resultId": resultId,
        ]
        
        AF.request("\(self.baseUrl)/challenge", method: .put, parameters: parameters, encoding: JSONEncoding.default, headers: self.headers)
            .validate(statusCode: 200...500)
            .responseDecodable(of: Response.self, decoder: self.decoder) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            completion(response.challenge, nil)
                        case 400...500:
                            if let reason = response.reason {
                                completion(nil, reason)
                            }
                        default:
                            completion(nil, "Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion(nil, "Request failed! Reason: \(error)")
                }
            }
    }
    
    func fetchFriendshipsChallenges(friendshipId: Int, completion: @escaping([Challenge]?, [Challenge]?, String?) -> Void) {
        AF.request("\(self.baseUrl)/challenge/friendship?friendshipId=\(friendshipId)&userId=\(self.user?.id ?? 1)", method: .get, headers: self.headers) //TODO: Sinnvollen Standardwert überlegen
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self, decoder: self.decoder) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            completion(response.openChallenges, response.doneChallenges, nil)
                        case 400...500:
                            if let reason = response.reason {
                                completion(nil, nil, reason)
                            }
                        default:
                            completion(nil, nil, "Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion(nil, nil, "Request failed! Reason: \(error)")
                }
            }
    }
    
    func fetchSubjectChallenges(subjectId: Int,completion: @escaping([Challenge]?, [Challenge]?, String?) -> Void) {
        AF.request("\(self.baseUrl)/challenge?subjectId=\(subjectId)&userId=\(self.user?.id ?? 1)", method: .get, headers: self.headers) //TODO: Sinnvollen Standardwert überlegen
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self, decoder: decoder) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            completion(response.openChallenges, response.doneChallenges, nil)
                        case 400...500:
                            if let reason = response.reason {
                                completion(nil, nil, reason)
                            }
                        default:
                            completion(nil, nil, "Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion(nil, nil, "Request failed! Reason: \(error)")
                }
            }
    }
    
    func fetchDoneChallenges(completion: @escaping([Challenge]?, String?) -> Void) {
        AF.request("\(self.baseUrl)/challenge/done?userId=\(self.user?.id ?? 1)", method: .get, headers: self.headers) //TODO: Sinnvollen Standardwert überlegen
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self, decoder: self.decoder) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            completion(response.doneChallenges, nil)
                        case 400...500:
                            if let reason = response.reason {
                                completion(nil, reason)
                            }
                        default:
                            completion(nil, "Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion(nil, "Request failed! Reason: \(error)")
                }
            }
    }
    
    func fetchOpenChallenges(completion: @escaping([Challenge]?, String?) -> Void) {
        AF.request("\(self.baseUrl)/challenge/open?userId=\(self.user?.id ?? 1)", method: .get, headers: self.headers) //TODO: Sinnvollen Standardwert überlegen
            .validate(statusCode: 200..<500)
            .responseDecodable(of: Response.self, decoder: decoder) { res in
                switch res.result {
                case .success(let response):
                    if let code = res.response?.statusCode {
                        switch code {
                        case 200:
                            completion(response.openChallenges, nil)
                        case 400...500:
                            if let reason = response.reason {
                                completion(nil, reason)
                            }
                        default:
                            completion(nil, "Unhandeled HTTP-Code")
                        }
                    }
                case .failure(let error):
                    completion(nil, "Request failed! Reason: \(error)")
                }
            }
    }
    
    
}
