//
//  RequestManagerProtocol.swift
//  SimpleAPICall
//
//  Created by Homayun on 1402-01-27.
//

import Foundation

protocol RequestManagerProtocol {
    func createRequest(from urlString: String) throws -> URLRequest
    func sendRequest(request: URLRequest) throws -> HTTPURLResponse
}
