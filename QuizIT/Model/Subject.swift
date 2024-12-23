//
//  Subject.swift
//  QuizIT
//
//  Created by Marius on 06.10.24.
//

import Foundation

struct Subject: Identifiable, Hashable, Codable {
    let id: Int
    let name: String
    let imageAddress: String

    init(id: Int, name: String, imageAddress: String) {
        self.id = id
        self.name = name
        self.imageAddress = imageAddress
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "subjectId"
        case name = "subjectName"
        case imageAddress = "subjectImageAddress"
    }
    
}
