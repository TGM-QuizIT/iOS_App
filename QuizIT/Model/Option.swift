//
//  Question 2.swift
//  QuizIT
//
//  Created by Marius on 21.11.24.
//


//
//  Question.swift
//  QuizIT
//
//  Created by Marius on 06.10.24.
//

import Foundation

struct Option: Identifiable, Hashable {
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
            case id = "userId"
            case text = "optionText"
            case correct = "optionCorrect"
        }
}
