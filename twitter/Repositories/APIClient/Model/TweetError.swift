import Foundation

/// Dumb error to model simple errors
/// In a real implementation this should be more exhaustive
public enum TweetError: Error {
    case encoding
    case decoding
}

