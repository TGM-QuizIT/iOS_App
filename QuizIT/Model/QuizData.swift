//
//  QuizData.swift
//  QuizIT
//
//  Created by Marius on 07.03.25.
//

import SwiftUI
import Foundation

class QuizData: ObservableObject {
    @Published var questions: [Question] = []
    @Published var quizType: QuizType = .subject
    @Published var showQuiz: Bool = false
    @Published var subject: Subject = Subject(id: 0, name: "QuizData", imageAddress: "")
    @Published var focus: Focus = Focus(id: 0, name: "QuizData", year: 0, questionCount: 0, imageAddress: "", subjectId: 0)
    @Published var challenge: Challenge?
}
