//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Juan Ignacio Abal on 3/13/21.
//  Copyright © 2021 The App Brewery. All rights reserved.
//


import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC/"
    let apiKey = "2A1DFE50-21EA-4D84-94E1-9B5436208F34"
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getAmountCurrency() -> Int{
        return currencyArray.count
    }
    func fetchCurrency(_ currency: String){

            let urlString = "\(baseURL)\(currency)?apikey=\(apiKey)"
            performRequest(with: urlString)
        }
    
    func perform(for currency: String){
        fetchCurrency(currency)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCoin(self, coin: coin)
                    }
                }
            }
            task.resume()
        }
    }
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let rate = decodedData.rate
            let coin = CoinModel(rate: rate)
            return coin
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

