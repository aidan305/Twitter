//
//  TweetRepository.swift
//  twitter
//
//  Created by Aidan Egan on 13/04/2020.
//  Copyright © 2020 Aidan Egan. All rights reserved.
//

import Foundation

class TweetRepository {
    
    let apiClient = TweetAPIClient()    
    func fetchTweets(searchText: String, completion: @escaping ([TweetListItem]?) -> Void) {
        
        var tweets = [TweetListItem]()
        
        apiClient.send(GetTweets(q: "\(searchText)")) { response in
            do {
                let dataContainer = try response.get()
                
                for tweet in dataContainer {
                    var tweetText = ""
                    var hashtagsArr = [String]()
                    tweetText = tweet.text
                    for hashtags in tweet.entities.hashtags {
                        hashtagsArr.append(hashtags.text)
                    }
                    let tweet = TweetListItem(tweetText: tweetText, hashTag: hashtagsArr)
                    tweets.append(tweet)
                }
                
                let tweetDataModel = tweets
                completion(tweetDataModel)
            }
            catch {
                print(error)
            }
        }
    }
}

