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

    init(questionId: Int, questionText: String, questionAnswers: [String]) {
        self.questionId = questionId
        self.questionText = questionText
        self.questionAnswers = questionAnswers
    }
}
