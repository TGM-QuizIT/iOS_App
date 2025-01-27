//
//  Result.swift
//  QuizIT
//
//  Created by Marius on 04.12.24.
//
import Foundation

struct Result: Codable, Identifiable, Hashable {
    let id: Int
    var score: Double
    let userId: Int
    var focus: Focus?
    var subject: Subject?
    let date: Date
    
    init(id: Int, score: Double, userId: Int, focus: Focus, date: Date) {
        self.id = id
        self.score = score
        self.userId = userId
        self.focus = focus
        self.date = date
        self.subject = nil
    }
    
    init(id: Int, score: Double, userId: Int, subject: Subject, date: Date) {
        self.id = id
        self.score = score
        self.userId = userId
        self.focus = nil
        self.date = date
        self.subject = subject
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "resultId"
        case score = "resultScore"
        case date = "resultDateTime"
        case userId = "userId"
        case focus
        case subject
    }
    
}
