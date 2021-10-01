//
//  ViewController.swift
//  NetworkingCallsRESTAPI
//
//  Created by Ashish Ashish on 9/30/21.
//

import UIKit
import SwiftyJSON
import SwiftSpinner
import Alamofire
import PromiseKit

class ViewController: UIViewController {
    
    let baseURL = "https://financialmodelingprep.com/api/v3/quote-short/"
    let apiKey = "65a61eae62f70d8bbaa99f9c0729ab08"

    @IBOutlet weak var txtStock: UITextField!
    
    @IBOutlet weak var lblStock: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getStockValue(_ sender: Any) {
        
        if txtStock.text == "" {
            return;
        }
        
        getStockPrice(txtStock.text!)
        .done{ price, symbol, volume in
            self.lblStock.text = "Stock \(symbol) price = \(price)"
        }
        .catch { error in
            print(error)
        }
        
        
    }
    
    func getStockPrice(_ symbol : String) -> Promise< (Float, String, Int)> {
     
        return Promise< (Float, String, Int) > { seal -> Void in
           
            let url = baseURL + symbol + "?apikey=" + apiKey
            
            AF.request(url).responseJSON { response in
        
                if response.error != nil {
                    seal.reject(response.error as! Error)
                }
                
                let stocks = JSON( response.data!).array
                let firstStock = stocks![0]
                let price = firstStock["price"].floatValue
                let symbol = firstStock["symbol"].stringValue
                let volume = firstStock["volume"].intValue
                seal.fulfill( (price, symbol, volume ))
            }
        }// End of return promise
    
    }
}

