//
//  NewMatchViewController.swift
//  Corner Judge Trainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import UIKit
import RxSwift
import Intrepid

class NewMatchViewController: UIViewController {
    
    struct Constants {
        static let JudgingSegueIdentifier = "showJudging"
        static let AddPlayersSegueIdentifier = "showAddPlayers"
    }
    
    @IBOutlet var radioButtons: [RadioButton]!
    @IBOutlet weak var judgeNewMatchButton: RoundedButton!
    
    let viewModel = MatchViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var i = 0
        for radioButton in radioButtons {
            radioButton.rx_selected <- viewModel.radioButtonsSelected[i] >>> disposeBag
            
            radioButton.rx_tap.subscribeNext { button in
                guard let index = self.radioButtons.indexOf(radioButton) else { return }
                self.viewModel.setRadioButtonSelected(atIndex: index)
            } >>> disposeBag
            
            i += 1
        }
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    @IBAction func newMatchTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add Players?", message: "", preferredStyle: .Alert)
        
        let addAction = UIAlertAction(title: "Add", style: .Destructive) { _ in
            self.performSegueWithIdentifier(Constants.AddPlayersSegueIdentifier, sender: self)
        }
        alertController.addAction(addAction)
        
        let cancelAction = UIAlertAction(title: "No, add later", style: .Cancel) { _ in
            self.performSegueWithIdentifier(Constants.JudgingSegueIdentifier, sender: self)
        }
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.JudgingSegueIdentifier {
            guard let matchViewController = segue.destinationViewController as? MatchViewController else { return }
            matchViewController.viewModel = viewModel
        } else if segue.identifier == Constants.AddPlayersSegueIdentifier {
            guard let addPlayersViewController = segue.destinationViewController as? AddPlayersViewController else { return }
            addPlayersViewController.viewModel = viewModel
        }
    }
}
