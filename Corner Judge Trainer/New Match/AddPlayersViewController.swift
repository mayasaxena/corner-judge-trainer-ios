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
        static let MatchSegueIdentifier = "showMatchFromAddPlayers"
    }
    
    @IBOutlet weak var redPlayerTextField: UITextField!
    @IBOutlet weak var bluePlayerTextField: UITextField!
    
    @IBOutlet weak var startNewMatchButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    private var shouldBeLandscape = false
    
    var viewModel: MatchViewModel!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel == nil {
            viewModel = MatchViewModel()
        }
        
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
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.MatchSegueIdentifier {
            (segue.destination as? MatchViewController)?.viewModel = viewModel
        }
    }
    
    func transitionToMatchViewController() {
        UIDevice.current.perform(#selector(setter: UIPrintInfo.orientation),
                                                 with: UIInterfaceOrientation.landscapeLeft.rawValue)
        After(1.5) {
            self.performSegue(withIdentifier: Constants.MatchSegueIdentifier, sender: self)
        }
    }
}
