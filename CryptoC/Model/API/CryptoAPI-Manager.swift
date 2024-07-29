//
//  CryptoAPI-Manager.swift
//  CryptoC
//
//  Created by Daniil Kim on 25.07.2024.
//

import Foundation

class CryptoAPI {
    let API_KEY = "CC9937C3-B477-439C-A9D7-160F808F614B"
    
    func getCryptoData(currency: String, previewMode: Bool, _ completion:@escaping ([Rate]) -> ()) {
        if previewMode {
            completion(Rate.sampleRates)
            return
        }
        
        let urlString = "https://rest.coinapi.io/v1/exchangerate/\(currency)?invert=false&apikey=\(API_KEY)"
        
        // Create URL
        guard let url = URL(string: urlString) else {
            print("CryptoAPI: Invalid URL")
            completion([])
            return
        }
        
        // Retrieve data
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("CryptoAPI: Error - \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let data = data else {
                print("CryptoAPI: No data received")
                completion([])
                return
            }
            
            // Print the raw JSON response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("CryptoAPI: JSON Response - \(jsonString)")
            }
            
            // Decode data
            do {
                let ratesData = try JSONDecoder().decode(Crypto.self, from: data)
                completion(ratesData.rates)
            } catch {
                print("CryptoAPI: Decoding error - \(error)")
                completion([])
            }
        }
        .resume()
    }
}

