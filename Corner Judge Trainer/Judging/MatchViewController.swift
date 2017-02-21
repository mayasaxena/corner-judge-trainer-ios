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
    
    let viewModel: MatchViewModel
    let disposeBag = DisposeBag()

    init(viewModel: MatchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    convenience init(matchType: MatchType) {
        self.init(viewModel: MatchViewModel(matchType: matchType))
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("Use init(viewModel:) instead")
    }

    override public var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        setupRedScoring()
        setupBlueScoring()
        setupPlayerNameLabels()
        setupMatchInfoView()
        setupPenaltyButtons()
        
        redTechnicalButton.layer.cornerRadius = redTechnicalButton.frameHeight / 2
        blueTechnicalButton.layer.cornerRadius = blueTechnicalButton.frameHeight / 2
    }
    
    private func setupRedScoring() {
        redScoreLabel.rx.text <- viewModel.redScoreText >>> disposeBag

        setupTapGestureRecognizer(targetView: redScoringArea, playerColor: .red)
        setupSwipeGestureRecognizer(targetView: redScoringArea, playerColor: .red)
        
        redTechnicalButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.viewModel.handleTechnicalButtonTapped(color: .red)
        }) >>> disposeBag
        
        redScoringArea.isUserInteractionEnabled = false
    }
    
    private func setupBlueScoring() {
        blueScoreLabel.rx.text <- viewModel.blueScoreText >>> disposeBag

        setupTapGestureRecognizer(targetView: blueScoringArea, playerColor: .blue)
        setupSwipeGestureRecognizer(targetView: blueScoringArea, playerColor: .blue)
        
        blueTechnicalButton.rx.tap.subscribe { [weak self] in
            self?.viewModel.handleTechnicalButtonTapped(color: .blue)
        } >>> disposeBag
        
        blueScoringArea.isUserInteractionEnabled = false
    }
    
    private func setupMatchInfoView() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        matchInfoView.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer.rx.event.subscribe(onNext: { [weak self] _ in
            self?.viewModel.handleMatchInfoViewTapped()
        }) >>> disposeBag

        // TODO: Bind
        viewModel.timerLabelTextColor.asObservable().subscribe(onNext: { [weak self] in
            self?.timerLabel.textColor = $0
        }) >>> disposeBag
        
        viewModel.roundLabelHidden.asObservable().subscribe(onNext: { [weak self] hidden in
            self?.setRoundHidden(hidden: hidden)
        }) >>> disposeBag
        
        viewModel.penaltyButtonsVisible.asObservable().subscribe(onNext: { [weak self] buttonsVisible in
            self?.penaltiesView.isHidden = !buttonsVisible
        }) >>> disposeBag
        
        viewModel.disablingViewVisible.asObservable().subscribe(onNext: { [weak self] disablingViewVisible in
            self?.disablingView.isHidden = !disablingViewVisible
            self?.redScoringArea.isUserInteractionEnabled = !disablingViewVisible
            self?.blueScoringArea.isUserInteractionEnabled = !disablingViewVisible
        }) >>> disposeBag
        
        viewModel.roundLabelHidden.asObservable().subscribe(onNext: { [weak self] roundLabelHidden in
            self?.setRoundHidden(hidden: roundLabelHidden)
        }) >>> disposeBag
        
        timerLabel.rx.text <- viewModel.timerLabelText >>> disposeBag
        roundLabel.rx.text <- viewModel.roundLabelText >>> disposeBag
        matchInfoView.rx.isHidden <- viewModel.matchInfoViewHidden >>> disposeBag
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
        UIView.animate(
            withDuration: Constants.DefaultMatchInfoViewAnimationDuration,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    private func hideRound() {
        matchInfoViewTopConstraint.constant = Constants.MatchInfoViewHiddenTopConstraint
        UIView.animate(
            withDuration: Constants.DefaultMatchInfoViewAnimationDuration,
            animations: {
                self.view.layoutIfNeeded()

            },
            completion: nil
        )
    }
    
    private func setupTapGestureRecognizer(targetView: UIView, playerColor: PlayerColor) {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.numberOfTapsRequired = 1
        targetView.addGestureRecognizer(tapGestureRecognizer)
        
        tapGestureRecognizer.rx.event.subscribe(onNext: { [weak self] _ in
            self?.viewModel.handleScoringAreaTapped(color: playerColor)
        }) >>> disposeBag
    }
    
    private func setupSwipeGestureRecognizer(targetView: UIView, playerColor: PlayerColor) {
        let swipeGestureRecognizer = UISwipeGestureRecognizer()
        swipeGestureRecognizer.direction = .down
        targetView.addGestureRecognizer(swipeGestureRecognizer)
        
        swipeGestureRecognizer.rx.event.subscribe(onNext: { [weak self] _ in
            self?.viewModel.handleScoringAreaSwiped(color: playerColor)
        }) >>> disposeBag
    }
    
    private func setupPenaltyButtons() {
        
        redKyongGoButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.displayConfirmationAlert(playerColor: .red, category: .kyongGo)
        }) >>> disposeBag

        redGamJeomButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.displayConfirmationAlert(playerColor: .red, category: .gamJeom)
        }) >>> disposeBag
        
        blueKyongGoButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.displayConfirmationAlert(playerColor: .blue, category: .kyongGo)
        }) >>> disposeBag
        
        blueGamJeomButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.displayConfirmationAlert(playerColor: .blue, category: .gamJeom)
        }) >>> disposeBag
    }
    
    private func displayConfirmationAlert(playerColor color: PlayerColor, category: ScoringEvent.Category) {
        let alertController = UIAlertController(title: "Give \(category.displayName) to \(color.displayName)?", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Yes", style: .destructive) { [weak self] _ in
            self?.viewModel.handlePenaltyConfirmed(color: color, penalty: category)
        }
        alertController.addAction(addAction)
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func setupPlayerNameLabels() {
        redPlayerNameLabel.rx.text <- viewModel.redPlayerName >>> disposeBag
        bluePlayerNameLabel.rx.text <- viewModel.bluePlayerName >>> disposeBag
    }
}
