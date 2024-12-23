//
//  Response.swift
//  QuizIT
//
//  Created by Raphael Tarnoczi on 23.12.24.
//

import Foundation

struct Response: Codable {
    let status: String
    let reason: String?
    let user: User?
}
