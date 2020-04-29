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
    var tweetListTableViewCell = TweetListTableViewCell()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    var selectedTime: String? = ""
    let times = ["15 minutes", "30 seconds", "15 minutes", "no refresh"]
    
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
        tweets = []
    }
    
    func didTapHashtag(hashtag: String) {
        //getting called everytime a user selects hashtag (pressed in tweetlistTableViewCell)
        startTweetActivityIndicator()
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
        let tweet = tweets[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell") as! TweetListTableViewCell
        cell.delegate = self
        cell.setTweetToUi(tweet: tweet)
        return cell
    }
    
}

//MARK: UI picker setup for timer refresh
extension TweetListScreenViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return times.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return times[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedTime = times[row]
        settings.text = times[row]
    }
    
    func createRefreshPicker() {
        settings.isEditable = false
        settings.isSelectable = true
        let timePicker = UIPickerView()
        timePicker.delegate = self
        settings.inputView = timePicker
        createPickerToolbar()
    }
    
    func createPickerToolbar() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self,
                                         action: #selector(TweetListScreenViewController.dismissKeyboard))
        toolbar.setItems([doneButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        settings.inputAccessoryView = toolbar
        
    }

    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
        let timer = TimerHelper()
        timer.timerDelegate = self
        
        if settings.text == "30 seconds" {
            timer.startTimer(timeToRefresh: "30 seconds")
        }
        else if settings.text == "5 minutes" {
            timer.startTimer(timeToRefresh: "5 minutes")
        }
        else if settings.text == "15 minutes" {
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
            settings.text = "Refreshed"
    }
}
}



