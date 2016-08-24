//
//  JudgingViewController.swift
//  Corner Judge Trainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import UIKit
import Intrepid
import RxSwift
import RxCocoa

class JudgingViewController: UIViewController {

    
    @IBOutlet weak var redScoringArea: UIView!
    @IBOutlet weak var redHeadshotScoringAreaView: UIView!
    @IBOutlet weak var redScoreLabel: UILabel!
    
    @IBOutlet weak var blueScoringArea: UIView!
    @IBOutlet weak var blueHeadshotScoringAreaView: UIView!
    @IBOutlet weak var blueScoreLabel: UILabel!
    
    let disposeBag = DisposeBag()
    let viewModel: MatchViewModel = MatchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRedScoring()
        setupBlueScoring()
    }
    
    private func setupRedScoring() {
        viewModel.redScoreText.asObservable().subscribeNext { scoreText in
            self.redScoreLabel.text = scoreText
        } >>> disposeBag
        
        let redTapGestureRecognizer = UITapGestureRecognizer()
        redHeadshotScoringAreaView.addGestureRecognizer(redTapGestureRecognizer)
        
        redTapGestureRecognizer.rx_event.subscribeNext { _ in
            self.viewModel.playerScored(.Red, scoringEvent: .HeadKick)
        } >>> disposeBag
        
        let redSwipeGestureRecognizer = UISwipeGestureRecognizer()
        redSwipeGestureRecognizer.direction = .Down
        redScoringArea.addGestureRecognizer(redSwipeGestureRecognizer)
        
        redSwipeGestureRecognizer.rx_event.subscribeNext { _ in
            self.viewModel.playerScored(.Red, scoringEvent: .BodyKick)
        } >>> disposeBag
    }
    
    private func setupBlueScoring() {
        viewModel.blueScoreText.asObservable().subscribeNext { scoreText in
            self.blueScoreLabel.text = scoreText
        } >>> disposeBag
        
        let blueTapGestureRecognizer = UITapGestureRecognizer()
        blueHeadshotScoringAreaView.addGestureRecognizer(blueTapGestureRecognizer)
        
        blueTapGestureRecognizer.rx_event.subscribeNext { _ in
            self.viewModel.playerScored(.Blue, scoringEvent: .HeadKick)
        } >>> disposeBag
        
        let blueSwipeGestureRecognizer = UISwipeGestureRecognizer()
        blueSwipeGestureRecognizer.direction = .Down
        blueScoringArea.addGestureRecognizer(blueSwipeGestureRecognizer)
        
        blueSwipeGestureRecognizer.rx_event.subscribeNext { _ in
            self.viewModel.playerScored(.Blue, scoringEvent: .BodyKick)
        } >>> disposeBag
        
    }
}
