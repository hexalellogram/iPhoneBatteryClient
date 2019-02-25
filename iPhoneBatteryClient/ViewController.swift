//
//  ViewController.swift
//  iPhoneBatteryClient
//
//  Created by Bryce on 10/6/18.
//  Copyright © 2018 Hexalellogram. All rights reserved.
//

import UIKit
import WatchConnectivity

class ViewController: UIViewController, WCSessionDelegate{
    
    var lastMessage: CFAbsoluteTime = 0

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // nothing happens i guess
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        // nothing yet
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        // nothing yet
    }
    
    //MARK: Properties

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        UIDevice.current.isBatteryMonitoringEnabled = true
        updateiPhoneBatteryPercent()
        
        // communication setup
        if (WCSession.isSupported()) {
            let session = WCSession.default
            session.delegate = self;
            session.activate()
            
        }
    }
    
    func updateiPhoneBatteryPercent() {
        // convert to string
        let batteryStr = convertBatteryPercentToString()
        
        // set label
        iPhonePercentLabel.text = batteryStr
        
    }
    
    func convertBatteryPercentToString() -> String
    {
        // enable battery monitoring
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        // setup the number formatter
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        
        let battStr : String! = nf.string(from: NSNumber(value: iphoneBatteryLevel*100))
        return battStr
    }
    
    @IBOutlet weak var iPhonePercentLabel: UILabel!
    
    @IBAction func UpdateiPhoneButton(_ sender: Any) {
        updateiPhoneBatteryPercent()
    }
    var iphoneBatteryLevel: Float {
        return UIDevice.current.batteryLevel
    }

    
    @IBAction func SendToWatchButton(_ sender: Any) {
        sendWatchMessage()
    }
    
    
    func sendWatchMessage() {
        let currentTime = CFAbsoluteTimeGetCurrent()
        
        // if less than half a second has passed, bail out
        if lastMessage + 0.5 > currentTime {
            return
        }
        
        // send a message to the watch if it's reachable
        if (WCSession.default.isReachable) {
            let battStr = convertBatteryPercentToString()
            let message = ["Status": battStr]
            WCSession.default.sendMessage(message, replyHandler: nil)
        }
        
        // update our rate limiting property
        lastMessage = CFAbsoluteTimeGetCurrent()
    }
    

}

