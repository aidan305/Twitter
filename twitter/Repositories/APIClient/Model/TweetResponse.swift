import Foundation

/// Top level response for every request to the Marvel API

public struct TweetResponse<Response: Decodable>: Decodable {
    /// Whether it was ok or not
    public let statuses: [Tweet]?
}
