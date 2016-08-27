//
//  Player.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 8/24/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation

public enum PlayerColor {
    case Blue
    case Red
    
    var displayName: String {
        switch self {
        case .Blue:
            return "Blue"
        case .Red:
            return "Red"
        }
    }
}

public class Player {
    struct Constants {
        static let DefaultName = "Anonymous"
    }
    
    var name: String
    var color: PlayerColor
    
    convenience init(color: PlayerColor) {
        self.init(color: color, name: Constants.DefaultName + " " + color.displayName)
    }
    
    init(color: PlayerColor, name: String) {
        self.color = color
        self.name = name
    }
}

extension Player {
    static var defaultName: String {
        return Constants.DefaultName
    }
}
