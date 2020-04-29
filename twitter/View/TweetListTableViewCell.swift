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

class TweetListTableViewCell: UITableViewCell {
    
    weak var delegate: HashtagSelectionDelegate?
    
    @IBOutlet weak var tweetTextLbl: UILabel!
    @IBOutlet weak var hashTagButton1: UIButton!
    @IBOutlet weak var hashTagButton2: UIButton!
    @IBOutlet weak var hashTagButton3: UIButton!
    
    func setTweetToUi(tweet: TweetListItem) {
        let tweetHelper = TweetHelpers()
        
        if tweet.hashTag.count > 0 {
            hashTagButton1.setTitle("#\(tweet.hashTag[0])", for: .normal)
            hashTagButton1.setTitleColor(.blue, for: .normal)
        } 
        
        if tweet.hashTag.count > 1 {
            hashTagButton2.setTitle("#\(tweet.hashTag[1])", for: .normal)
            hashTagButton2.setTitleColor(.blue, for: .normal)
        }
        
        if tweet.hashTag.count > 2 {
            hashTagButton3.setTitle("#\(tweet.hashTag[2])", for: .normal)
            hashTagButton3.setTitleColor(.blue, for: .normal)
        }
        
        let tweetExists = tweetHelper.handleExists(tweetText: tweet.tweetText)
        if tweetExists == true {
            let handles = tweetHelper.getTweetHandles()
            
            for tweetHandle in handles {
                //set the tweetHandle text of tweet.tweetText to color orange (i.e changing text colour of @ handle part of string)
                let range = (tweet.tweetText as NSString).range(of: tweetHandle)
                let attributedText = NSMutableAttributedString.init(string: tweet.tweetText)
                attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.orange , range: range)
                tweetTextLbl.attributedText = attributedText
            }
        } else {
            tweetTextLbl.text = tweet.tweetText
        }
    }
    
    @IBAction func button1Pressed(_ sender: UIButton) {
        if let hashtag = hashTagButton1.currentTitle {
            delegate?.didTapHashtag(hashtag: hashtag)
        }
    }
    
    @IBAction func button2Pressed(_ sender: Any) {
        if let hashtag = hashTagButton2.currentTitle {
            delegate?.didTapHashtag(hashtag: hashtag)
        }
    }
    
    @IBAction func button3Pressed(_ sender: Any) {
        if let hashtag = hashTagButton3.currentTitle {
            delegate?.didTapHashtag(hashtag: hashtag)
        }
    }
}
