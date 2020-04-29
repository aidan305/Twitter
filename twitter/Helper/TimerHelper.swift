//
//  TimerHelper.swift
//  twitter
//
//  Created by aidan egan on 27/04/2020.
//  Copyright © 2020 Aidan Egan. All rights reserved.
//

import Foundation
protocol TimerDelegate {
    func timeLeftTillRefresh(timeLeft: String)
    func performSearchRefresh()
}

class TimerHelper {
    var timeLeft: Int = 0
    var timer: Timer?
    var timerDelegate: TimerDelegate!
    
    func startTimer(timeToRefresh: String) {
        switch timeToRefresh {
        case "30 seconds":
            print("30 seconds")
            timeLeft = 30
            startTimer()
        case "5 minutes":
            print("5 minutes")
            timeLeft = 300
            startTimer()
        case "15 minutes":
            print("15 minutes")
            timeLeft = 900
            startTimer()
        default:
            print("error no timer set")
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc func fireTimer()
    {
        timeLeft -= 1
        print("\(timeLeft)")
        timerDelegate.timeLeftTillRefresh(timeLeft: "\(timeLeft)")
        
        if timeLeft <= 0 {
            timerDelegate.performSearchRefresh()
            timer?.invalidate()
            timer = nil
        }
    }
}


