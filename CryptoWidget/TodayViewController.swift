//
//  TodayViewController.swift
//  CryptoWidget
//
//  Created by fsociety.1 on 5/11/18.
//  Copyright © 2018 fsociety.1. All rights reserved.
//

import UIKit
import Foundation
import NotificationCenter
import Alamofire
import SwiftyJSON

class TodayViewController: UIViewController, NCWidgetProviding {
    
    
    @IBOutlet var mainView: UIView!
    
    @IBOutlet weak var bitcoinPrice: UILabel!
    @IBOutlet weak var etheriumPrice: UILabel!
    @IBOutlet weak var bitcoinCashPrice: UILabel!
    
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        self.preferredContentSize = (activeDisplayMode == .expanded) ? CGSize(width: 500, height: 176) : CGSize(width: maxSize.width, height: 110)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        
        widgetActiveDisplayModeDidChange(.compact, withMaximumSize: CGSize(width: 500, height: 176))
        getValue()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getValue() {
        self.bitcoinPrice.text = "loading..."
        self.etheriumPrice.text = "loading..."
        self.bitcoinCashPrice.text = "loading..."

        let url = "https://api.coinmarketcap.com/v1/ticker"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                self.bitcoinPrice.text = json[0]["price_usd"].string! + " $"
                self.etheriumPrice.text = json[1]["price_usd"].string! + " $"
                self.bitcoinCashPrice.text = json[3]["price_usd"].string! + " $"
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        getValue()
        completionHandler(NCUpdateResult.newData)
    }
    
    
}

