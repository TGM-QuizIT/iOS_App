//
//  QuizData.swift
//  QuizIT
//
//  Created by Marius on 07.03.25.
//

import SwiftUI
import Foundation

class QuizData: ObservableObject {
    @Published var questions: [Question] = dummyQuiz.questions
    @Published var quizType: Int = 0
    @Published var showQuiz: Bool = false
    @Published var subject: Subject = dummySubjects[0]
    @Published var focus: Focus = dummyFocuses[0]
    @Published var challenge: Challenge?
}
