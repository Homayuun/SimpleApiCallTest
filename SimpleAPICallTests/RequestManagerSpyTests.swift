//
//  SimpleAPICallTests.swift
//  SimpleAPICallTests
//
//  Created by Homayun on 1402-01-27.
//

import XCTest
@testable import SimpleAPICall

final class RequestManagerSpyTests: XCTestCase {
    
    var requestManagerSpy: RequestManagerSpy!
    var urlString: String!
    
    override func setUp() {
        super.setUp()
        requestManagerSpy = RequestManagerSpy()
        urlString = "https://api.apify.com/v2/key-value-stores/SmuuI0oebnTWjRTUh/records/LATEST?disableRedirect=true"
    }
    
    override func tearDown() {
        requestManagerSpy = nil
        super.tearDown()
    }
    
    
    
    //when a fresh object of Spy is created, capturedRequests must be empty
    
    func testCapturedRequests_whenNoRequestsSent_isEmpty() {
        
        let requestManager = RequestManagerSpy()
        
        XCTAssertTrue(requestManager.capturedRequests.isEmpty)
    }
    
    //checks if 'createRequest' correctly creates a valid `URLRequest` object with the expected properties based on a valid URL string

    func testCreateRequest_CreatesARequest() {
        
        let urlRequest = try! requestManagerSpy.createRequest(from: urlString)
        
        XCTAssertTrue(urlRequest.url?.scheme == "https")
        XCTAssertTrue(urlRequest.url?.path == "/v2/key-value-stores/SmuuI0oebnTWjRTUh/records/LATEST")
        XCTAssertTrue(urlRequest.url?.host == "api.apify.com")
    }
    
    //when a URLRequest contains empty url, it should return an error
    
    func testCreateRequest_withInvalidURLString_throwsError() throws {
        let urlString = ""
        
        XCTAssertThrowsError(try requestManagerSpy.createRequest(from: urlString)) { error in
            XCTAssertEqual(error as! RequestError, RequestError.invalidURL)
        }
    }

    //sendRequest method correctly adds request to capturedRequests with correct url and correct http method
    
    func testSendRequest_addsRequestToCapturedRequests_withCorrectUrlAndCorrectMethod() {
        
        let expectedURL = URL(string: urlString)!
        let request = try? requestManagerSpy.createRequest(from: urlString)
        
        let _ = try? requestManagerSpy.sendRequest(request: request!)
        
        XCTAssertEqual(requestManagerSpy.capturedRequests.count, 1)
        XCTAssertEqual(requestManagerSpy.capturedRequests[0].url, expectedURL)
        XCTAssertEqual(requestManagerSpy.capturedRequests[0].httpMethod, "GET")
    }
    
    
    
    //sendRequest mehtod correctly creates a HTTPURLResponse object to a valid URLRequest which is not nil and returns 200 status-code
    
    func testSendRequest_givenValidRequestAndResponse_succeeds() {
        
        let url = URL(string: urlString)!
        let request = try? requestManagerSpy.createRequest(from: urlString)
        
        let expectedResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        requestManagerSpy.responseToRequest(request: request!, response: expectedResponse)
        
        let result = try? requestManagerSpy.sendRequest(request: request!)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.statusCode, expectedResponse.statusCode)
    }
    
    
    
    // Ensures that the responseToRequest method of the spy behaves as expected.
    
    func testResponseToRequest_addsToItemsDictionary() {
        let url = URL(string: urlString)!
        let request = URLRequest(url:url)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        requestManagerSpy.responseToRequest(request: request, response: response)
        
        XCTAssertEqual(requestManagerSpy.items[request], response)
        
    }
    
    
    // throws error if a valid request gets no response perhaps due to a server-side problem.
    
    func testSendRequest_whenResponseNotReturned_throwsError() {
        
        let validURLRequest = try? requestManagerSpy.createRequest(from: urlString)
        
        requestManagerSpy.responseToRequest(request: validURLRequest!, response: nil)
                
        XCTAssertThrowsError(try requestManagerSpy.sendRequest(request: validURLRequest!)) { error in
            XCTAssertEqual(error as? RequestError, RequestError.noResponseFromServer)
        }
    }
}
