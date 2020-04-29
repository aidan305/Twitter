//
//  ActivityindicatorHelper.swift
//  twitter
//
//  Created by aidan egan on 22/04/2020.
//  Copyright © 2020 Aidan Egan. All rights reserved.
//

import Foundation
import UIKit

class ActivityIndicatorHelper {
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let tweetListScreenVC = TweetListScreenViewController()
    
    func startTweetActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.color = .green
        activityIndicator.center = tweetListScreenVC.view.center
        tweetListScreenVC.view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopTweetActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}
