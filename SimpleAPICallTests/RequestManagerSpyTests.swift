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
    
    override func setUp() {
        super.setUp()
        requestManagerSpy = RequestManagerSpy()
    }
    
    override func tearDown() {
        requestManagerSpy = nil
        super.tearDown()
    }
    
    
    
    //when an object of Spy is created, capturedRequests must be empty
    
    func testCapturedRequests_whenNoRequestsSent_isEmpty() {
        
        let requestManager = RequestManagerSpy()
        
        XCTAssertTrue(requestManager.capturedRequests.isEmpty)
    }
    
    
    
    //sendRequest method correctly adds request to capturedRequests with correct url and correct http method
    
    func testSendRequest_addsRequestToCapturedRequests_withCorrectUrlAndCorrectMethod() {
        
        let url = URL(string: "https://api.apify.com/v2/key-value-stores/SmuuI0oebnTWjRTUh/records/LATEST?disableRedirect=true")!
        let request = URLRequest(url: url)
        
        let _ = try? requestManagerSpy.sendRequest(request: request)
        
        XCTAssertEqual(requestManagerSpy.capturedRequests.count, 1)
        XCTAssertEqual(requestManagerSpy.capturedRequests[0].url, url)
        XCTAssertEqual(requestManagerSpy.capturedRequests[0].httpMethod, "GET")
    }
    
    
    
    //sendRequest mehtod correctly creates a HTTPURLResponse object to a valid URLRequest which is not nil and returns 200 status-code
    
    func testSendRequest_givenValidRequestAndResponse_succeeds() {
        
        let url = URL(string: "https://api.apify.com/v2/key-value-stores/SmuuI0oebnTWjRTUh/records/LATEST?disableRedirect=true")!
        let request = URLRequest(url: url)
        
        let expectedResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        requestManagerSpy.responseToRequest(request: request, response: expectedResponse)
        
        let result = try? requestManagerSpy.sendRequest(request: request)
        
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.statusCode, expectedResponse.statusCode)
    }
    
    
    
    // Ensures that the responseToRequest method of the spy behaves as expected.
    
    func testResponseToRequest_addsToItemsDictionary() {
        let url = URL(string: "https://google.com")!
        let request = URLRequest(url:url)
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        
        requestManagerSpy.responseToRequest(request: request, response: response)
        
        XCTAssertEqual(requestManagerSpy.items[request], response)
        
    }
    
    
    // throws error if a valid request gets no response perhaps due to a server-side problem.
    
    func testSendRequest_whenResponseNotReturned_throwsError() {
        
        let validURL = URL(string: "https://api.apify.com/v2/key-value-stores/SmuuI0oebnTWjRTUh/records/LATEST?disableRedirect=true")!
        let validURLRequest = URLRequest(url: validURL)
        
        requestManagerSpy.items = [:]
        
        var thrownError: Error?
        
        XCTAssertThrowsError(try requestManagerSpy.sendRequest(request: validURLRequest)) { error in
            thrownError = error
            XCTAssertNotNil(thrownError)
            XCTAssertEqual(error as? RequestError, RequestError.noResponseFromServer)
        }
    }
    
    
    func testSendRequestThrowsErrorWhenItemsDictionaryDoesNotContainURLRequest() {
        // Given
        let spy = RequestManagerSpy()
        let request = URLRequest(url: URL(string: "https://example.com")!)
        
        // When
        do {
            try spy.sendRequest(request: request)
            XCTFail("Expected error to be thrown")
        } catch RequestError.noResponseFromServer {
            // Then
            XCTAssertEqual(spy.capturedRequests, [request])
        } catch {
            XCTFail("Unexpected error thrown")
        }
    }

    
    //MARK: - ASK
//    func testSendRequest_givenInvalidURLRequest_throwsError() {
//        let validURL = URL(string: "https://api.apify.com/v2/key-value-stores/SmuuI0oebnTWjRTUh/records/LATEST?disableRedirect=true")!
//        let invalidURL =  URL(string: "https://api.apify.com/v22/key-value-SCORE")!
//        let invalidRequest = URLRequest(url: invalidURL)
//        let validRequest = URLRequest(url: validURL)
//
//        let mockResponse = HTTPURLResponse(url: validRequest.url!, statusCode: 400, httpVersion: nil, headerFields: nil)!
//        requestManagerSpy.responseToRequest(request: invalidRequest, response: mockResponse)
//
//        XCTAssertThrowsError(try requestManagerSpy.sendRequest(request: invalidRequest)) { error in
//            XCTAssertEqual(error as? RequestError, RequestError.invalidURL)
//        }
//
//    }
}
