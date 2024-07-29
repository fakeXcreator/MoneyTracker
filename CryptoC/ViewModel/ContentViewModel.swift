import Foundation
import Combine

extension ViewController {
    class ViewModel: ObservableObject {
        @Published var rates = [Rate]()
        @Published var searchText = ""
        @Published var amount: Double = 100 {
            didSet {
                updateCalculatedRates()
            }
        }
        
        var filteredRates: [Rate] {
            return searchText.isEmpty ? rates : rates.filter { $0.asset_id_quote.contains(searchText.uppercased()) }
        }
        
        private var allRates: [Rate] = []

        
        func refreshData() {
            // Set previewMode to false to use actual API requests
            CryptoAPI().getCryptoData(currency: "USD", previewMode: false) { newRates in
                DispatchQueue.main.async {
                    self.allRates = newRates
                    self.updateCalculatedRates()
                }
            }
        }

        private func updateCalculatedRates() {
            rates = allRates.map { rate in
                var updatedRate = rate
                updatedRate.rate = calcRate(rate: rate)
                return updatedRate
            }
        }
        
        func calcRate(rate: Rate) -> Double {
            return amount * rate.rate
        }
    }
}
