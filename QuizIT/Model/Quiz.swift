//
//  Quiz.swift
//  QuizIT
//
//  Created by Marius on 16.11.24.
//
import Foundation

struct Quiz {
    var questions: [Question]

    init(questions: [Question]) {
        self.questions = questions
    }

    func getQuestion(index: Int) -> Question? {
        guard index >= 0 && index < questions.count else {
            return nil // Index ist außerhalb des Bereichs
        }
        return questions[index]
    }
}
