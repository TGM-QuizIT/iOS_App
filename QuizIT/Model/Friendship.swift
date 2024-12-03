//
//  Friendship.swift
//  QuizIT
//
//  Created by Marius on 03.12.24.
//
import Foundation

struct Friendship: Identifiable, Hashable {
    let id: Int
    let friendId: Int
    let friendName: String
    let friendYear: Int
    let since: Date
    
    init(id: Int, friendId: Int, friendName: String, friendYear: Int, since: Date) {
        self.id = id
        self.friendId = friendId
        self.friendName = friendName
        self.friendYear = friendYear
        self.since = since
    }
    enum CodingKeys: String, CodingKey {
        case id = "friendshipId"
        case since = "friendshipSince"
    }
    
}
