//
//  NewMatchViewController.swift
//  Corner Judge Trainer
//
//  Created by Maya Saxena on 7/29/16.
//  Copyright © 2016 Maya Saxena. All rights reserved.
//

import UIKit

class NewMatchViewController: UIViewController {
    struct Constants {
        static let JudgingSegueIdentifier = "showJudging"
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    @IBAction func newMatchTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add Players?", message: "", preferredStyle: .Alert)
        let addAction = UIAlertAction(title: "Add", style: .Destructive, handler: nil)
        alertController.addAction(addAction)
        let cancelAction = UIAlertAction(title: "No, add later", style: .Cancel) { _ in
            self.performSegueWithIdentifier(Constants.JudgingSegueIdentifier, sender: self)
        }
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
}
