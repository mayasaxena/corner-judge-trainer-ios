//
//  MatchResponse.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 12/12/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation

struct MatchesResponse: Decodable {
    enum CodingKeys: String, CodingKey {
        case matchCount = "match-count"
        case matches
    }
    
    let matchCount: Int
    let matches: [Match]
}

struct PlayerResponse: Decodable {
    let name: String
    let score: Int
    let penalties: Int
}
