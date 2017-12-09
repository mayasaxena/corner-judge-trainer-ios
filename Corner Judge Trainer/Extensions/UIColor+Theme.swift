//
//  UIColor+Theme.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 8/26/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import UIKit

extension UIColor {
//    class var flatBlue: UIColor {
//        return
//    }

    static let flatBlue = UIColor(red: 54.0 / 255.0, green: 108.0 / 255.0, blue: 172.0 / 255.0, alpha: 1.0)

    class var flatRed: UIColor {
        return UIColor(red: 186.0 / 255.0, green: 65.0 / 255.0, blue: 65.0 / 255.0, alpha: 1.0)
    }

    class var flatBlack: UIColor {
        return UIColor(white: 39.0 / 255.0, alpha: 1.0)
    }

    class var flatWhite: UIColor {
        return UIColor(white: 246.0 / 255.0, alpha: 1.0)
    }

    class var penaltyGold: UIColor {
        return UIColor(red: 255.0 / 255.0, green: 208.0 / 255.0, blue: 70.0 / 255.0, alpha: 1.0)
    }

    class var penaltyRed: UIColor {
        return UIColor(red: 150.0 / 255.0, green: 2.0 / 255.0, blue: 0.0, alpha: 1.0)
    }

    class var darkGrey: UIColor {
        return UIColor(white: 62.0 / 255.0, alpha: 1.0)
    }

    static let textFieldBackground = UIColor.flatBlue
}
