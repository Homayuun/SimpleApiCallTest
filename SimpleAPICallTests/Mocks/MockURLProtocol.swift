//
//  MockURLProtocol.swift
//  SimpleAPICallTests
//
//  Created by Homayun on 1402-02-01.
//

import Foundation
@testable import SimpleAPICall


class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse?, Data?, Error?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override func startLoading() {
        returnMockResponse()
    }
    override func stopLoading() {
        returnMockResponse()
    }
    
    
}
