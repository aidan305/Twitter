import UIKit

//MARK: UI picker for timer refresh and hashtag selection
extension TweetListScreenViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var rowCount = 0
        
        if pickerView == timePicker {
            rowCount = times.count
        } else if pickerView == hashTagPicker {
            rowCount = hashTags.count
        }
        return rowCount
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var rowTitle = ""
        
        if pickerView == timePicker {
            rowTitle = times[row]
        } else if pickerView == hashTagPicker {
            rowTitle = hashTags[row]
        }
        return "#\(rowTitle)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == timePicker {
            selectedTime = times[row]
            settings.text = times[row]
        } else if pickerView == hashTagPicker {
            selectedHashTag = hashTags[row]
        }
    }

    //MARK: Hashtag picker functions
    func createHashTagPicker(tweet: TweetListItem) {
        hashTags = []
        hashTags = tweet.hashTag
        
        hashTagPicker = UIPickerView.init()
        hashTagPicker.delegate = self
        hashTagPicker.backgroundColor = UIColor.white
        hashTagPicker.setValue(UIColor.black, forKey: "textColor")
        hashTagPicker.autoresizingMask = .flexibleWidth
        hashTagPicker.contentMode = .center
        hashTagPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 200)
        self.view.addSubview(hashTagPicker)
        createHashTagPickerToolbar()
        
    }
    
    func createHashTagPickerToolbar() {
        hashTagPickertoolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 200, width: UIScreen.main.bounds.size.width, height: 50))
        hashTagPickertoolBar.items = [UIBarButtonItem.init(title: "Search", style: .done, target: self, action: #selector(onDoneButtonTapped))]
        self.view.addSubview(hashTagPickertoolBar)
    }
    
    @objc func onDoneButtonTapped() {
        hashTagPickertoolBar.removeFromSuperview()
        hashTagPicker.removeFromSuperview()
        
        if let hashtag = selectedHashTag {
            startTweetActivityIndicator()
            tweets = []
            loadTweets(searchText: hashtag)
        }
    }
    
    
  
    //MARK: timer refresh picker functions
    func createRefreshPicker() {
        settings.isEditable = false
        settings.isSelectable = true
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
            startTweetActivityIndicator()
            settings.text = "Refreshed"
            
    }
}
}
