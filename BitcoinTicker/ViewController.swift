

import UIKit
import Alamofire
import SwiftyJSON


// delegate and datasource protocols
// deleagte = ViewController
// protocols are: UIPickerViewDataSource and UIPickerViewDelegate
// ViewController is going to conform to the two protocols added.
class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    // API
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/"
    // Fiat Tickers
    let currencyArray = ["USD", "AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","ZAR"]
    // Fiat Symbols
    let currencySymbolArray = ["$", "$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "R"]
    // Crypto Tickers
    let cryptoCurrencyArray = ["BTC", "ETH", "XRP", "BCH", "LTC"]

    var finalURL = ""
    var currencyRowIndex = 0
    var cryptoCurrencyRowIndex = 0
    var currencyTicker = "USD"
    var cryptoCurrencyTicker = "BTC"

    //IBOutlets
//    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    
    @IBOutlet weak var cryptoRateLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var cryptoDisplayLogo: UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // current view controller deleate = self
        currencyPicker.delegate = self
        // currencyPicker's datasource = self
        currencyPicker.dataSource = self
        
        getCryptoPriceData(url: baseURL + "BTCUSD")
       
    }

    
    // Determine how many columns in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // Determine how many rows each component/column should have
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if component == 0 {
            return currencyArray.count
        }
        else {
            return cryptoCurrencyArray.count
        }
        
    }
    
    // Fill picker row titles with the strings from currencyArray
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return currencyArray[row]
        }
        else {
            return cryptoCurrencyArray[row]
        }
        
    }
    
    // Actions when user selectes a row in the picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            currencyRowIndex = row
            currencyTicker = currencyArray[row]
        }
        else {
            cryptoCurrencyRowIndex = row
            cryptoCurrencyTicker = cryptoCurrencyArray[row]
            cryptoDisplayLogo.image = UIImage(named: cryptoCurrencyArray[row])
        }
        
        finalURL = baseURL + cryptoCurrencyTicker + currencyTicker
        
        getCryptoPriceData(url: finalURL)
    }
    
    

    
    
//    //MARK: - Networking
//    /***************************************************************/
    
    func getCryptoPriceData(url: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                
            if response.result.isSuccess {
                
                let CryptoPriceJSON : JSON = JSON(response.result.value!)

                self.updateCryptoData(json: CryptoPriceJSON)

            }
            else {
                
                self.cryptoRateLabel.text = "Connection Issues"
            }
                
        }
        
    }
    
    
    
    

//    //MARK: - JSON Parsing
//    /***************************************************************/
//    
    func updateCryptoData(json: JSON) {

        if let cryptoPriceResult = json["ask"].double {
            
            cryptoRateLabel.text = "\(currencySymbolArray[currencyRowIndex])\(cryptoPriceResult)"

        }
        else {
            cryptoRateLabel.text = "Price Unavailable"
        }

    }

}

