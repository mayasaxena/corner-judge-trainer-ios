//
//  Player.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 8/24/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation

enum PlayerColor: String, Decodable {
    case blue, red

    var displayName: String {
        return rawValue.capitalized
    }
}

struct Player: Decodable {
    fileprivate struct Constants {
        static let defaultNamePrefix = "Anonymous"
    }

    var name = Constants.defaultNamePrefix
    var color: PlayerColor

    init(color: PlayerColor, name: String? = nil) {
        self.color = color
        self.name = name ?? defaultName
    }
}

extension Player {
    var defaultName: String {
        return Constants.defaultNamePrefix + " " + color.displayName
    }

    var displayName: String {
        return name.contains(Constants.defaultNamePrefix) ? "" : name
    }
}
