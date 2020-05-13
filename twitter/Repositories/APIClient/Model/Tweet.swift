import Foundation

/// All successful tweet responses return the below

public struct Tweet: Decodable {
    public let text: String
    public let id_str: String
    public let entities: Entities
    
}

public struct Entities: Decodable {
    public let hashtags: [Hashtag]
}

public struct Hashtag: Decodable {
    public let text: String
}

