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

final class MatchViewController: UIViewController {

    struct Constants {
        static let matchInfoViewHiddenTopConstraint: CGFloat = -40.0
        static let defaultMatchInfoViewAnimationDuration = 0.5
    }

    @IBOutlet private weak var redScoringArea: UIView!
    @IBOutlet private weak var redPenaltiesView: PenaltiesView!
    @IBOutlet private weak var redScoreLabel: UILabel!
    @IBOutlet private weak var redTechnicalButton: UIButton!
    @IBOutlet private weak var redPlayerNameLabel: UILabel!

    @IBOutlet private weak var blueScoringArea: UIView!
    @IBOutlet weak var bluePenaltiesView: PenaltiesView!
    @IBOutlet private weak var blueScoreLabel: UILabel!
    @IBOutlet private weak var blueTechnicalButton: UIButton!
    @IBOutlet private weak var bluePlayerNameLabel: UILabel!

    @IBOutlet private weak var disablingView: UIView!
    @IBOutlet private weak var redKyongGoButton: RoundedButton!
    @IBOutlet private weak var redGamJeomButton: RoundedButton!
    @IBOutlet private weak var blueKyongGoButton: RoundedButton!
    @IBOutlet private weak var blueGamJeomButton: RoundedButton!

    @IBOutlet private weak var matchInfoView: UIView!
    @IBOutlet private weak var matchInfoViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var roundLabel: UILabel!

    private let viewModel: MatchViewModel
    private let disposeBag = DisposeBag()

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscape
    }

    override var shouldAutorotate: Bool {
        return true
    }

    init(matchViewModel: MatchViewModel) {
        viewModel = matchViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(matchViewModel:) instead")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.rx.isHidden <- viewModel.navigationBarHidden >>> disposeBag
        }

        setupRedScoring()
        setupBlueScoring()
        setupPlayerNameLabels()
        setupMatchInfoView()
        setupPenaltyButtons()

        redTechnicalButton.layer.cornerRadius = redTechnicalButton.frameHeight / 2
        blueTechnicalButton.layer.cornerRadius = blueTechnicalButton.frameHeight / 2

        bluePenaltiesView.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }

    private func setupRedScoring() {
        redScoreLabel.rx.text <- viewModel.redScoreText >>> disposeBag

        setupTapGestureRecognizer(targetView: redScoringArea, playerColor: .red)
        setupSwipeGestureRecognizer(targetView: redScoringArea, playerColor: .red)

        redTechnicalButton.rx.tap.subscribeNext { [weak self] in
            self?.viewModel.handleTechnicalButtonTapped(color: .red)
        } >>> disposeBag

        redScoringArea.isUserInteractionEnabled = false

        viewModel.redPenalties.subscribeNext { [weak self] penalties in
            self?.redPenaltiesView.penalties = penalties
        } >>> disposeBag
    }

    private func setupBlueScoring() {
        blueScoreLabel.rx.text <- viewModel.blueScoreText >>> disposeBag

        setupTapGestureRecognizer(targetView: blueScoringArea, playerColor: .blue)
        setupSwipeGestureRecognizer(targetView: blueScoringArea, playerColor: .blue)

        blueTechnicalButton.rx.tap.subscribe { [weak self] in
            self?.viewModel.handleTechnicalButtonTapped(color: .blue)
        } >>> disposeBag

        blueScoringArea.isUserInteractionEnabled = false

        viewModel.bluePenalties.subscribeNext { [weak self] penalties in
            self?.bluePenaltiesView.penalties = penalties
        } >>> disposeBag
    }

    private func setupMatchInfoView() {
        matchInfoView.isHidden = viewModel.shouldHideMatchInfo

        timerLabel.rx.text <- viewModel.timerLabelText >>> disposeBag
        roundLabel.rx.text <- viewModel.roundLabelText >>> disposeBag

        viewModel.timerLabelTextColor.subscribeNext { [weak self] in
            self?.timerLabel.textColor = $0
        } >>> disposeBag

        viewModel.disablingViewHidden.subscribeNext { [weak self] hidden in
            self?.disablingView.isHidden = hidden
            self?.redScoringArea.isUserInteractionEnabled = hidden
            self?.blueScoringArea.isUserInteractionEnabled = hidden
        } >>> disposeBag

        viewModel.roundLabelHidden.asObservable().subscribeNext { [weak self] roundLabelHidden in
            self?.setRoundHidden(roundLabelHidden)
        } >>> disposeBag

        let tapGestureRecognizer = UITapGestureRecognizer()
        matchInfoView.addGestureRecognizer(tapGestureRecognizer)

        tapGestureRecognizer.rx.event.subscribeNext { [weak self] _ in
            self?.viewModel.handleMatchInfoViewTapped()
        } >>> disposeBag
    }

    private func setRoundHidden(_ hidden: Bool) {
        if hidden {
            hideRound()
        } else {
            showRound()
        }
    }

    private func showRound() {
        guard matchInfoViewTopConstraint.constant != 0 else { return }

        matchInfoViewTopConstraint.constant = 0
        UIView.animate(
            withDuration: Constants.defaultMatchInfoViewAnimationDuration,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }

    private func hideRound() {
        guard matchInfoViewTopConstraint.constant != Constants.matchInfoViewHiddenTopConstraint else { return }

        matchInfoViewTopConstraint.constant = Constants.matchInfoViewHiddenTopConstraint
        UIView.animate(
            withDuration: Constants.defaultMatchInfoViewAnimationDuration,
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

        tapGestureRecognizer.rx.event.subscribeNext { [weak self] _ in
            self?.viewModel.handleScoringAreaTapped(color: playerColor)
        } >>> disposeBag
    }

    private func setupSwipeGestureRecognizer(targetView: UIView, playerColor: PlayerColor) {
        let swipeGestureRecognizer = UISwipeGestureRecognizer()
        swipeGestureRecognizer.direction = .down
        targetView.addGestureRecognizer(swipeGestureRecognizer)

        swipeGestureRecognizer.rx.event.subscribeNext { [weak self] _ in
            self?.viewModel.handleScoringAreaSwiped(color: playerColor)
        } >>> disposeBag
    }

    private func setupPenaltyButtons() {

        redKyongGoButton.rx.tap.subscribeNext { [weak self] in
            self?.displayConfirmationAlert(playerColor: .red, category: .kyongGo)
        } >>> disposeBag

        redGamJeomButton.rx.tap.subscribeNext { [weak self] in
            self?.displayConfirmationAlert(playerColor: .red, category: .gamJeom)
        } >>> disposeBag

        blueKyongGoButton.rx.tap.subscribeNext { [weak self] in
            self?.displayConfirmationAlert(playerColor: .blue, category: .kyongGo)
        } >>> disposeBag

        blueGamJeomButton.rx.tap.subscribeNext { [weak self] in
            self?.displayConfirmationAlert(playerColor: .blue, category: .gamJeom)
        } >>> disposeBag
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
        redPlayerNameLabel.text = viewModel.redPlayerName
        bluePlayerNameLabel.text = viewModel.bluePlayerName
    }
}
