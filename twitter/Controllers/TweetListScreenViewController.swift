//
//  TweetListScreenViewController.swift
//  twitter
//
//  Created by Aidan Egan on 11/04/2020.
//  Copyright © 2020 Aidan Egan. All rights reserved.
//

import UIKit

class TweetListScreenViewController: UIViewController, HashtagSelectionDelegate, TimerDelegate   {
    
    var tweets: [TweetListItem] = []
    let tweetRepository = TweetRepository()
    let tweetHelpers = TweetHelpers()
    var searchText: String?
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var selectedTime: String? = ""
    var selectedHashTag: String? = ""
    let timePicker = UIPickerView()
    var hashTagPicker = UIPickerView()
    var hashTagPickertoolBar = UIToolbar()
    let times = ["15 minutes", "30 seconds", "15 minutes", "no refresh"]
    var hashTags: [String] = []
    
    @IBOutlet weak var settings: UITextView!
    @IBOutlet weak var tweetsTableView: UITableView?
    
    override func viewWillAppear(_ animated: Bool) {
        startTweetActivityIndicator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createRefreshPicker()
        
        
        guard let searchText = searchText else {
            print("error")
            return
        }
        tweetsTableView?.delegate = self
        tweetsTableView?.dataSource = self
        loadTweets(searchText: searchText)
    }
    
    func loadTweets(searchText: String) {
        tweetRepository.fetchTweets(searchText: searchText, completion: {(tweetListDataModel) in
            if let tweetArr = tweetListDataModel {
                for tweet in tweetArr {
                    self.tweets.append(tweet)
                }
            }
            DispatchQueue.main.async {
                self.tweetsTableView?.reloadData()
                self.stopTweetActivityIndicator()
            }
        })
    }
    
    func didTapHashtag(hashtag: String) {
        startTweetActivityIndicator()
        tweets = []
        loadTweets(searchText: hashtag)
    }
    
 
}

//MARK: Activity inidcator
extension TweetListScreenViewController {
    
    func startTweetActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.color = .green
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
    }
    
    func stopTweetActivityIndicator() {
        activityIndicator.stopAnimating()
    }
}

//MARK: Tweet Table view
extension TweetListScreenViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToReturn = TweetListTableViewCell()
        let tweet = tweets[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as? TweetListTableViewCell{
            cell.delegate = self
            cell.setTweetToUi(tweet: tweet)
            cellToReturn = cell
            return cellToReturn
        }
        
        return  cellToReturn
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tweet = tweets[indexPath.row]
        print("row selected with \(tweet)")
        
        if tweets[indexPath.row].hashTag != [] {
            createHashTagPicker(tweet: tweets[indexPath.row])
        } else {
            print("no hashtags for the selected tweet")
        }
    }
    
}




