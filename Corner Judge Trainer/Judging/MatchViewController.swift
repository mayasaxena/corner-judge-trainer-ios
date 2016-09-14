//
//  MatchViewController.swift
//  Corner Judge Trainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import UIKit
import Intrepid
import RxSwift
import RxCocoa

public final class MatchViewController: UIViewController {
    
    struct Constants {
        static let MatchInfoViewHiddenTopConstraint: CGFloat = -40.0
        static let DefaultMatchInfoViewAnimationDuration = 0.5
    }
    
    @IBOutlet weak var redScoringArea: UIView!
    @IBOutlet weak var redScoreLabel: UILabel!
    @IBOutlet weak var redTechnicalButton: UIButton!
    @IBOutlet weak var redPlayerNameLabel: UILabel!
    
    @IBOutlet weak var blueScoringArea: UIView!
    @IBOutlet weak var blueScoreLabel: UILabel!
    @IBOutlet weak var blueTechnicalButton: UIButton!
    @IBOutlet weak var bluePlayerNameLabel: UILabel!
    
    @IBOutlet weak var disablingView: UIView!
    
    @IBOutlet weak var penaltiesView: UIView!
    @IBOutlet weak var redKyongGoButton: RoundedButton!
    @IBOutlet weak var redGamJeomButton: RoundedButton!
    @IBOutlet weak var blueKyongGoButton: RoundedButton!
    @IBOutlet weak var blueGamJeomButton: RoundedButton!
    
    @IBOutlet weak var matchInfoView: UIView!
    @IBOutlet weak var matchInfoViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    let disposeBag = DisposeBag()
    var viewModel: MatchViewModel!
    
    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel == nil {
            viewModel = MatchViewModel()
        }
        
        setupRedScoring()
        setupBlueScoring()
        setupPlayerNameLabels()
        setupMatchInfoView()
        setupPenaltyButtons()
        
        redTechnicalButton.layer.cornerRadius = redTechnicalButton.frameHeight / 2
        blueTechnicalButton.layer.cornerRadius = blueTechnicalButton.frameHeight / 2
    }
    
    private func setupRedScoring() {
        redScoreLabel.rx_text <- viewModel.redScoreText >>> disposeBag
        
        setupTapGestureRecognizer(redScoringArea, playerColor: .Red)
        setupSwipeGestureRecognizer(redScoringArea, playerColor: .Red)
        
        redTechnicalButton.rx_tap.subscribeNext { [weak self] in
            self?.viewModel.playerScored(.Red, scoringEvent: .Technical)
        } >>> disposeBag
        
        redScoringArea.userInteractionEnabled = false
    }
    
    private func setupBlueScoring() {
        blueScoreLabel.rx_text <- viewModel.blueScoreText >>> disposeBag
        
        setupTapGestureRecognizer(blueScoringArea, playerColor: .Blue)
        setupSwipeGestureRecognizer(blueScoringArea, playerColor: .Blue)
        
        blueTechnicalButton.rx_tap.subscribeNext { [weak self] in
            self?.viewModel.playerScored(.Blue, scoringEvent: .Technical)
        } >>> disposeBag
        
        blueScoringArea.userInteractionEnabled = false
    }
    
    private func setupMatchInfoView() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        matchInfoView.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer.rx_event.subscribeNext { [weak self] _ in
            self?.viewModel.handleMatchInfoViewTapped()
        } >>> disposeBag

        viewModel.timerLabelTextColor.asObservable().subscribeNext { [weak self] in
            self?.timerLabel.textColor = $0
        } >>> disposeBag
        
        viewModel.roundLabelHidden.asObservable().subscribeNext { [weak self] hidden in
            self?.setRoundHidden(hidden)
        } >>> disposeBag
        
        viewModel.penaltyButtonsVisible.asObservable().subscribeNext { [weak self] buttonsVisible in
            self?.penaltiesView.hidden = !buttonsVisible
        } >>> disposeBag
        
        viewModel.disablingViewVisible.asObservable().subscribeNext { [weak self] disablingViewVisible in
            self?.disablingView.hidden = !disablingViewVisible
            self?.redScoringArea.userInteractionEnabled = !disablingViewVisible
            self?.blueScoringArea.userInteractionEnabled = !disablingViewVisible
        } >>> disposeBag
        
        viewModel.roundLabelHidden.asObservable().subscribeNext { [weak self] roundLabelHidden in
            self?.setRoundHidden(roundLabelHidden)
        } >>> disposeBag
        
        timerLabel.rx_text <- viewModel.timerLabelText >>> disposeBag
        roundLabel.rx_text <- viewModel.roundLabelText >>> disposeBag
        matchInfoView.rx_hidden <- viewModel.matchInfoViewHidden >>> disposeBag
    }
    
    private func setRoundHidden(hidden: Bool) {
        if hidden {
            hideRound()
        } else {
            showRound()
        }
    }
    
    private func showRound() {
        matchInfoViewTopConstraint.constant = 0
        UIView.animateWithDuration(
            Constants.DefaultMatchInfoViewAnimationDuration,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    private func hideRound() {
        matchInfoViewTopConstraint.constant = Constants.MatchInfoViewHiddenTopConstraint
        UIView.animateWithDuration(
            Constants.DefaultMatchInfoViewAnimationDuration,
            animations: {
                self.view.layoutIfNeeded()

            },
            completion: nil
        )
    }
    
    private func setupTapGestureRecognizer(targetView: UIView, playerColor: PlayerColor) -> UITapGestureRecognizer {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 1
        targetView.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer.rx_event.subscribeNext { [weak self] _ in
            self?.viewModel.playerScored(playerColor, scoringEvent: .Head)
        } >>> disposeBag
        
        return tapGestureRecognizer
    }
    
    private func setupSwipeGestureRecognizer(targetView: UIView, playerColor: PlayerColor) {
        let swipeGestureRecognizer = UISwipeGestureRecognizer()
        swipeGestureRecognizer.direction = .Down
        targetView.addGestureRecognizer(swipeGestureRecognizer)
        
        swipeGestureRecognizer.rx_event.subscribeNext { [weak self] _ in
            self?.viewModel.playerScored(playerColor, scoringEvent: .Body)
        } >>> disposeBag
    }
    
    private func setupPenaltyButtons() {
        
        redKyongGoButton.rx_tap.subscribeNext { [weak self] in
            self?.displayConfirmationAlert(PlayerColor.Red, scoringEvent: .KyongGo)
        } >>> disposeBag
        
        redGamJeomButton.rx_tap.subscribeNext { [weak self] in
            self?.displayConfirmationAlert(PlayerColor.Red, scoringEvent: .GamJeom)
        } >>> disposeBag
        
        blueKyongGoButton.rx_tap.subscribeNext { [weak self] in
            self?.displayConfirmationAlert(PlayerColor.Blue, scoringEvent: .KyongGo)
        } >>> disposeBag
        
        blueGamJeomButton.rx_tap.subscribeNext { [weak self] in
            self?.displayConfirmationAlert(PlayerColor.Blue, scoringEvent: .GamJeom)
        } >>> disposeBag
    }
    
    private func displayConfirmationAlert(color: PlayerColor, scoringEvent: ScoringEvent) {
        let alertController = UIAlertController(title: "Add \(scoringEvent.displayName) to \(color.displayName)?", message: "", preferredStyle: .Alert)
        
        let addAction = UIAlertAction(title: "Yes", style: .Destructive) { [weak self] _ in
            self?.viewModel.playerScored(color, scoringEvent: scoringEvent)
        }
        alertController.addAction(addAction)
        
        let cancelAction = UIAlertAction(title: "No", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func setupPlayerNameLabels() {
        redPlayerNameLabel.rx_text <- viewModel.redPlayerName >>> disposeBag
        bluePlayerNameLabel.rx_text <- viewModel.bluePlayerName >>> disposeBag
    }
}
