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

struct Option: Identifiable {
    var id: Int
    let text: String
    let correct: Bool
    var selected: Bool

    init(id: Int, text: String, correct: Bool, selected: Bool) {
        self.id = id
        self.text = text
        self.correct = correct
        self.selected = selected
    }
    enum CodingKeys: String, CodingKey {
            case id = "userId"
            case text = "optionText"
            case correct = "optionCorrect"
        }
}
