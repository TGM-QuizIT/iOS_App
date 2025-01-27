//
//  Option.swift
//  QuizIT
//
//  Created by Marius on 06.10.24.
//

import Foundation

struct Option: Identifiable, Hashable, Codable {
    let id: Int
    let text: String
    let correct: Bool
    var selected: Bool = false

    init(id: Int, text: String, correct: Bool) {
        self.id = id
        self.text = text
        self.correct = correct
    }
    enum CodingKeys: String, CodingKey {
            case id = "optionId"
            case text = "optionText"
            case correct = "optionCorrect"
        }
}
