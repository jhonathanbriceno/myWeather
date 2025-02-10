//
//  DataClient.swift
//  myWeather
//
//  Created by jhonathan briceno on 2/10/25.
//

import Foundation

enum HTTPMethod: String {
    case delete = "DELETE"
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

typealias HTTPHeaders = [String: String]

struct URLRequestDetails {
    
    var url: URL
    var method: HTTPMethod = .get
    var headers: HTTPHeaders? = nil
}

protocol RequestingProtocol {
    func requestData<T: Decodable>(requestDetails: URLRequestDetails) async throws -> T
}

class DataClient: RequestingProtocol {
    
    let urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    /// Generic method to handle different types of URL request sing Async/Await
    ///
    /// - requestDetails: property with URLRequest components to be used for the url request
    /// - Throws: Error in case there are issues with either the request or decoding the data
    /// - returns: Decoded object
    func requestData<T: Decodable>(requestDetails: URLRequestDetails) async throws -> T {
        
        do {
            let jsonDecoder = JSONDecoder()
            var urlRequest = URLRequest(url: requestDetails.url, cachePolicy: .reloadIgnoringLocalCacheData)
            
            if let headers = requestDetails.headers {
                urlRequest.allHTTPHeaderFields = headers
            }
            
            urlRequest.httpMethod = requestDetails.method.rawValue
            
            let (data, _) = try await urlSession.data(for: urlRequest)
            let objects = try jsonDecoder.decode(T.self, from: data)
            return objects
        } catch (let error) {
            throw error
        }
    }
}
