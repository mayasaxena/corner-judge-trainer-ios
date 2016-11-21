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
        case transparent = 0,
        white,
        red,
        blue
    }
    
    @IBInspectable var colorStyleRaw: Int = 0 {
        didSet {
            colorStyle = ColorStyle(rawValue: colorStyleRaw) ?? .white
        }
    }
    
    @IBInspectable var radius: CGFloat = 7.0 {
        didSet {
            layer.cornerRadius = radius
            setNeedsLayout()
        }
    }
    
    var colorStyle: ColorStyle = .white {
        didSet {
            updateStyle()
        }
    }
    
    init(style: ColorStyle, title: String, action: Block) {
        super.init(frame: CGRect.zero)
        colorStyle = style
        setup()
        setTitle(title, for: UIControlState())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override class var layerClass : AnyClass {
        return CAGradientLayer.self
    }
    
    fileprivate func setup() {
        layer.cornerRadius = radius
        titleLabel?.adjustsFontSizeToFitWidth = true
        updateStyle()
    }
    
    func updateStyle() {
        switch colorStyle {
        case .white:
            setupWhiteBackground()
        case .transparent:
            setupTransparentBackground()
        case .red:
            setupRedBackground()
        case .blue:
            setupBlueBackground()
        }
    }
    
    private func setupWhiteBackground() {
        backgroundColor = UIColor.flatWhite
        tintColor = UIColor.flatBlack
        setTitleColor(UIColor.flatWhite, for: UIControlState())
    }
    
    private func setupTransparentBackground() {
        backgroundColor = nil
        tintColor = UIColor.flatWhite
        setTitleColor(UIColor.flatWhite, for: UIControlState())
        layer.borderColor = UIColor.flatWhite.cgColor
        layer.borderWidth = 1.0
    }
    
    private func setupRedBackground() {
        backgroundColor = UIColor.flatRed
        tintColor = UIColor.flatWhite
        setTitleColor(UIColor.white, for: UIControlState())
    }
    
    private func setupBlueBackground() {
        backgroundColor = UIColor.flatBlue
        tintColor = UIColor.flatWhite
        setTitleColor(UIColor.flatWhite, for: UIControlState())
    }
}
