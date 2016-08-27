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
    
    private var shouldBeLandscape = false
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startNewMatchButton.rx_tap.subscribeNext { _ in
            self.transitionToJudgingViewController()
        } >>> disposeBag
        
        let tapGestureRecognizer = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.rx_event.subscribeNext { _ in
            self.view.endEditing(true)
        } >>> disposeBag
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.JudgingSegueIdentifier {
            guard let judgingViewController = segue.destinationViewController as? JudgingViewController else { return }
            judgingViewController.viewModel.addPlayerNames(redPlayerTextField.text, bluePlayerName: bluePlayerTextField.text)
        }
    }
    
    func transitionToJudgingViewController() {
        UIDevice.currentDevice().performSelector(Selector("setOrientation:"),
                                                 withObject: UIInterfaceOrientation.LandscapeLeft.rawValue)
        After(1.5) {
            self.performSegueWithIdentifier(Constants.JudgingSegueIdentifier, sender: self)
        }
        
    }
}
