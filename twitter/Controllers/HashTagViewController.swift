//
//  hashtagPickerController.swift
//  twitter
//
//  Created by aidan egan on 25/05/2020.
//  Copyright © 2020 Aidan Egan. All rights reserved.
//

import UIKit

class HashTagViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    var hashtags: [String]
    var selectedHashtag: String
    
    func createHashtagPicker(tweet: TweetListItem){
        if tweet.hashTag != [] {
            hashtags = tweet.hashTag
        } else {
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return hashtags.count
       }
       
       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return hashtags[row]
       }
       
       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           selectedHashtag = hashtags[row]
           print("this is the hashtag that was selected \(hashtags[row])")
       }
}
