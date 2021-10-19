//
//  StoreManager.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/10/10.
//

import Foundation
import UIKit
import SwiftSoup
import Alamofire

protocol StoreManagerDelegate {
    func storeDataGetting(title : [String] ,price : [String])
}

struct StoreManager {
    
    var store : StoreManagerDelegate?
    
    func didGetData(url : String ) {
        var sendTitleArray = [String]()
        var sendPriceArray = [String]()
        AF.request(url).responseString { (respond) in
            guard let html = respond.value else {
                print("valueError")
                return }
            do {
                let document : Document = try SwiftSoup.parse(html)
                let elements : Elements = try document.select(".col-lg-8").select(".px-2")
                for element in elements {
                    let title = try element.select("strong").text()
                    let a = try element.select(".text-muted").text().components(separatedBy: ["(",")"])
                    let b = a.joined()
                    let c = b.replacingOccurrences(of: ",", with: "")
                    let d = c.split(separator: "원")
                    let e = d.joined()
                    if let price = Int(e) {
                        let priceString = String(price + price)
                        sendPriceArray.append(priceString)
                        sendTitleArray.append(title)
                    }else{
                    }
                }
                self.store?.storeDataGetting(title: sendTitleArray, price: sendPriceArray)
            }catch{
                print("catch")
            }
        }
    }
    
}
