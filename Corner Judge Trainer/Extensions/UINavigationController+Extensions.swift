//
//  UINavigationController+Extensions.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 3/10/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import UIKit

extension UINavigationController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return visibleViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    open override var shouldAutorotate: Bool {
        return visibleViewController?.shouldAutorotate ?? super.shouldAutorotate
    }

    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            return visibleViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
        }
    }
}

extension UIAlertController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    open override var shouldAutorotate: Bool {
        return false
    }
}
