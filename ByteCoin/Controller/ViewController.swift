//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Juan Ignacio Abal on 3/13/21.
//  Copyright © 2021 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    var coinManager = CoinManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        coinManager.delegate = self
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.getAmountCurrency()
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component:Int) -> String?{
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.perform(for: selectedCurrency)
        return coinManager.currencyArray[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
}
//MARK: - WeatherManagerDelegate


extension ViewController: CoinManagerDelegate {
    
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = String(format: "%.1f", coin.rate)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
