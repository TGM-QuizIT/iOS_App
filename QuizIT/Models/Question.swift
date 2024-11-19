//
//  Question.swift
//  QuizIT
//
//  Created by Marius on 06.10.24.
//

import Foundation

struct Question: Identifiable {
    var questionId: Int
    var id: Int { questionId }
    let questionText: String
    let questionAnswers: [String]
    let questionMChoice: Bool

    init(questionId: Int, questionText: String, questionAnswers: [String], questionMChoice: Bool) {
        self.questionId = questionId
        self.questionText = questionText
        self.questionAnswers = questionAnswers
        self.questionMChoice = questionMChoice
    }
}
