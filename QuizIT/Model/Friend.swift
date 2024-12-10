//
//  Friendship.swift
//  QuizIT
//
//  Created by Marius on 03.12.24.
//
import Foundation

struct Friend: Identifiable, Hashable {
    let id: Int
    let name: String
    let year: Int
    let pending: Int
    let since: Date
    
    init(id: Int, name: String, year: Int, pending: Int, since: Date) {
        self.id = id
        self.name = name
        self.year = year
        self.pending = pending
        self.since = since
    }
    enum CodingKeys: String, CodingKey {
        case id = "friendshipId"
        case name = "friendName"
        case year = "friendYear"
        case pending = "friendshipPending"
    }
    
}
