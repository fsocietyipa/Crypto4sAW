//
//  AllCyptoList.swift
//  AppFor4S
//
//  Created by fsociety.1 on 6/13/18.
//  Copyright © 2018 fsociety.1. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import LocalAuthentication

struct crypto: Decodable {
    let id: String
    let name: String
    let symbol: String
    let rank: String
    let price_usd: String
    let price_btc: String
    let hVolumeUsd: String
    let market_cap_usd: String
    let available_supply: String
    let total_supply: String
    let max_supply: String?
    let percent_change_1h: String
    let percent_change_24h: String
    let percent_change_7d: String
    let last_updated: String

    enum CodingKeys: String, CodingKey {
        case hVolumeUsd = "24h_volume_usd"
        case id, name, symbol, rank, price_usd, price_btc, market_cap_usd, available_supply, total_supply, max_supply, percent_change_1h, percent_change_24h, percent_change_7d, last_updated
    }

}


class AllCyptoList: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        authWithTouchID()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.selectionStyle = .none
        cell?.textLabel?.font = UIFont.init(name: "Bebas", size: 30)
        cell?.detailTextLabel?.font = UIFont.init(name: "Bebas", size: 25)
        cell?.textLabel?.text = saveData[indexPath.row].name
        cell?.detailTextLabel?.text = saveData[indexPath.row].price_usd + " $"
        return cell!
    }
    
    var saveData = [crypto]()

    func getData(){
        let url = "https://api.coinmarketcap.com/v1/ticker"
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            switch response.result {
            case .success(_):
                let decoder = JSONDecoder()
                do {
                    guard let result = response.data else { return }
                    let res = try decoder.decode([crypto].self, from: result)
                    self.saveData = res
                    self.tableView.reloadData()
                } catch {
                    print("error trying to convert data to JSON")
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func authWithTouchID() {
        // 1
        let context = LAContext()
        var error: NSError?
        
        // 2
        // check if Touch ID is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // 3
            let reason = "Authenticate with Touch ID to see price of crypto-currency"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                {(succes, error) in
                    // 4
                    if succes {
                        //self.showAlertController("Touch ID Authentication Succeeded")
                        self.getData()
                    }
                    else {
                        //self.showAlertController("Touch ID Authentication Failed")
                        exit(0)
                    }
            } )
        }
            // 5
        else {
            showAlertController("Touch ID not available")
        }
    }
    
    func showAlertController(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
