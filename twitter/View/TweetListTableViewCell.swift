//
//  TweetListTableViewCell.swift
//  twitter
//
//  Created by Aidan Egan on 11/04/2020.
//  Copyright © 2020 Aidan Egan. All rights reserved.
//

import UIKit
import Foundation

protocol HashtagSelectionDelegate: class {
    func didTapHashtag(hashtag: String)
}

class TweetListTableViewCell: UITableViewCell{
    
    weak var delegate: HashtagSelectionDelegate?
        
    @IBOutlet weak var tweetTextView: UITextView!
    
    
    func setTweetToUi(tweet: TweetListItem) {
        let tweetHelper = TweetHelpers()
        
        let tweetExists = tweetHelper.handleExists(tweetText: tweet.tweetText)
        if tweetExists == true {
            let handles = tweetHelper.getTweetHandles()
            
            for tweetHandle in handles {
                //set the tweetHandle text of tweet.tweetText to color orange (i.e changing text colour of @ handle part of string)
                let range = (tweet.tweetText as NSString).range(of: tweetHandle)
                let attributedText = NSMutableAttributedString.init(string: tweet.tweetText)
                attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
                tweetTextView.attributedText = attributedText
            }
        } else {
            tweetTextView.text = tweet.tweetText
        }
    }
}
