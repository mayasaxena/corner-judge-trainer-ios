//
//  RoundedButton.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 8/26/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import UIKit

public typealias Block = () -> ()


@IBDesignable final class RoundedButton: UIButton {
    
    enum ColorStyle: Int {
        case Transparent = 0,
        White,
        Red,
        Blue
    }
    
    @IBInspectable var colorStyleRaw: Int = 0 {
        didSet {
            colorStyle = ColorStyle(rawValue: colorStyleRaw) ?? .White
        }
    }
    
    @IBInspectable var radius: CGFloat = 7.0 {
        didSet {
            layer.cornerRadius = radius
            setNeedsLayout()
        }
    }
    
    var colorStyle: ColorStyle = .White {
        didSet {
            updateStyle()
        }
    }
    
    init(style: ColorStyle, title: String, action: Block) {
        super.init(frame: CGRectZero)
        colorStyle = style
        setup()
        setTitle(title, forState: .Normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    
    private func setup() {
        layer.cornerRadius = radius
        titleLabel?.adjustsFontSizeToFitWidth = true
        updateStyle()
    }
    
    func updateStyle() {
        switch colorStyle {
        case .White:
            setupWhiteBackground()
        case .Transparent:
            setupTransparentBackground()
        case .Red:
            setupRedBackground()
        case .Blue:
            setupBlueBackground()
        }
    }
    
    private func setupWhiteBackground() {
        backgroundColor = UIColor.flatWhiteColor()
        tintColor = UIColor.flatBlackColor()
        setTitleColor(UIColor.flatWhiteColor(), forState: .Normal)
    }
    
    private func setupTransparentBackground() {
        backgroundColor = nil
        tintColor = UIColor.flatWhiteColor()
        setTitleColor(UIColor.flatWhiteColor(), forState: .Normal)
        layer.borderColor = UIColor.flatWhiteColor().CGColor
        layer.borderWidth = 1.0
    }
    
    private func setupRedBackground() {
        backgroundColor = UIColor.flatRedColor()
        tintColor = UIColor.flatWhiteColor()
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    private func setupBlueBackground() {
        backgroundColor = UIColor.flatBlueColor()
        tintColor = UIColor.flatWhiteColor()
        setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
}