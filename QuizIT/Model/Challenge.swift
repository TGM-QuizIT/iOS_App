//
//  Challenge.swift
//  QuizIT
//
//  Created by Marius on 20.01.25.
//
import Foundation

struct Challenge: Identifiable, Hashable {
    let id: Int
    let friendship: Friendship
    let focus: Focus
    let subject: Subject
    let score1: Double
    let score2: Result
    let date: Date
    
    init(id: Int, friendship: Friendship, focus: Focus, subject: Subject, score1: Double, score2: Result, date: Date) {
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
        case id = "resultId"
        case score = "resultScore"
        case date = "resultDate"
    }
    
}
