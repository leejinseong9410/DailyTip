//
//  CarBoardPageController.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/09/09.
//

import UIKit
import FirebaseStorage
import FirebaseStorageUI
import Firebase


class BoardPageController: UIViewController {
    
    
    private let postCountLabel : UILabel = {
       let postCountLabel = UILabel()
        postCountLabel.textAlignment = .center
        postCountLabel.textColor = .black
        postCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        postCountLabel.frame = CGRect(x: 20, y: 280, width: 100, height: 20)
       return postCountLabel
    }()
    private let boardTableView : UITableView = {
        let boardTableView = UITableView()
        boardTableView.layer.borderWidth = 1
        boardTableView.layer.borderColor = UIColor.lightGray.cgColor
        boardTableView.backgroundColor = .white
        boardTableView.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        return boardTableView
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
    private let boardLabel : UILabel = {
        let boardLabel = UILabel()
        boardLabel.textColor = .black
        boardLabel.textAlignment = .left
        boardLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
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
    private let backButtonBarItem : UIBarButtonItem = {
        let back = UIBarButtonItem()
        back.image = UIImage(named: "BackDtAppButton")?.withRenderingMode(.alwaysOriginal)
        back.action = #selector(showMainPage)
        return back
    }()
    private let boardMainLogo : UIImageView = {
       let boardMainLogo = UIImageView()
        boardMainLogo.contentMode = .scaleToFill
        boardMainLogo.frame = CGRect(x: 0, y:100, width: 414, height: 90)
        return boardMainLogo
    }()
    var titleArray = [String]()
    var postManArray = [String]()
    var postDateArray = [String]()
    var postImageIDarray = [String]()
    var likeArray = [Int]()
    var hateArray = [Int]()
    var comentArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonBarItem.target = self
        navigationItem.leftBarButtonItem = backButtonBarItem
        view.backgroundColor = .white
        boardTableView.delegate = self
        boardTableView.dataSource = self
        configure()
    }
    private func loadFireBaseData(){
        let db = Firestore.firestore()
        db.collection(self.navigationItem.title!).getDocuments { snapShot, error in
            if let _ = error {
                print("파이어 베이스 정보가져오기 에러")
            }else{
                for data in snapShot!.documents {
                    self.titleArray.append(data["Title"] as! String)
                    self.postManArray.append(data["UserID"] as! String)
                    self.postDateArray.append(data["Date"] as! String)
                    self.postImageIDarray.append(data["ImageID"] as! String)
                    self.likeArray.append(data["Like"] as! Int)
                    self.hateArray.append(data["Hate"] as! Int)
                    self.comentArray.append(data["ComentCount"] as! Int)
                }
                    self.boardTableView.reloadData()
            }
        }
    }
    @objc func userInfoPage(){
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
            writeVC.category = self.navigationItem.title!
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
    private func configure(){
            loadFireBaseData()
            switch self.navigationItem.title {
            case "Car" :
                boardMainLogo.image = UIImage(named: "CarPageMain")
                boardLabel.text = "자동차 게시판"
                break
            case "Covid" :
                boardMainLogo.image = UIImage(named: "그룹 98")
                boardLabel.text = "우한폐렴 게시판"
                break
            case "Food" :
                boardMainLogo.image = UIImage(named: "그룹 96")
                boardLabel.text = "음식 게시판"
                break
            case "Mens" :
                boardMainLogo.image = UIImage(named: "그룹 97")
                boardLabel.text = "남성 게시판"
                break
            case "Womans" :
                boardMainLogo.image = UIImage(named: "그룹 99")
                boardLabel.text = "여성 게시판"
                break
            case "Wear" :
                boardMainLogo.image = UIImage(named: "그룹 100")
                boardLabel.text = "의류 게시판"
                break
            case "House" :
                boardMainLogo.image = UIImage(named: "그룹 101")
                boardLabel.text = "인테리어/생활게시판"
                break
            case "SNS" :
                boardMainLogo.image = UIImage(named: "그룹 102")
                boardLabel.text = "SNS 게시판"
                break
            case "Hair" :
                boardMainLogo.image = UIImage(named: "그룹 103")
                boardLabel.text = "헤어스타일 게시판"
                break
            case "Gym" :
                boardMainLogo.image = UIImage(named: "그룹 104")
                boardLabel.text = "운동 게시판"
                break
            case "Dog" :
                boardMainLogo.image = UIImage(named: "그룹 105")
                boardLabel.text = "반려동물 게시판"
                break
            case "Computer" :
                boardMainLogo.image = UIImage(named: "그룹 106")
                boardLabel.text = "전자기기 게시판"
                break
            default:
                print("switch Error")
        }
        view.addSubview(boardLabel)
        view.addSubview(postCountLabel)
        view.addSubview(boardMainLogo)
        view.addSubview(tipWriteButton)
        view.addSubview(userProfileView)
        userProfileView.addSubview(userProfile)
        view.addSubview(userInfoButton)
        view.addSubview(boardTableView)
        boardTableView.frame = CGRect(x: 0, y: 300, width: view.frame.width, height: view.frame.height)
    }
}
extension BoardPageController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

               return titleArray.count
           
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
        cell.postNumber.text = String(titleArray.count - indexPath.row)
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child(postImageIDarray.reversed()[indexPath.row])
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
        cell.postTitle.text = "\(titleArray.reversed()[indexPath.row])\("(\(comentArray.reversed()[indexPath.row]))")"
        cell.postWriter.text = postManArray.reversed()[indexPath.row]
        cell.postDate.text = postDateArray.reversed()[indexPath.row]
        cell.postRecomend.text = "추천\(likeArray.reversed()[indexPath.row])"
        cell.postNotRecomend.text = "비추천\(hateArray.reversed()[indexPath.row])"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let postTitle = postImageIDarray.reversed()[indexPath.row]
        
        let postPage = PostPageController()
        
        postPage.userSelectPost = postTitle
        postPage.userCategory = title!
        postPage.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(postPage, animated: true)
    }
    
}
