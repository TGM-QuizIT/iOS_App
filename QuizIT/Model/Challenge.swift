//
//  Challenge.swift
//  QuizIT
//
//  Created by Marius on 20.01.25.
//
import Foundation

struct Challenge: Codable, Identifiable, Hashable {
    let id: Int
    let friendship: Friendship
    let focus: Focus?
    let subject: Subject?
    var score1: Result? // eigener Score
    let score2: Result? // gegnerischer Score
    let date: Date
    
    init(id: Int, friendship: Friendship, focus: Focus?, subject: Subject?, score1: Result, score2: Result?, date: Date) {
        self.id = id
        self.friendship = friendship
        self.focus = focus
        self.subject = subject
        self.score1 = score1
        self.score2 = score2
        self.date = date
    }
    
    // CodingKeys
    enum CodingKeys: String, CodingKey {
        case id = "challengeId"
        case date = "challengeDateTime"
        case friendship = "friendship"
        case score1 = "score"
        case score2 = "friendScore"
        case focus
        case subject
    }
    
}
