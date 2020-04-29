//
//  TweetHelpers.swift
//  twitter
//
//  Created by aidan egan on 21/04/2020.
//  Copyright © 2020 Aidan Egan. All rights reserved.
//

import Foundation

class TweetHelpers {
    
    var wordsInTweet:[String] = []
    var tweetHandle: [String] = []
    
    func handleExists(tweetText: String) -> Bool {
        var handleExists: Bool = false
        wordsInTweet =  tweetText.components(separatedBy: " ")
        
        for n in 0...wordsInTweet.count - 1 {
            if wordsInTweet[n].contains("@") {
                handleExists = true
                tweetHandle.append("\(wordsInTweet[n])")
            } 
        }
        
        return handleExists
    }
    
    func getTweetHandles()-> [String] {
        return tweetHandle
    }
}
