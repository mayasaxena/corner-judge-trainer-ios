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

public final class NewMatchViewController: UIViewController {
    
    struct Constants {
        static let MatchSegueIdentifier = "showMatch"
        static let AddPlayersSegueIdentifier = "showAddPlayers"
    }
    
    @IBOutlet var radioButtons: [RadioButton]!
    @IBOutlet weak var judgeNewMatchButton: RoundedButton!
    
    let viewModel = NewMatchViewModel()
    
    let disposeBag = DisposeBag()
    
    override public func viewDidLoad() {
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
    
    override public func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    @IBAction func newMatchTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add Players?", message: "", preferredStyle: .Alert)
        
        let addAction = UIAlertAction(title: "Add", style: .Destructive) { _ in
            self.performSegueWithIdentifier(Constants.AddPlayersSegueIdentifier, sender: self)
        }
        alertController.addAction(addAction)
        
        let cancelAction = UIAlertAction(title: "No, add later", style: .Cancel) { _ in
            self.performSegueWithIdentifier(Constants.MatchSegueIdentifier, sender: self)
        }
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}
