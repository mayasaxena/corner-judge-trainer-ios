//
//  JudgingViewController.swift
//  Corner Judge Trainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import UIKit
import Intrepid
import RxSwift
import RxCocoa

class JudgingViewController: UIViewController {

    @IBOutlet weak var redHeadshotScoringAreaView: UIView!
    @IBOutlet weak var redScoreLabel: UILabel!
    
    @IBOutlet weak var blueHeadshotScoringAreaView: UIView!
    @IBOutlet weak var blueScoreLabel: UILabel!
    
    let disposeBag = DisposeBag()
    let viewModel: MatchViewModel = MatchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let redTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        redHeadshotScoringAreaView.addGestureRecognizer(redTapGestureRecognizer)
        
        viewModel.redScoreText.asObservable().subscribeNext { scoreText in
            self.redScoreLabel.text = scoreText
        } >>> disposeBag
        
        let blueTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        blueHeadshotScoringAreaView.addGestureRecognizer(blueTapGestureRecognizer)
        
        viewModel.blueScoreText.asObservable().subscribeNext { scoreText in
            self.blueScoreLabel.text = scoreText
        } >>> disposeBag
        
    }
    
    func handleTap(tapGestureRecognizer: UITapGestureRecognizer) {
        if tapGestureRecognizer.view == redHeadshotScoringAreaView {
        } else if tapGestureRecognizer.view == blueHeadshotScoringAreaView {
        }
    }
    
}
