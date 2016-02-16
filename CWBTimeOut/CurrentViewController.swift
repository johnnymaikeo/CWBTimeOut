//
//  CurrentViewController.swift
//  CWBTimeOut
//
//  Created by Johnny on 7/14/15.
//  Copyright (c) 2015 ExxonMobil. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation

class CurrentViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var timeCounterView: TimeCounterView!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var exitTimeLable: UILabel!
    
    var timer: NSTimer?
    
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "B9407F30-F5F8-466E-AFF9-25556B57FE6D"), identifier: "Estimotes")
    var iBeaconCurrentStatus: NSNumber?
    var iBeaconCurrentRead: NSNumber?
    var iBeaconStatusBufferValue: NSInteger = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedWhenInUse) {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startRangingBeaconsInRegion(region)
        
        self.timeCounterView.counter = 0
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let iAmInTheOffice = defaults.valueForKey("iAmInTheOffice") as? Bool {
            if (iAmInTheOffice){
                self.title = "In the Office"
            } else if (!iAmInTheOffice) {
                self.title = "Out of Office"
            }
        } else {
            self.firstTimeUserSetup()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        for beacon in beacons {
            if beacon.minor == NSNumber(int: 55519)
            {
                if beacon.proximity == CLProximity.Immediate {
                    if self.timeCounterView.counter == 0 {
                        //self.startCountingTime()
                    } else {
                        //self.stopCountingTime()
                    }
                    iBeaconStatusBuffer(1)
                    //println("Immediate")
                } else if beacon.proximity == CLProximity.Near {
                    iBeaconStatusBuffer(1)
                    //println("Near")
                } else if beacon.proximity == CLProximity.Far {
                    iBeaconStatusBuffer(1)
                    //println("Far")
                } else if beacon.proximity == CLProximity.Unknown {
                    iBeaconStatusBuffer(0)
                    //println("Unknown")
                }
            }
        }
    }
    
    func iBeaconStatusBuffer(readStatus: NSNumber) {
        /*
        print("Current Status: ");
        println(self.iBeaconCurrentStatus);
        
        print("Current Read: ");
        println(self.iBeaconCurrentRead);
        */
        if (readStatus != self.iBeaconCurrentRead) {
         
            self.iBeaconCurrentRead = readStatus;
            self.iBeaconStatusBufferValue = 0;
            
        } else {
            
            
            if (self.iBeaconStatusBufferValue == 1) {
                let defaults = NSUserDefaults.standardUserDefaults()
                var iAmInTheOffice = defaults.valueForKey("iAmInTheOffice") as? Bool
                
                if (self.iBeaconCurrentStatus == 0) && (self.iBeaconCurrentRead == 1) {
                    if (!iAmInTheOffice!){
                        self.stopCountingTime()
                    }
                    print("getting close");
                    
                } else if (self.iBeaconCurrentStatus == 1 && self.iBeaconCurrentRead == 0) {
                    print("going far away");
                    
                    if (iAmInTheOffice!){
                        self.startCountingTime()
                        iAmInTheOffice = !iAmInTheOffice!
                        defaults.setValue(iAmInTheOffice, forKey: "iAmInTheOffice")
                        print("in to out the office")
                        self.title = "Out the Office";
                    } else if (!iAmInTheOffice!){
                        iAmInTheOffice = !iAmInTheOffice!
                        defaults.setValue(iAmInTheOffice, forKey: "iAmInTheOffice")
                        updateExitTime()
                        print("out to in the office")
                        self.title = "In of Office";
                    }
                }
                self.iBeaconCurrentStatus = readStatus;
            } else {
                self.iBeaconStatusBufferValue++;
            }
        }
    }
    
    func updateExitTime() {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        self.exitTimeLable.text = "\(components.hour) : \(components.minute)"
    }
    
    func startCountingTime() {
        self.timeCounterView.counter = 0
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateTimeCounter"), userInfo: nil, repeats: true)
    }
    
    func stopCountingTime() {
        self.timer?.invalidate()
    }

    func updateTimeCounter() {
        print("updateTimeCounter");
        if self.timeCounterView.counter < 60 {
            self.timeCounterView.counter += 1;
            self.counterLabel.text = String(timeCounterView.counter);
        } else {
            
            let localNotification = UILocalNotification()
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 5)
            localNotification.alertBody = "You can return now"
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
            self.timeCounterView.counter = 0;
            self.counterLabel.text = String(timeCounterView.counter);
        }
    }
    
    func firstTimeUserSetup() {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let actionSheetController: UIAlertController = UIAlertController(title: "First Time User", message: "Are you currently IN the office?", preferredStyle: .Alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
            defaults.setValue(false, forKey: "iAmInTheOffice")
            self.title = "Out of Office"
        }
        actionSheetController.addAction(cancelAction)

        let nextAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            defaults.setValue(true, forKey: "iAmInTheOffice")
            self.title = "In the Office"
        }
        actionSheetController.addAction(nextAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
}

