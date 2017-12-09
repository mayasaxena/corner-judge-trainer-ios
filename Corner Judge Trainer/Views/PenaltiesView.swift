//
//  PenaltiesView.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 3/31/17.
//  Copyright © 2017 Maya Saxena. All rights reserved.
//

import UIKit
import Intrepid

final class PenaltiesView: UICollectionView, UICollectionViewDataSource {

    var penalties: Int = 0 {
        didSet {
            reloadData()
        }
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        dataSource = self
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        dataSource = self
        register(PenaltyCollectionViewCell.self, forCellWithReuseIdentifier: PenaltyCollectionViewCell.identifier)

    }

    override var contentOffset: CGPoint {
        didSet {
            if contentOffset != CGPoint.zero {
                contentOffset = CGPoint.zero
            }
        }
    }

    // MARK: - UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return penalties
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: PenaltyCollectionViewCell = ip_dequeueCell(indexPath, identifier: PenaltyCollectionViewCell.identifier)
        cell.configure()
        return cell
    }
}

final class PenaltyCollectionViewCell: UICollectionViewCell {

    func configure() {
        backgroundColor = UIColor.penaltyRed
        layer.cornerRadius = frame.width / 2
    }
}
