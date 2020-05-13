import Foundation
import OhhAuth

public typealias ResultCallback<Value> = (Result<Value, Error>) -> Void

public class TweetAPIClient {
    private let baseEndpointUrl = URL(string: "https://api.twitter.com/1.1/")!
    private let session = URLSession(configuration: .default)
    
    public func send<T: APIRequest>(_ request: T, completion: @escaping (ResultCallback<[Tweet]>)) {
    
    let endpoint = self.endpoint(for: request)
    let urlRequest = authorizeAPIEndpoint(endpoint: endpoint)
        
    let task = session.dataTask(with: urlRequest) { data, response, error in
        if let data = data {
            do {
                // Decode the top level response, and look up the decoded response to see
                // if it's a success or a failure
                let tweetResponse = try JSONDecoder().decode(TweetResponse<T.Response>.self, from: data)
                
                if let dataContainer = tweetResponse.statuses {
                    completion(.success(dataContainer)) //dataContainer[0] is basically the first tweet
                } else {
                    completion(.failure(TweetError.decoding))
                }
            } catch {
                completion(.failure(error))
            }
        } else if let error = error {
            completion(.failure(error))
        }
    }
    task.resume()
            
    }
    
    
    /// Encodes a URL based on the given request
    /// Everything needed for a public request to Marvel servers is encoded directly in this URL
    private func endpoint<T: APIRequest>(for request: T) -> URL {
        
        guard let baseUrl = URL(string: request.resourceName, relativeTo: baseEndpointUrl) else {
            fatalError("Bad resourceName: \(request.resourceName)")
        }
        
        var components =  URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)!
        
        //Custom Query items needed for specific requests
        let customQueryItems: [URLQueryItem]
        
        do {
            customQueryItems = try URLQueryItemEncoder.encode(request) // we need to create a custom URLQueryItemEncoder as the request is type encodable.
        } catch {
            fatalError("Wrong parameters: \(error)")
        }
        
        components.queryItems =  customQueryItems
        
        // Construct the final URL with all the previous data
        return components.url!
        
    }
    
    func authorizeAPIEndpoint(endpoint: URL) -> URLRequest{
        var urlRequest = URLRequest(url: endpoint)
        //using ohhAuth pod to authenticate us
        urlRequest.oAuthSign(method: "GET", consumerCredentials: APIKey.consumerAPIKeys)
        return urlRequest
    }
}

