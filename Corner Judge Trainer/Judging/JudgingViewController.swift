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
    let matchModel = MatchModel(withMatchID: "aaa", andDate: NSDate.init(timeIntervalSinceNow: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let redTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        redHeadshotScoringAreaView.addGestureRecognizer(redTapGestureRecognizer)
        
        viewModel.redScore.asObservable().subscribeNext { (score) in
            self.redScoreLabel.text = String(score)
        } >>> disposeBag
        
        let blueTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        blueHeadshotScoringAreaView.addGestureRecognizer(blueTapGestureRecognizer)
        
        viewModel.blueScore.asObservable().subscribeNext { (score) in
            self.blueScoreLabel.text = String(score)
        } >>> disposeBag
        
    }
    
    func handleTap(tapGestureRecognizer: UITapGestureRecognizer) {
        if tapGestureRecognizer.view == redHeadshotScoringAreaView {
            matchModel.playerScored(PlayerColor.Red, scoringEvent: ScoringEvent.HeadKick)
        } else if tapGestureRecognizer.view == blueHeadshotScoringAreaView {
            viewModel.blueHeadshot()
        }
    }
    
}
