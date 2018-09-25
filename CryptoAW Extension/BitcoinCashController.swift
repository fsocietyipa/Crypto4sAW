//
//  BitcoinCashController.swift
//  CryptoAW Extension
//
//  Created by fsociety.1 on 5/11/18.
//  Copyright © 2018 fsociety.1. All rights reserved.
//

import WatchKit
import Foundation
import Alamofire
import SwiftyJSON

class BitcoinCashController: WKInterfaceController {

    @IBOutlet var bitcoinCashPrice: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        getValue()
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func getValue() {
        let url = "https://api.coinmarketcap.com/v1/ticker/bitcoin-cash"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.bitcoinCashPrice.setText(json[0]["price_usd"].string! + " $")
            case .failure(let error):
                self.bitcoinCashPrice.setText("Error. Try Again.")
                print(error)
            }
        }
    }
    @IBAction func refresh() {
        self.bitcoinCashPrice.setText("loading...")
        getValue()
    }
    
}
