//
//  Question.swift
//  QuizIT
//
//  Created by Marius on 06.10.24.
//

import Foundation

struct Question: Identifiable, Hashable, Codable {
    var id: Int
    let text: String
    var options: [Option]
    let mChoice: Bool
    var score: Double = 0

    init(id: Int, text: String, options: [Option], mChoice: Bool) {
        self.id = id
        self.text = text
        self.options = options
        self.mChoice = mChoice
    }
    
    enum CodingKeys: String, CodingKey {
            case id = "questionId"
            case text = "questionText"
            case options = "options"
            case mChoice = "mChoice"
        }
}
