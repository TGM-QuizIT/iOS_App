//
//  User.swift
//  QuizIT
//
//  Created by Marius on 06.10.24.
//

import Foundation

struct User: Identifiable, Hashable {
    let id: Int
    let name: String
    let fullName: String
    let year: Int
    let uClass: String
    let role: String

    init(
        id: Int, name: String, fullName: String, year: Int, uClass: String,
        role: String
    ) {
        self.id = id
        self.name = name
        self.fullName = fullName
        self.year = year
        self.uClass = uClass
        self.role = role
    }
    enum CodingKeys: String, CodingKey {
        case id = "userId"
        case name = "userName"
        case fullName = "userFullName"
        case year = "userYear"
        case uClass = "userClass"
        case role = "userRole"
    }

}
