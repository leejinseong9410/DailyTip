//
//  WearManager.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/09/06.
//

import Foundation
import UIKit
import SwiftSoup

protocol WearManagerDelegate {
    func didDailyWearImage(images : [UIImage],title : [String])
}
struct WearManager {
    
    var delegate : WearManagerDelegate?
    
    
    func dailyWearCraw(url:String){
        _ = UIImage()
        guard let wearCrawURL = URL(string: url) else {
            print("wearCrawUrl - Error")
            return
        }
        do {
            let html = try String(contentsOf: wearCrawURL, encoding: .utf8)
            let document : Document = try SwiftSoup.parse(html)
            let imageData : Elements = try document.select(".boxed-article-list").select(".listItem").select(".articleImg").select("img")
            var imageDataURLStringArray = [String]()
            for data in imageData {
                let dataString =  data.description
                let splitFirst = dataString.split(separator: "=")
                let lastSplit = splitFirst[1].split(separator: " ")
                let imageDataURLString = String(lastSplit[0])
                imageDataURLStringArray.append(imageDataURLString)
            }
            var wearImageDataArray = [UIImage]()
            for imageData in imageDataURLStringArray {
                if let encodeUrl = imageData.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
                   var encodeSplit = encodeUrl
                    encodeSplit.removeFirst(3)
                    encodeSplit.removeLast(3)
                    guard let imageDataURL = URL(string: encodeSplit) else { return }
                let wearImageData = try Data(contentsOf: imageDataURL)
                guard let wearImage = UIImage(data: wearImageData) else { return }
                wearImageDataArray.append(wearImage)
            }
                var titleArray = [String]()
                var webViewArray = [String]()
                let wearInfo : Elements = try document.select(".boxed-article-list").select(".listItem").select(".articleInfo").select(".title").select("a")
                for wearData in wearInfo {
                    let wearTittle = try wearData.text()
                    titleArray.append(wearTittle)
                    let wearDetail = wearData.description
                    let wearDetailSplit = wearDetail.split(separator: ";")
                    let wearDetailSplitDouble = wearDetailSplit[2].split(separator: "=")
                    let uid = wearDetailSplitDouble[1].components(separatedBy: ["\"","#"])
                    let lookBookURLString = "https://magazine.musinsa.com/index.php?m=lookbook&showFlag=1&uid=\(uid[0])"
                    webViewArray.append(lookBookURLString)
                }
                   UserSelect.userSelectURL = webViewArray[0]
                   self.delegate?.didDailyWearImage(images: wearImageDataArray, title: titleArray)
         }
        }catch{
            print("error")
        }
        
    }
}

