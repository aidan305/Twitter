//
//  SearchScreenViewController.swift
//  twitter
//
//  Created by Aidan Egan on 11/04/2020.
//  Copyright © 2020 Aidan Egan. All rights reserved.
//

import UIKit

class SearchScreenViewController: UIViewController {
    
    @IBOutlet weak var searchTextBox: UITextField!
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextBox.text = defaults.value(forKey: "SearchTextSaved" ) as? String
    }
    
    
    @IBAction func searchButtonClicked(_ sender: Any) {
        
        if let tweetListScreenVC = self.storyboard?.instantiateViewController(identifier: "TweetListScreenViewControllerID") as TweetListScreenViewController? {
            
            tweetListScreenVC.searchText = searchTextBox.text
            defaults.set(searchTextBox.text, forKey: "SearchTextSaved")
            
            navigationController?.pushViewController(tweetListScreenVC, animated: true)
        }
    }
}


