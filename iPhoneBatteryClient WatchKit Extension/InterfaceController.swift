//
//  InterfaceController.swift
//  iPhoneBatteryClient WatchKit Extension
//
//  Created by Bryce on 10/6/18.
//  Copyright © 2018 Hexalellogram. All rights reserved.
//

import WatchKit
import UIKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // stuff happens, ok
    }
    

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func updateAWBatteryPercent() {
        
        // convert to string
        let batteryStr = convertBatteryPercentToString()
        
        // set label
        AWBatteryLabel.setText(batteryStr)
    }
    
    func convertBatteryPercentToString() -> String
    {
        // enable battery monitoring
        WKInterfaceDevice.current().isBatteryMonitoringEnabled = true
        
        // setup the number formatter
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        
        let battStr : String! = nf.string(from: NSNumber(value: awBatteryLevel*100))
        return battStr
    }
    
    @IBAction func UpdatePercentsButton() {
        updateAWBatteryPercent()
    }
    
    @IBAction func SendToiPhoneButton() {
        let battPercString = convertBatteryPercentToString()
        let dict: Dictionary = ["message": battPercString]
        let session : WCSession = WCSession.default;
        session.sendMessage(dict, replyHandler: nil, errorHandler: {(error ) -> Void in
            // catch any errors here
        })

    }
    
    
    
    var awBatteryLevel: Float {
        return WKInterfaceDevice.current().batteryLevel
    }
    
    @IBOutlet weak var AWBatteryLabel: WKInterfaceLabel!
    
    @IBOutlet weak var iPhoneBatteryLabel: WKInterfaceLabel!
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        
        let battStr = message["Status"] as! String
        
        iPhoneBatteryLabel.setText(battStr)
    }
}
