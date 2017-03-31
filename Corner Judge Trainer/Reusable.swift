//
//  Cell+Identifier.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 2/21/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import UIKit
import Intrepid

protocol Reusable { }

extension Reusable where Self : UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }

    static func registerCell(_ tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: identifier)
    }

    static func registerNib(_ tableView: UITableView) {
        tableView.register(ip_nib, forCellReuseIdentifier: identifier)
    }
}

extension UITableViewCell: Reusable { }

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
