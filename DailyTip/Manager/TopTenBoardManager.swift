//
//  TopTenBoardManager.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/10/07.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

protocol TopManagerDelegate {
    func getTopData(dictionary:[Dictionary<String,Any>])
}
struct TopTenBoardManager {
    
    private let writeDate : DateFormatter = {
        let writeDate = DateFormatter()
        writeDate.dateFormat = "YYYY-MM-dd/HH:mm:ss"
        return writeDate
    }()
    
    var delegate : TopManagerDelegate?
    
    func loadFireBaseData(boardName : String){
        var dictionary = [Dictionary<String,Any>]()
        let db = Firestore.firestore()
        db.collection(boardName).getDocuments { topSnap, err in
            if let _ = err {
                print("탑텐 데이터 가져오기 에러")
            }else{
                let date = Date()
                let dateString = self.writeDate.string(from: date)
                for data in topSnap!.documents {
                    let title = data["Title"] as! String
                    let postWriter = data["UserID"] as! String
                    let postDate = data["Date"] as! String
                    let postImageID = data["ImageID"] as! String
                    let like = data["Like"] as! Int
                    let hate = data["Hate"] as! Int
                    let coment = data["ComentCount"] as! Int
                    let tag = data["Tag"] as! [String]
                    let newDictionary = ["title": title, "writer" : postWriter , "date" : postDate , "imageID" : postImageID,
                                         "like" : like, "hate" : hate , "coment" : coment,"tag":tag] as [String : Any]
                    if dictionary.count >= 10 {
                       print("탑 텐 초과")
                        return print("에러")
                    }else{
                        dictionary.append(newDictionary)
                        let postMonth = postDate.split(separator: "/")
                        let month = dateString.split(separator: "/")
                        let postMonthSp = postMonth[0].split(separator: "-")
                        let monthSp = month[0].split(separator: "-")
                        var pathName = ""
                        if monthSp[1] == postMonthSp[1] {
                            if postImageID.contains("Car") == true {
                                pathName = "Car"
                            }else if postImageID.contains("Covid") == true {
                                pathName = "Covid"
                            }else if postImageID.contains("Food") == true {
                                pathName = "Food"
                            }else if postImageID.contains("Mens") == true {
                                pathName = "Mens"
                            }else if postImageID.contains("Woman") == true {
                                pathName = "Woman"
                            }else if postImageID.contains("Wear") == true {
                                pathName = "Wear"
                            }else if postImageID.contains("House") == true {
                                pathName = "House"
                            }else if postImageID.contains("SNS") == true {
                                pathName = "SNS"
                            }else if postImageID.contains("Hair") == true {
                                pathName = "Hair"
                            }else if postImageID.contains("Gym") == true {
                                pathName = "Gym"
                            }else if postImageID.contains("Dog") == true {
                                pathName = "Dog"
                            }else if postImageID.contains("Computer") == true {
                                pathName = "Computer"
                            }else{
                                print("포스트 페이지 이동 에러")
                            }
                            db.collection("MonthBest").document(String(month[1])).setData([postImageID:[pathName:like]],merge: true,completion: nil)
                        }else{
                                print("지난 post\(postImageID)")
                            }
                        }
                    }
                }
                    let sortedArray = dictionary.sorted { $0["like"] as? Int ?? .zero > $1["like"] as? Int ?? .zero }
                    self.delegate?.getTopData(dictionary: sortedArray)
            }
        }
    }
