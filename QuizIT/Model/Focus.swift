//
//  Focus.swift
//  QuizIT
//
//  Created by Marius on 06.10.24.
//

import Foundation

struct Focus: Identifiable, Codable, Hashable {
    let id: Int
        
    let name: String
    let year: Int
    let questionNumber: Int

    init(id: Int, name: String, year: Int, questionNumber: Int) {
        self.id = id
        self.name = name
        self.year = year
        self.questionNumber = questionNumber
    }
    enum CodingKeys: String, CodingKey {
            case id = "focusId"
            case name = "focusName"
            case year = "focusYear"
            case questionNumber = "questionNumber"
        }
}
