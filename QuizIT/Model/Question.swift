//
//  Question.swift
//  QuizIT
//
//  Created by Marius on 06.10.24.
//

import Foundation

struct Question: Identifiable {
    var id: Int
    let text: String
    let options: [Option]
    let mChoice: Bool

    init(id: Int, text: String, options: [Option], mChoice: Bool) {
        self.id = id
        self.text = text
        self.options = options
        self.mChoice = mChoice
    }
    
    enum CodingKeys: String, CodingKey {
            case id = "userId"
            case text = "questionText"
            case options = "options"
            case mChoice = "questionMChoice"
        }
}
