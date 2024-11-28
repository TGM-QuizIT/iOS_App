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


class QuizData {
    static let shared = QuizData()
    
    private init() {} // Private Initializer, damit nur eine Instanz existiert

    // Dummy-Daten für das Quiz
    var quiz = Quiz(questions: [
        Question(
            id: 1,
            text: "What is the capital of France?",
            options: [
                Option(id: 1, text: "Paris", correct: true),
                Option(id: 2, text: "Berlin", correct: true),
                Option(id: 3, text: "Madrid", correct: false),
                Option(id: 4, text: "Rome", correct: false)
            ],
            mChoice: true
        ),
        Question(
            id: 2,
            text: "Which planet is known as the Red Planet?",
            options: [
                Option(id: 1, text: "Mars", correct: true),
                Option(id: 2, text: "Earth", correct: false),
                Option(id: 3, text: "Venus", correct: false),
                Option(id: 4, text: "Jupiter", correct: false)
            ],
            mChoice: false
        ),
        Question(
            id: 3,
            text: "Who wrote 'Romeo and Juliet'?",
            options: [
                Option(id: 1, text: "William Shakespeare", correct: true),
                Option(id: 2, text: "Charles Dickens", correct: false),
                Option(id: 3, text: "Mark Twain", correct: false),
                Option(id: 4, text: "J.K. Rowling", correct: false)
            ],
            mChoice: false
        ),
        Question(
            id: 4,
            text: "What is the chemical symbol for water?",
            options: [
                Option(id: 1, text: "H2O", correct: true),
                Option(id: 2, text: "O2", correct: false),
                Option(id: 3, text: "CO2", correct: false),
                Option(id: 4, text: "NaCl", correct: false)
            ],
            mChoice: false
        ),
        Question(
            id: 5,
            text: "In which year did the Titanic sink?",
            options: [
                Option(id: 1, text: "1912", correct: true),
                Option(id: 2, text: "1905", correct: false),
                Option(id: 3, text: "1920", correct: false),
                Option(id: 4, text: "1918", correct: false)
            ],
            mChoice: false
        )
    ])
}
