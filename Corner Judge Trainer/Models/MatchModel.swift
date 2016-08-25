//
//  MatchModel.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import Foundation

public class MatchModel {
    struct Constants {
        static let MatchIDLength = 6
        static let HeadshotPointValue = 3
        static let BodyshotPointValue = 1
    }

    let redPlayer: Player
    let bluePlayer: Player

    var matchID: String
    var date: NSDate
    
    var redScore: Double = 0
    var blueScore: Double = 0
    
    convenience init() {
        self.init(redPlayer: Player(color: .Red), bluePlayer: Player(color: .Blue))
    }

    init(redPlayer: Player, bluePlayer: Player) {
        self.redPlayer = redPlayer
        self.bluePlayer = bluePlayer
        
        self.matchID = String.random(Constants.MatchIDLength)
        self.date = NSDate()
        self.redScore = 0
        self.blueScore = 0
    }
}

extension String {
    
    static func random(length: Int = 20) -> String {
        
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""
        
        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.characters.count))
            randomString += "\(base[base.startIndex.advancedBy(Int(randomValue))])"
        }
        
        return randomString
    }
}
