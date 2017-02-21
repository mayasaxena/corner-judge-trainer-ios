//
//  Cell+Identifier.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 2/21/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import UIKit
import Intrepid

public protocol CellRepresentable { }

extension CellRepresentable where Self : UITableViewCell {
    public static var cellIdentifier: String {
        return String(describing: self)
    }

    public static func registerCell(_ tableView: UITableView) {
        tableView.register(self, forCellReuseIdentifier: cellIdentifier)
    }

    public static func registerNib(_ tableView: UITableView) {
        tableView.register(ip_nib, forCellReuseIdentifier: cellIdentifier)
    }
}

extension UITableViewCell: CellRepresentable { }
