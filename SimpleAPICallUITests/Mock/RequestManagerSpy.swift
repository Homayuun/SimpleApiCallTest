//
//  RequestManagerSpy.swift
//  SimpleAPICallUITests
//
//  Created by Homayun on 1402-01-27.
//

import Foundation
@testable import SimpleAPICall

class RequestManagerSpy: RequestManagerProtocol {
    
    //Spy
    var capturedRequests = [URLRequest]()
    var items: [URLRequest: HTTPURLResponse] = [:]
    
    //Mock
    func responseToRequest(request: URLRequest, response: HTTPURLResponse) {
        items[request] = response
    }
    func sendRequest(request: URLRequest) throws -> HTTPURLResponse {
        capturedRequests.append(request)
        return items[request]!
    }
}
