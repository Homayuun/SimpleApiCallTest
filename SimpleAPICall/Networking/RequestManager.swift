//
//  APIManager.swift
//  SimpleAPICall
//
//  Created by Homayun on 1402-01-27.
//

import Foundation

class APIClient {
    let requestManager: RequestManagerProtocol
    
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func fetchData(completion: @escaping (Result<HTTPURLResponse, Error>) -> Void) {
        guard let url = URL(string: "https://api.apify.com/v2/key-value-stores/SmuuI0oebnTWjRTUh/records/LATEST?disableRedirect=true") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let request = URLRequest(url: url)
        
        do {
            let response = try requestManager.sendRequest(request: request)
            completion(.success(response))
        } catch let error {
            completion(.failure(APIError.invalidResponse(error)))
        }
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponse(Error)
}
