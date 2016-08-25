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
    @IBOutlet weak var redScoreLabel: UILabel!
    @IBOutlet weak var redHeadshotScoringAreaView: UIView!
    @IBOutlet weak var redTechnicalButton: UIButton!
    @IBOutlet weak var redPlayerNameLabel: UILabel!
    
    @IBOutlet weak var blueScoringArea: UIView!
    @IBOutlet weak var blueScoreLabel: UILabel!
    @IBOutlet weak var blueHeadshotScoringAreaView: UIView!
    @IBOutlet weak var blueTechnicalButton: UIButton!
    @IBOutlet weak var bluePlayerNameLabel: UILabel!
    
    let disposeBag = DisposeBag()
    let viewModel: MatchViewModel = MatchViewModel()
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRedScoring()
        setupBlueScoring()
        
        redTechnicalButton.layer.cornerRadius = redTechnicalButton.frameHeight / 2
        blueTechnicalButton.layer.cornerRadius = blueTechnicalButton.frameHeight / 2
    }
    
    private func setupRedScoring() {
        viewModel.redScoreText.asObservable().subscribeNext { scoreText in
            self.redScoreLabel.text = scoreText
            } >>> disposeBag
        
        setupTapGestureRecognizer(redHeadshotScoringAreaView, playerColor: .Red)
        setupSwipeGestureRecognizer(redScoringArea, playerColor: .Red)
        setupDoubleTapGestureRecognizer(redScoringArea, playerColor: .Red)
        setupLongPressGestureRecognizer(redScoringArea, playerColor: .Red)
        
        redTechnicalButton.rx_tap.subscribeNext { _ in
            self.viewModel.playerScored(.Red, scoringEvent: .Technical)
        } >>> disposeBag
    }
    
    private func setupBlueScoring() {
        viewModel.blueScoreText.asObservable().subscribeNext { scoreText in
            self.blueScoreLabel.text = scoreText
            } >>> disposeBag
        
        setupTapGestureRecognizer(blueHeadshotScoringAreaView, playerColor: .Blue)
        setupSwipeGestureRecognizer(blueScoringArea, playerColor: .Blue)
        setupDoubleTapGestureRecognizer(blueScoringArea, playerColor: .Blue)
        setupLongPressGestureRecognizer(blueScoringArea, playerColor: .Blue)
        
        blueTechnicalButton.rx_tap.subscribeNext { _ in
            self.viewModel.playerScored(.Blue, scoringEvent: .Technical)
        } >>> disposeBag
    }
    
    private func setupTapGestureRecognizer(targetView: UIView, playerColor: PlayerColor) {
        let tapGestureRecognizer = UITapGestureRecognizer()
        targetView.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer.rx_event.subscribeNext { _ in
            self.viewModel.playerScored(playerColor, scoringEvent: .Head)
        } >>> disposeBag
    }
    
    private func setupSwipeGestureRecognizer(targetView: UIView, playerColor: PlayerColor) {
        let swipeGestureRecognizer = UISwipeGestureRecognizer()
        swipeGestureRecognizer.direction = .Down
        targetView.addGestureRecognizer(swipeGestureRecognizer)
        
        swipeGestureRecognizer.rx_event.subscribeNext { _ in
            self.viewModel.playerScored(playerColor, scoringEvent: .Body)
        } >>> disposeBag
    }
    
    private func setupDoubleTapGestureRecognizer(targetView: UIView, playerColor: PlayerColor) {
        let doubleTapGestureRecognizer = UITapGestureRecognizer()
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        targetView.addGestureRecognizer(doubleTapGestureRecognizer)
        
        doubleTapGestureRecognizer.rx_event.subscribeNext { _ in
            self.viewModel.playerScored(playerColor, scoringEvent: .KyongGo)
        } >>> disposeBag
    }
    
    private func setupLongPressGestureRecognizer(targetView: UIView, playerColor: PlayerColor) {
        let longPressGestureRecognizer = UILongPressGestureRecognizer()
        targetView.addGestureRecognizer(longPressGestureRecognizer)
        
        longPressGestureRecognizer.rx_event
            .filter { gesture in gesture.state == .Ended }
            .subscribeNext { _ in
                self.viewModel.playerScored(playerColor, scoringEvent: .GamJeom)
            } >>> disposeBag
    }
}
