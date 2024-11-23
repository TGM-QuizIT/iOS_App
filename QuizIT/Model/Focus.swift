//
//  Focus.swift
//  QuizIT
//
//  Created by Marius on 06.10.24.
//

import Foundation

struct Focus: Identifiable, Codable, Hashable {
    let focusId: Int
    
    var id: Int { focusId }
    
    let focusName: String
    let focusYear: Int
    let questionNumber: Int

    init(focusId: Int, focusName: String, focusYear: Int, questionNumber: Int) {
        self.focusId = focusId
        self.focusName = focusName
        self.focusYear = focusYear
        self.questionNumber = questionNumber
    }
}
