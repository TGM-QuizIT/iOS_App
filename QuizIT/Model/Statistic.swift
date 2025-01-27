//
//  Stats.swift
//  QuizIT
//
//  Created by Raphael Tarnoczi on 25.01.25.
//

import Foundation
struct Statistic: Identifiable, Hashable, Codable {
    let id = UUID()
    let average: Double
    let rank: Int
    let winRate: Double

    init(avg: Double, rank: Int, winRate: Double) {
        self.average = avg
        self.rank = rank
        self.winRate = winRate
    }
    enum CodingKeys: String, CodingKey {
        case id
        case average = "avgPoints"
        case rank = "ranking"
        case winRate
    }

}
