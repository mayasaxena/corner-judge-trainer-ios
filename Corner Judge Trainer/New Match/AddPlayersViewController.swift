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

class AddPlayersViewController: UIViewController {
    
    struct Constants {
        static let JudgingSegueIdentifier = "showJudgingWithPlayers"
    }
    
    @IBOutlet weak var redPlayerTextField: UITextField!
    @IBOutlet weak var bluePlayerTextField: UITextField!
    
    @IBOutlet weak var startNewMatchButton: UIButton!
    
    let disposeBag = DisposeBag()
    
    private var shouldBeLandscape = false
    
    var viewModel: MatchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel == nil {
            viewModel = MatchViewModel()
        }
        
        redPlayerTextField.rx_text <-> viewModel.redPlayerName >>> disposeBag
        bluePlayerTextField.rx_text <-> viewModel.bluePlayerName >>> disposeBag
        
        startNewMatchButton.rx_tap.subscribeNext { _ in
            self.transitionToMatchViewController()
        } >>> disposeBag
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.rx_event.subscribeNext { _ in
            self.view.endEditing(true)
        } >>> disposeBag
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.JudgingSegueIdentifier {
            (segue.destinationViewController as? MatchViewController)?.viewModel = viewModel
        }
    }
    
    func transitionToMatchViewController() {
        UIDevice.currentDevice().performSelector(Selector("setOrientation:"),
                                                 withObject: UIInterfaceOrientation.LandscapeLeft.rawValue)
        After(1.5) {
            self.performSegueWithIdentifier(Constants.JudgingSegueIdentifier, sender: self)
        }
        
    }
}