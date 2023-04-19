//
//  APIRepositoryTests.swift
//  SimpleAPICallTests
//
//  Created by Homayun on 1402-01-29.
//

import XCTest
import Foundation

@testable import SimpleAPICall

class APIRepositoryTests: XCTestCase {
    
    var apiRepository: APIRepository?
    
    override func setUp() {
        super.setUp()
        apiRepository = APIRepository()
    }
    func testGetMovies_withExpectedURLHostAndPath () {
        apiRepository.getMovies {}
    }
}
