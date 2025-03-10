//
//  Response.swift
//  QuizIT
//
//  Created by Raphael Tarnoczi on 23.12.24.
//

import Foundation

struct Response: Codable {
    let status: String
    let reason: String?
    
    let user: User?
    let users: [User]?
    let stats: Statistic?
    let blocked: Bool?
    
    let subjects: [Subject]?
    
    let focus: Focus?
    let focuses: [Focus]?
    
    let questions: [Question]?
    
    let result: Result?
    let results: [Result]?
    
    let friendship: Friendship?
    let acceptedFriendships: [Friendship]?
    let pendingFriendships: [Friendship]?
    
    let challenge: Challenge?
    let openChallenges: [Challenge]?
    let doneChallenges: [Challenge]?
}
