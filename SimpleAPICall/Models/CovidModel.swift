//
//  CovidModel.swift
//  SimpleAPICall
//
//  Created by Homayun on 1402-01-30.
//

import Foundation

struct CovidData: Decodable {
    let regionData: [CovidStats]
}
struct CovidStats: Decodable, Identifiable {
    var id: String {
        country
    }
    let country: String
    let totalCases, newCases, totalDeaths, newDeaths: Int
    let totalRecovered, newRecovered, activeCases, seriousCritical: Int?
    let casesPerMil, deathsPerMil: Double
    let totalTests, testsPerMil, population: Int
}
