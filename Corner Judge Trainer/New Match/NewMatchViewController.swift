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
        static let matchSegueIdentifier = "showMatch"
        static let addPlayersSegueIdentifier = "showAddPlayers"
    }
    
    @IBOutlet var radioButtons: [RadioButton]!
    @IBOutlet weak var judgeNewMatchButton: RoundedButton!
    
    let viewModel = NewMatchViewModel()
    
    let disposeBag = DisposeBag()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        for (index, radioButton) in radioButtons.enumerated() {
            radioButton.rx.isSelected <- viewModel.radioButtonsSelected[index] >>> disposeBag

            radioButton.rx.tap.subscribe { button in
                guard let index = self.radioButtons.index(of: radioButton) else { return }
                self.viewModel.setRadioButtonSelected(atIndex: index)
            } >>> disposeBag
        }
    }
    
    override public var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    @IBAction func newMatchTapped(_ sender: AnyObject) {

        let alertController = UIAlertController(title: "Add Players?", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .destructive) { _ in
            self.performSegue(withIdentifier: Constants.addPlayersSegueIdentifier, sender: self)
        }
        alertController.addAction(addAction)
        
        let cancelAction = UIAlertAction(title: "No, add later", style: .cancel) { _ in
            self.performSegue(withIdentifier: Constants.matchSegueIdentifier, sender: self)
        }
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
