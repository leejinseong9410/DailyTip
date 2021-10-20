//
//  MonthBestManger.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/10/08.
//

import Foundation
import FirebaseFirestore
import Firebase
protocol MonthManagerDelegate {
    func monthDataGet(dictionary:[Dictionary<String,Any>])
}
struct MonthBestManger {
    
    private let writeDate : DateFormatter = {
        let writeDate = DateFormatter()
        writeDate.dateFormat = "MM"
        return writeDate
    }()
    
    var delegate : MonthManagerDelegate?
    
    func loadFireData(name : String) {
        var dictionary = [Dictionary<String,Any>]()
        let date = Date()
        let dateString = self.writeDate.string(from: date)
        print(dateString)
        let db = Firestore.firestore()
        db.collection(name).document(dateString).getDocument { docSnap, err in
            if let _ = err {
                print("이달의 데이터 에러")
            }else{
                var keyString = ""
                var pathName = ""
                guard let monthData = docSnap!.data() else { return }
                for _ in 0..<monthData.count {
                    keyString = monthData.keys.joined(separator: " ")
                }
                let keyArray = keyString.split(separator: " ")
                for keyValue in keyArray {
                    if keyValue.contains("Car") == true {
                        pathName = "Car"
                    }else if keyValue.contains("Covid") == true {
                        pathName = "Covid"
                    }else if keyValue.contains("Food") == true {
                        pathName = "Food"
                    }else if keyValue.contains("Mens") == true {
                        pathName = "Mens"
                    }else if keyValue.contains("Woman") == true {
                        pathName = "Woman"
                    }else if keyValue.contains("Wear") == true {
                        pathName = "Wear"
                    }else if keyValue.contains("House") == true {
                        pathName = "House"
                    }else if keyValue.contains("SNS") == true {
                        pathName = "SNS"
                    }else if keyValue.contains("Hair") == true {
                        pathName = "Hair"
                    }else if keyValue.contains("Gym") == true {
                        pathName = "Gym"
                    }else if keyValue.contains("Dog") == true {
                        pathName = "Dog"
                    }else if keyValue.contains("Computer") == true {
                        pathName = "Computer"
                    }else{
                        print("포스트 페이지 이동 에러")
                    }
                    db.collection(pathName).document(String(keyValue)).getDocument { seSnap, err in
                        if let _ = err {
                            print("seSnap에러")
                        }else{
                            guard let snapData = seSnap else { return }
                            let title = snapData["Title"] as! String
                            let postWriter = snapData["UserID"] as! String
                            let postDate = snapData["Date"] as! String
                            let postImageID = snapData["ImageID"] as! String
                            let like = snapData["Like"] as! Int
                            let hate = snapData["Hate"] as! Int
                            let coment = snapData["ComentCount"] as! Int
                            let tag = snapData["Tag"] as! [String]
                            let newDictionary = ["title": title, "writer" : postWriter , "date" : postDate , "imageID" : postImageID,
                                                 "like" : like, "hate" : hate , "coment" : coment,"tag":tag] as [String : Any]
                            if dictionary.count >= 10 {
                               print("탑 텐 초과")
                                return print("에러")
                            }else{
                                dictionary.append(newDictionary)
                            }
                        }
                        let sortedArray = dictionary.sorted { $0["like"] as? Int ?? .zero > $1["like"] as? Int ?? .zero }
                        self.delegate?.monthDataGet(dictionary: sortedArray)
                    }
                }
            }
        }
    }

}
