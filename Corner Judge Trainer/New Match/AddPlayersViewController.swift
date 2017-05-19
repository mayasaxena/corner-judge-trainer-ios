//
//  AddPlayersViewController.swift
//  CornerJudgeTrainer
//
//  Created by Maya Saxena on 8/26/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import UIKit
import Intrepid
import RxSwift

final class AddPlayersViewController: UIViewController {

    struct Constants {
        static let transitionDelay: TimeInterval = 1.5
    }

    @IBOutlet weak var redPlayerTextField: UITextField!
    @IBOutlet weak var bluePlayerTextField: UITextField!

    @IBOutlet weak var startNewMatchButton: UIButton!

    let viewModel: NewMatchViewModel
    let disposeBag = DisposeBag()

    private var shouldBeLandscape = false

    init(viewModel: NewMatchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Use init(viewModel:) instead")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        redPlayerTextField.rx.text.orEmpty <-> viewModel.redPlayerName >>> disposeBag
        bluePlayerTextField.rx.text.orEmpty <-> viewModel.bluePlayerName >>> disposeBag

        startNewMatchButton.rx.tap.single().subscribe(onNext: { _ in
            self.transitionToMatchViewController()
        }) >>> disposeBag

        let tapGestureRecognizer = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.rx.event.subscribe(onNext: { _ in
            self.view.endEditing(true)
        }) >>> disposeBag
    }

    func transitionToMatchViewController() {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")

        After(Constants.transitionDelay) {
            let matchViewController = MatchViewController(matchViewModel: self.viewModel.matchViewModel)
            self.navigationController?.pushViewController(matchViewController, animated: true)
        }
    }
}
