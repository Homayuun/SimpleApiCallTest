//
//  RequestManagerProtocol.swift
//  SimpleAPICall
//
//  Created by Homayun on 1402-01-27.
//

import Foundation

protocol RequestManagerProtocol {
    func sendRequest(request: URLRequest) throws -> HTTPURLResponse
}
