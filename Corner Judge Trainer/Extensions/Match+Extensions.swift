//
//  Match+Extensions.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 3/1/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import Foundation

extension Int {
    /**
     Generates a random number between (and inclusive of)
     the given minimum and maxiumum.
     */
    public static func random(min: Int, max: Int) -> Int {
        let top = max - min + 1
        return Int(arc4random_uniform(UInt32(top))) + min
    }
}
