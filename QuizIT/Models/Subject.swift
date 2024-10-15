//
//  Subject.swift
//  QuizIT
//
//  Created by Marius on 06.10.24.
//

import Foundation

struct Subject: Identifiable, Hashable {
    let subjectId: Int
    var id: Int { subjectId }
    let subjectName: String
    let subjectActive: Bool

    init(subjectId: Int, subjectName: String, subjectActive: Bool) {
        self.subjectId = subjectId
        self.subjectName = subjectName
        self.subjectActive = subjectActive
    }
}
