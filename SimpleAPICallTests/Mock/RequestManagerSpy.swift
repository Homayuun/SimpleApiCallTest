//
//  File.swift
//  SimpleAPICallTests
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
        
        guard let response = items[request] else {
            throw RequestError.invalidResponse
        }
        
        guard request.url != nil else {
            throw RequestError.invalidURL
        }
        return response
    }
}

enum RequestError: Error {
    case invalidURL
    case noResponseFromServer
    case invalidResponse
}

