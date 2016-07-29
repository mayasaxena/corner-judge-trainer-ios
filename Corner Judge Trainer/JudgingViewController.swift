//
//  JudgingViewController.swift
//  Corner Judge Trainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import UIKit

class JudgingViewController: UIViewController {

    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var redScoreLabel: UILabel!
    private var redScore = 0;
    
    @IBOutlet weak var blueView: UIView!
    @IBOutlet weak var blueScoreLabel: UILabel!
    private var blueScore = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        redView.addGestureRecognizer(tapGestureRecognizer)
        blueView.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func handleTap(tapGestureRecognizer: UITapGestureRecognizer) {
        if tapGestureRecognizer.view == redView {
            
        }
    }
    
}
