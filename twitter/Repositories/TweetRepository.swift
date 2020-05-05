//
//  TweetRepository.swift
//  twitter
//
//  Created by Aidan Egan on 13/04/2020.
//  Copyright © 2020 Aidan Egan. All rights reserved.
//

import Foundation

class TweetRepository {

  
    func fetchTweets(searchText: String, completion: @escaping ([TweetListItem]?) -> Void) {
        
        var tweets = [TweetListItem]()
        
        let twitterAPI = STTwitterAPI(oAuthConsumerKey: RepositorySettings.OAuthConsumerKey, consumerSecret: RepositorySettings.ConsumerSecret, oauthToken: RepositorySettings.oauthToken, oauthTokenSecret: RepositorySettings.oauthTokenSecret)
        
        
        twitterAPI?.getSearchTweets(withQuery: searchText, successBlock: { (extraInfo, statuses) in
            for n in 0...statuses!.count - 1 {
                
                var tweetText = ""
                var hashtagsArr = [String]()
                
                let text = statuses?[n] as? [String: AnyObject] //cast to array of any object type
                tweetText = text?["text"] as! String
                
                
                if let entities = text?["entities"] {
                    
                    let hashtags = entities["hashtags"] as! Array<Any>
                    
                    if hashtags.count > 0 {
                        for n in 0...hashtags.count - 1 {
                            let hashTag = hashtags[n] as? Dictionary<String, AnyObject>
                            
                            // print("this is the hash tag text \(hashTag?["text"])")
                            hashtagsArr.append(hashTag?["text"] as! String)
                        }
                        
                    }
                    print("\n")
                }
                
                let tweet = TweetListItem(tweetText: tweetText, hashTag: hashtagsArr)
                tweets.append(tweet)
                
            }
            let tweetDataModel = tweets
            completion(tweetDataModel)
            
        }, errorBlock: {(error) -> Void in print(error!)})
    }
}

