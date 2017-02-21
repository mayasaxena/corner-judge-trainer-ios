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

public final class AddPlayersViewController: UIViewController {
    
    struct Constants {
        static let transitionDelay: TimeInterval = 1.5
    }
    
    @IBOutlet weak var redPlayerTextField: UITextField!
    @IBOutlet weak var bluePlayerTextField: UITextField!
    
    @IBOutlet weak var startNewMatchButton: UIButton!
    
    let viewModel: MatchViewModel
    let disposeBag = DisposeBag()

    private var shouldBeLandscape = false

    init(matchType: MatchType) {
        viewModel = MatchViewModel(matchType: matchType)
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("Use init(model:) instead")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        redPlayerTextField.rx.textInput.text <-> viewModel.redPlayerName >>> disposeBag
        bluePlayerTextField.rx.textInput.text <-> viewModel.bluePlayerName >>> disposeBag
        
        startNewMatchButton.rx.tap.subscribe(onNext: { _ in
            self.transitionToMatchViewController()
        }) >>> disposeBag
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.rx.event.subscribe(onNext: { _ in
            self.view.endEditing(true)
        }) >>> disposeBag
    }
    
    func transitionToMatchViewController() {
        UIDevice.current.perform(
            #selector(setter: UIPrintInfo.orientation),
            with: UIInterfaceOrientation.landscapeLeft.rawValue
        )

        After(Constants.transitionDelay) {
            let matchViewController = MatchViewController(viewModel: self.viewModel)
            self.navigationController?.pushViewController(matchViewController, animated: true)
        }
    }
}
