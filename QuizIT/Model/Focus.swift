//
//  Focus.swift
//  QuizIT
//
//  Created by Marius on 06.10.24.
//

import Foundation

struct Focus: Identifiable, Codable, Hashable {
    let id: Int

    let name: String
    let year: Int
    let questionCount: Int
    let imageAddress: String

    init(
        id: Int, name: String, year: Int, questionCount: Int,
        imageAddress: String
    ) {
        self.id = id
        self.name = name
        self.year = year
        self.questionCount = questionCount
        self.imageAddress = imageAddress
    }
    enum CodingKeys: String, CodingKey {
        case id = "focusId"
        case name = "focusName"
        case year = "focusYear"
        case questionCount = "questionCount"
        case imageAddress = "focusImageAddress"
    }
}
