//
//  ViewController.swift
//  AppFor4S
//
//  Created by fsociety.1 on 5/10/18.
//  Copyright © 2018 fsociety.1. All rights reserved.
//


import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, Loadable {

    @IBOutlet weak var bitcoinPrice: UILabel!
    @IBOutlet weak var etheriumPrice: UILabel!
    @IBOutlet weak var bitcoinCashPrice: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getValue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getValue() {
        self.showLoader()
        let url = "https://api.coinmarketcap.com/v1/ticker"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.hideLoaderSuccess()
                self.bitcoinPrice.text = json[0]["price_usd"].string! + " $"
                self.etheriumPrice.text = json[1]["price_usd"].string! + " $"
                self.bitcoinCashPrice.text = json[3]["price_usd"].string! + " $"
            case .failure(let error):
                self.hideLoaderFailure()
                print(error)
            }
        }
    }

    @IBAction func refresh(_ sender: Any) {
        getValue()
    }
    

}

