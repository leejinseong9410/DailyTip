//
//  Top10PageController.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/10/04.
//

import UIKit
import Firebase
import FirebaseFirestore

class Top10PageController: UIViewController {
    private let boardLabel : UILabel = {
        let boardLabel = UILabel()
        boardLabel.textColor = .black
        boardLabel.textAlignment = .left
        boardLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        boardLabel.text = "Top10 게시판"
        boardLabel.frame = CGRect(x: 20, y: 250, width: 200, height: 40)
        return boardLabel
    }()
    private let userInfoButton : UIButton = {
       let userInfoButton = UIButton()
        if UserData.userID.isEmpty == true {
            userInfoButton.setTitle("로그인이 필요합니다.", for: .normal)
            userInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: 18,weight: .semibold)
            userInfoButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -50, bottom: 0, right: 0)
            userInfoButton.setTitleColor(.black, for: .normal)
            userInfoButton.frame = CGRect(x: 60, y: 200, width: 200, height: 30)
        }else{
            userInfoButton.setTitle(UserData.userID, for: .normal)
            userInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: 20 , weight: .bold)
            userInfoButton.setTitleColor(.black, for: .normal)
            userInfoButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
            userInfoButton.frame = CGRect(x: 60, y: 200, width: 100, height: 30)
        }
        userInfoButton.addTarget(self, action: #selector(userInfoPage), for: .touchUpInside)
        return userInfoButton
    }()
    private let userProfile : UIImageView = {
        let userProfile = UIImageView()
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child(UserData.userID)
        reference.downloadURL { (url,error ) in
            if let error = error {
                print(error)
            }else{
                do{
                     let data = try Data(contentsOf: url!)
                     let imageData = UIImage(data: data)
                    userProfile.image = imageData
                }catch {
                    print(error)
                    userProfile.isHidden = true
                }
                
            }
        }
        userProfile.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        userProfile.layer.cornerRadius = userProfile.frame.height / 2
        userProfile.contentMode = .scaleAspectFill
        userProfile.layer.masksToBounds = true
        userProfile.clipsToBounds = true
        return userProfile
    }()
    private let userProfileView : UIView = {
       let userProfileView = UIView()
        userProfileView.frame = CGRect(x: 20, y: 200, width: 30, height: 30)
        userProfileView.layer.cornerRadius = userProfileView.frame.height / 2
        userProfileView.layer.borderWidth = 1
        userProfileView.layer.borderColor = UIColor.lightGray.cgColor
        return userProfileView
    }()
    private let boardMainLogo : UIImageView = {
       let boardMainLogo = UIImageView()
        boardMainLogo.image = UIImage(named: "BestBoard")
        boardMainLogo.contentMode = .scaleToFill
        boardMainLogo.frame = CGRect(x: -5, y:100, width: 400, height: 90)
        return boardMainLogo
    }()
    private let boardTableView : UITableView = {
        let boardTableView = UITableView()
        boardTableView.layer.borderWidth = 1
        boardTableView.layer.borderColor = UIColor.lightGray.cgColor
        boardTableView.backgroundColor = .white
        boardTableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        return boardTableView
    }()
    private let backButtonBarItem : UIBarButtonItem = {
        let back = UIBarButtonItem()
        back.image = UIImage(named: "BackDtAppButton")?.withRenderingMode(.alwaysOriginal)
        back.action = #selector(showMainPage)
        return back
    }()
    private let tipWriteButton : UIButton = {
       let tipWriteButton = UIButton()
        tipWriteButton.setTitle("Tip", for: .normal)
        tipWriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tipWriteButton.setTitleColor(.black, for: .normal)
        tipWriteButton.frame = CGRect(x: 320, y: 200, width: 50, height: 30)
        tipWriteButton.layer.cornerRadius = 10
        tipWriteButton.layer.borderWidth = 1
        tipWriteButton.layer.borderColor = UIColor.black.cgColor
        tipWriteButton.addTarget(self, action: #selector(tipWrite), for: .touchUpInside)
        return tipWriteButton
    }()
    
    var dictionary = [Dictionary<String,Any>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        backButtonBarItem.target = self
        navigationItem.leftBarButtonItem = backButtonBarItem
        boardTableView.delegate = self
        boardTableView.dataSource = self
        configure()
       
    }
    private func configure(){
        loadFireBaseData()
        view.addSubview(boardMainLogo)
        view.addSubview(userInfoButton)
        view.addSubview(boardLabel)
        view.addSubview(userProfileView)
        view.addSubview(boardTableView)
        view.addSubview(tipWriteButton)
        userProfileView.addSubview(userProfile)
        boardTableView.frame = CGRect(x: 0, y: 300, width: view.frame.width, height: view.frame.height)
    }
    
    @objc private func userInfoPage(){
        if userInfoButton.titleLabel?.text == "로그인이 필요합니다." {
            let logVC = LogInPageController()
            logVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(logVC, animated: true)
            view.removeFromSuperview()
        }else{
            let myVC = MyPageController()
            myVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(myVC, animated: true)
            view.removeFromSuperview()
        }
    }
    private func loadFireBaseData(){
        let db = Firestore.firestore()
        db.collection("Top").getDocuments { topSnap, err in
            if let _ = err {
                print("탑텐 데이터 가져오기 에러")
            }else{
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
                                         "like" : like, "hate" : hate , "coment" : coment ,"tag" : tag ] as [String : Any]
                    if self.dictionary.count >= 10 {
                       print("탑 텐 초과")
                        return print("에러")
                    }else{
                        self.dictionary.append(newDictionary)
                    }
                }
                self.boardTableView.reloadData()
            }
        }
    }
    
    @objc func tipWrite(_ sender : UIButton){
        if userInfoButton.titleLabel?.text == "로그인이 필요합니다." {
            let alert = UIAlertController(title: "로그인 하시겠습니까?", message: "글 작성시 로그인이 필요합니다.", preferredStyle: .alert)
            let alertAct = UIAlertAction(title: "Ok", style: .destructive) { act in
                let logVC = LogInPageController()
                logVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(logVC, animated: true)
                self.view.removeFromSuperview()
            }
            let alertCancel = UIAlertAction(title: "Cancel", style: .cancel) { act in
                
            }
            alert.addAction(alertAct)
            alert.addAction(alertCancel)
            present(alert, animated: true, completion: nil)
        }else{
            // tip 작성 페이지
            let writeVC = WritePageController()
            writeVC.modalPresentationStyle = .fullScreen
            writeVC.category = "말머리"
            self.navigationController?.pushViewController(writeVC, animated: true)
            view.removeFromSuperview()
            }
        }
    @objc func showMainPage(){
        let main = MainPageController()
        main.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(main, animated: true)
        print("remove Board")
        view.removeFromSuperview()
    }
}

extension Top10PageController : UITableViewDelegate {
    
}
extension Top10PageController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sortedArray = self.dictionary.sorted { $0["like"] as? Int ?? .zero > $1["like"] as? Int ?? .zero }
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
        let coment = sortedArray[indexPath.row]["coment"] as! Int
        print(sortedArray)
        cell.postNumber.text = String(indexPath.row + 1)
        cell.postTitle.text = "\(sortedArray[indexPath.row]["title"] as! String)(\(coment))"
        cell.postDate.text = sortedArray[indexPath.row]["date"] as? String
        cell.postWriter.text = sortedArray[indexPath.row]["writer"] as? String
        cell.postRecomend.text = "추천 :\(String(describing: sortedArray[indexPath.row]["like"] as! Int))"
        cell.postNotRecomend.text = "비추천 :\(String(describing: sortedArray[indexPath.row]["hate"] as! Int))"
       
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child(sortedArray[indexPath.row]["imageID"] as! String)
        reference.downloadURL { (url,error) in
            if let _ = error {
                print("테이블뷰 이미지 가져오기 에러")
                cell.postImage.backgroundColor = .white
                cell.postImage.layer.borderColor = UIColor.darkGray.cgColor
                cell.postImage.layer.borderWidth = 1
            }else{
                do{
                    let data = try Data(contentsOf: url!)
                    let imageData = UIImage(data: data)
                    cell.postImage.image = imageData
                }catch{
                    cell.postImage.backgroundColor = .white
                    cell.postImage.layer.borderColor = UIColor.darkGray.cgColor
                    cell.postImage.layer.borderWidth = 1
                }
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sortedArray = self.dictionary.sorted { $0["like"] as? Int ?? .zero > $1["like"] as? Int ?? .zero }
        let postTitle = sortedArray[indexPath.row]["imageID"] as! String
        let postPage = PostPageController()
        postPage.userSelectPost = postTitle
        if postTitle.contains("Car") == true {
            postPage.userCategory = "Car"
        }else if postTitle.contains("Covid") == true {
            postPage.userCategory = "Covid"
        }else if postTitle.contains("Food") == true {
            postPage.userCategory = "Food"
        }else if postTitle.contains("Mens") == true {
            postPage.userCategory = "Mens"
        }else if postTitle.contains("Womans") == true {
            postPage.userCategory = "Womans"
        }else if postTitle.contains("Wear") == true {
            postPage.userCategory = "Wear"
        }else if postTitle.contains("House") == true {
            postPage.userCategory = "House"
        }else if postTitle.contains("SNS") == true {
            postPage.userCategory = "SNS"
        }else if postTitle.contains("Hair") == true {
            postPage.userCategory = "Hair"
        }else if postTitle.contains("Gym") == true {
            postPage.userCategory = "Gym"
        }else if postTitle.contains("Dog") == true {
            postPage.userCategory = "Dog"
        }else if postTitle.contains("Computer") == true {
            postPage.userCategory = "Computer"
        }else{
            print("포스트 페이지 이동 에러")
        }
        postPage.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(postPage, animated: true)
    }
    
}
