//
//  CurrentViewController.swift
//  CWBTimeOut
//
//  Created by Johnny on 7/14/15.
//  Copyright (c) 2015 ExxonMobil. All rights reserved.
//

import UIKit
import Foundation

class CurrentViewController: UIViewController {
    
    @IBOutlet weak var timeCounterView: TimeCounterView!
    @IBOutlet weak var counterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.timeCounterView.counter = 0;
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let iAmInTheOffice = defaults.valueForKey("iAmInTheOffice") as? Bool {
            var a = 1;
        } else {
            // First time user
            self.firstTimeUserSetup()
        }
        
        /*
        var updateTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimeCounter"), userInfo: nil, repeats: true)
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func updateTimeCounter() {
        println("updateTimeCounter");
        if self.timeCounterView.counter < 60 {
            self.timeCounterView.counter += 1;
            self.counterLabel.text = String(timeCounterView.counter);
        } else {
            self.timeCounterView.counter = 0;
            self.counterLabel.text = String(timeCounterView.counter);
        }
    }
    
    func firstTimeUserSetup() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let actionSheetController: UIAlertController = UIAlertController(title: "First Time User", message: "Are you currently IN the office?", preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
            defaults.setValue(false, forKey: "iAmInTheOffice")
        }
        actionSheetController.addAction(cancelAction)

        let nextAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            defaults.setValue(true, forKey: "iAmInTheOffice")
        }
        actionSheetController.addAction(nextAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
}

