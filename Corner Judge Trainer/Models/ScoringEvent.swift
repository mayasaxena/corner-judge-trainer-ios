//
//  ScoringEvent.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation

public enum ScoringEvent {
    case Head
    case Body
    case Technical
    case KyongGo
    case GamJeom
    
    var displayName: String {
        switch self {
        case .Head:
            return "Head"
        case .Body:
            return "Body"
        case .Technical:
            return "Technical"
        case .KyongGo:
            return "Kyong-Go"
        case .GamJeom:
            return "Gam-Jeom"
        }
    }
}