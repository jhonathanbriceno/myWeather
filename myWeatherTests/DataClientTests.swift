//
//  myWeatherTests.swift
//  myWeatherTests
//
//  Created by jhonathan briceno on 2/10/25.
//

@testable import myWeather
import XCTest

class DataClientTest: XCTestCase {
    
    var dataClient: DataClient!
    
    struct MockUser: Codable {
        var email: String
        var id: String
    }
    
    class RequestHandler {
        var receivedHeaderFields: [String: String]?
        
        func handleRequest(_ request: URLRequest) throws -> (HTTPURLResponse, Data) {
            self.receivedHeaderFields = request.allHTTPHeaderFields
            let url = try XCTUnwrap(URL(string: "https://mockRequest"))
            let response = try XCTUnwrap(HTTPURLResponse(
                url: url,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["headerKey": "mockValue"]))
            let data = try JSONEncoder().encode(MockUser(
                email: "mockEmail",
                id: "mockId"))

            return (response, data)
        }
    }
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let urlSession = URLSession(configuration: configuration)
        
        dataClient = DataClient(urlSession: urlSession)
    }
    
    func testDataClientRequestData() async throws {
        
        let requestHandler = RequestHandler()
        
        URLProtocolMock.requestHandler = requestHandler.handleRequest
        let urlRequest = URLRequestDetails(
            url: URL(string: "https://mockRequest")!,
            method: .get,
            headers: ["headerKey": "mockValue"]
        )
        let userResponse: MockUser = try await dataClient.requestData(requestDetails: urlRequest)
        
        let requestHeaderFields = try XCTUnwrap(requestHandler.receivedHeaderFields)
        XCTAssertEqual(
            requestHeaderFields,
            ["headerKey": "mockValue"])
        
        XCTAssertEqual(userResponse.email, "mockEmail")
        XCTAssertEqual(userResponse.id, "mockId")
    }
}
