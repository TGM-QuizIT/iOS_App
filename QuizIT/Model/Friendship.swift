//
//  Friendship.swift
//  QuizIT
//
//  Created by Marius on 03.12.24.
//
import Foundation

struct Friendship: Codable, Identifiable, Hashable {
    let id: Int
    let user2: User
    let pending: Int
    let since: Date
    
    init(id: Int, user2: User, pending: Int, since: Date) {
        self.id = id
        self.user2 = user2
        self.pending = pending
        self.since = since
    }
    enum CodingKeys: String, CodingKey {
        case id = "friendshipId"
        case user2 = "friend"
        case since = "friendshipSince"
        case pending = "friendshipPending"
    }
    
}
