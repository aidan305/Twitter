//
//  TweetListScreenViewController.swift
//  twitter
//
//  Created by Aidan Egan on 11/04/2020.
//  Copyright © 2020 Aidan Egan. All rights reserved.
//

import UIKit

class TweetListScreenViewController: UIViewController, GenericPickerViewDelegate  {
    
    var tweets: [TweetListItem] = []
    let tweetRepository = TweetRepository()
    let tweetHelpers = TweetHelpers()
    var searchText: String?
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var hashTagPickertoolBar = UIToolbar()
    let times = ["15 minutes", "30 seconds", "15 minutes", "no refresh"]
    var hashTags: [String] = []
    var didSelectSettings: Bool = false
    var didSelectTweet: Bool = false
    var tweetCell = TweetListTableViewCell()
    var timerPicker = GenericPickerView()
    let hashtagPicker = GenericPickerView()
    
    @IBOutlet weak var settings: UITextField!
    @IBOutlet weak var tweetsTableView: UITableView?
    
    @IBAction func settingsPressed(_ sender: Any) {
        didSelectSettings = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let searchText = searchText else {
            print("error")
            return
        }
        
        tweetsTableView?.delegate = self
        tweetsTableView?.dataSource = self
        loadTweets(searchText: searchText)
        
        timerPicker.rowItemTitles = self.times
        self.settings.inputView = self.timerPicker.customPicker
        self.settings.inputAccessoryView = self.timerPicker.toolbar
        
        self.timerPicker.genericDelegate = self
        self.hashtagPicker.genericDelegate = self
        
        self.timerPicker.reloadAllComponents()
        self.hashtagPicker.reloadAllComponents()
    }
    
    func loadTweets(searchText: String) {
        tweetRepository.fetchTweets(searchText: searchText, completion: {(tweetListDataModel) in
            if let tweetArr = tweetListDataModel {
                self.tweets = []
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
    
    //MARK: Picker actions on selecting toolbar buttons
    func didTapDone() {
        
        //i.e they selected settings
        if didSelectSettings == true {
            let row = self.timerPicker.customPicker.selectedRow(inComponent: 0)
            self.timerPicker.customPicker.selectRow(row, inComponent: 0, animated: false)
            self.settings.text = self.times[row]
            startTimer(timerCount: self.times[row])
            self.settings.resignFirstResponder()
            didSelectSettings = false
        } else {
            let row = self.hashtagPicker.customPicker.selectedRow(inComponent: 0)
            self.hashtagPicker.customPicker.selectRow(row, inComponent: 0, animated: false)
            print("hashtag selected was \(hashtagPicker.selectedRow)")
            self.hashtagPicker.reloadAllComponents()
            didSelectTweet = false
            self.view.endEditing(true)
            loadTweets(searchText: hashtagPicker.selectedRow)
        }
    }
    
    func didTapCancel() {
        self.hashtagPicker.reloadAllComponents()
        self.view.endEditing(true)
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
        let tweet = tweets[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as? TweetListTableViewCell{
            cell.setTweetToUi(tweet: tweet)
            hashtagPicker.rowItemTitles = tweets[indexPath.row].hashTag
            cell.tweetTextView.inputView = hashtagPicker.customPicker
            cell.tweetTextView.inputAccessoryView = hashtagPicker.toolbar
            tweetCell = cell
            return tweetCell
        }
        return  tweetCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tweet = tweets[indexPath.row]
        print("row selected with \(tweet)")
    }
}

//MARK: timer refresh picker functions
extension TweetListScreenViewController: TimerDelegate{
    
    func startTimer(timerCount: String) {
        view.endEditing(true)
        
        let timer = TimerHelper()
        timer.timerDelegate = self
        
        if timerCount == "30 seconds" {
            timer.startTimer(timeToRefresh: "30 seconds")
        }
        else if timerCount == "5 minutes" {
            timer.startTimer(timeToRefresh: "5 minutes")
        }
        else if timerCount == "15 minutes" {
            timer.startTimer(timeToRefresh: "15 minutes")
        }
        else {
            return
        }
    }
    
    func timeLeftTillRefresh(timeLeft: String) {
        settings.text = "\(timeLeft)s left"
    }
    
    func performSearchRefresh() {
        if let searchTerm = searchText {
            loadTweets(searchText: searchTerm)
            self.startTweetActivityIndicator()
            self.settings.text = "Refreshed"
        }
    }
    
}



