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

    var penalties: Double = 0.0 {
        didSet {
            reloadData()
        }
    }

    private var kyongGoCount: Int {
        return Int((penalties.truncatingRemainder(dividingBy: 1)).rounded())
    }

    private var gamJeomCount: Int {
        return Int(penalties)
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
        return gamJeomCount + kyongGoCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell: PenaltyCollectionViewCell = ip_dequeueCell(indexPath, identifier: PenaltyCollectionViewCell.identifier)

        if indexPath.item < gamJeomCount {
            cell.configure(with: UIColor.penaltyRed)
        } else {
            cell.configure(with: UIColor.penaltyGold)
        }

        return cell
    }
}

final class PenaltyCollectionViewCell: UICollectionViewCell {

    func configure(with backgroundColor: UIColor) {
        self.backgroundColor = backgroundColor
        layer.cornerRadius = frame.width / 2
    }

}
