//
//  TweetListData.swift
//  twitter
//
//  Created by Aidan Egan on 13/04/2020.
//  Copyright © 2020 Aidan Egan. All rights reserved.
//

import Foundation
import UIKit

struct TweetListData: Codable {
   public var statuses: [Status] 
}

struct Status: Codable {
    public var text: String
    public var entites: Entities
}

struct Entities: Codable {
    public var hashtag: [HashTags]
}

struct HashTags: Codable {
    public var text: String
}

