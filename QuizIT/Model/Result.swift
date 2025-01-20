//
//  Result.swift
//  QuizIT
//
//  Created by Marius on 04.12.24.
//
import Foundation

struct Result: Identifiable, Hashable {
    let id: Int
    let score: Double
    let userId: Int
    let focus: Focus
    let date: Date
    
    init(id: Int, score: Double, userId: Int, focus: Focus, date: Date) {
        self.id = id
        self.score = score
        self.userId = userId
        self.focus = focus
        self.date = date
    }
    enum CodingKeys: String, CodingKey {
        case id = "resultId"
        case score = "resultScore"
        case date = "resultDate"
    }
    
    func dateToString() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            return dateFormatter.string(from: date)
        }
    
}
