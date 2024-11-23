//
//  User.swift
//  QuizIT
//
//  Created by Marius on 06.10.24.
//

import Foundation

struct User: Identifiable {
    let userId: Int
    let userName: String
    let userYear: Int
    
    var id: Int { userId }


    init(userId: Int, userName: String, userYear: Int) {
        self.userId = userId
        self.userName = userName
        self.userYear = userYear
    }
}
