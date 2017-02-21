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

    @IBAction func newMatchTapped(_ sender: AnyObject) {

        let alertController = UIAlertController(title: "Add Players?", message: "", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(
            title: "Add",
            style: .destructive,
            handler: { _ in
                let addPlayersViewController = AddPlayersViewController(matchType: self.viewModel.matchType)
                self.navigationController?.pushViewController(addPlayersViewController, animated: true)
            })
        )

        alertController.addAction(UIAlertAction(
            title: "No, add later",
            style: .cancel,
            handler: { _ in
                let matchViewController = MatchViewController(matchType: self.viewModel.matchType)
                self.navigationController?.pushViewController(matchViewController, animated: true)
            })
        )

        present(alertController, animated: true, completion: nil)
    }
}
