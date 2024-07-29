//
//  CryptoModel.swift
//  CryptoC
//
//  Created by Daniil Kim on 25.07.2024.
//

import Foundation

struct Crypto: Decodable {
    let asset_id_base: String
    let rates: [Rate]
}

struct Rate: Decodable, Identifiable {
    let id = UUID()
    let time: String
    let asset_id_quote: String
    var rate: Double
    
    
    //We need sample rates, because our API can work only in 100 request/day
    static var sampleRates: [Rate] {
        var tempRates = [Rate]()
        for _ in 1...20 {
            let randomNumber = Double(Array(0...1000).randomElement()!)
            let randomCurrency = ["TEST", "TEST1", "TEST2", "TEST3"].randomElement()!
            
            let sampleRate = Rate(time: "00210301021", asset_id_quote: randomCurrency, rate: randomNumber)
            tempRates.insert(sampleRate, at: 0)
        }
        return tempRates
    }
}


