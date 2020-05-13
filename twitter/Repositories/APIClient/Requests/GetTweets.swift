import Foundation

public struct GetTweets: APIRequest {
    public typealias Response = Tweet
    
    public var resourceName: String {
        return "search/tweets.json"
    }
    
    //Parameters
    public let q: String?
    public let result_type: String?
    public let count: Int?
    
    public init(q: String? , result_type: String? = "mixed", count: Int? = 8) {
        self.q = q
        self.result_type = result_type
        self.count = count
    }
}

