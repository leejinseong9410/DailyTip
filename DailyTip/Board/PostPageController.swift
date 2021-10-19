//
//  PostPageController.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/09/26.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class PostPageController: UIViewController {

    var userSelectPost = ""
    var userCategory = ""
    
    var likeCount = 0
    var hateCount = 0
    var comentCount = 0
    
    private let writeDate : DateFormatter = {
        let writeDate = DateFormatter()
        writeDate.dateFormat = "YYYY-MM-dd/HH:mm:ss"
        return writeDate
    }()
    private let likeButton : UIButton  = {
       let like = UIButton()
        like.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        like.setTitleColor(.white, for: .normal)
        like.addTarget(self, action: #selector(likeAct), for: .touchUpInside)
        like.layer.borderColor = UIColor.blue.cgColor
        like.layer.borderWidth = 1
        like.backgroundColor = .blue
        like.layer.cornerRadius = 10
        return like
    }()
    private let hateButton : UIButton = {
       let hate = UIButton()
        hate.setTitleColor(.white, for: .normal)
        hate.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        hate.addTarget(self, action: #selector(hateAct), for: .touchUpInside)
        hate.layer.borderColor = UIColor.red.cgColor
        hate.layer.borderWidth = 1
        hate.backgroundColor = .red
        hate.layer.cornerRadius = 10
        return hate
    }()
    private let comentsButton : UIButton = {
       let comentsButton = UIButton()
        comentsButton.setTitle("댓글달기", for: .normal)
        comentsButton.setTitleColor(.black, for: .normal)
        comentsButton.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        comentsButton.layer.borderWidth = 1
        comentsButton.layer.borderColor = UIColor.black.cgColor
        comentsButton.addTarget(self, action: #selector(comentsAct), for: .touchUpInside)
        return comentsButton
    }()
    
    private let comentsTableView : UITableView = {
       let comentsTB = UITableView()
        comentsTB.backgroundColor = .white
        comentsTB.register(PostPageTableViewCell.self, forCellReuseIdentifier: PostPageTableViewCell.identifier)
        comentsTB.estimatedRowHeight = 80
        comentsTB.rowHeight = UITableView.automaticDimension
        return comentsTB
    }()
    private let comentsTextField : UITextField = {
       let comentsTxT = UITextField()
        comentsTxT.placeholder = "\t댓글을 남겨주세요."
        comentsTxT.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        comentsTxT.textColor = .black
        comentsTxT.textAlignment = .left
        comentsTxT.layer.borderWidth = 1
        comentsTxT.layer.borderColor = UIColor.lightGray.cgColor
        return comentsTxT
    }()
    private let userButton : UIButton = {
        let userButton = UIButton()
        if UserData.userID.isEmpty == true {
            userButton.isHidden = true
        }else{
            userButton.isHidden = false
            userButton.setTitle(UserData.userID, for: .normal)
            userButton.addTarget(self, action: #selector(userPage), for: .touchUpInside)
            userButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            userButton.setTitleColor(.black, for: .normal)
            userButton.frame = CGRect(x: 40, y: 30, width: 80, height: 20)
        }
            return userButton
    }()
    private let dateLabel : UILabel = {
       let dateLabel = UILabel()
        dateLabel.textAlignment = .center
        dateLabel.textColor = .lightGray
        dateLabel.font = UIFont.systemFont(ofSize: 10, weight: .light)
        dateLabel.frame = CGRect(x: 200, y: 230, width: 180, height: 12)
        return dateLabel
    }()
    private let writerLabel : UILabel = {
       let writerLabel = UILabel()
        writerLabel.textAlignment = .center
        writerLabel.textColor = .darkGray
        writerLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        writerLabel.frame = CGRect(x: 260, y: 210, width: 110, height: 12)
        return writerLabel
    }()
    private let tipWriteButton : UIButton = {
       let tipWriteButton = UIButton()
        tipWriteButton.setTitle("Tip", for: .normal)
        tipWriteButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        tipWriteButton.setTitleColor(.black, for: .normal)
        tipWriteButton.frame = CGRect(x: 320, y: 30, width: 50, height: 30)
        tipWriteButton.layer.cornerRadius = 10
        tipWriteButton.layer.borderWidth = 1
        tipWriteButton.layer.borderColor = UIColor.black.cgColor
        tipWriteButton.addTarget(self, action: #selector(tipWrite), for: .touchUpInside)
        return tipWriteButton
    }()
    private let contentLabel : UILabel = {
        let contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.textColor = .black
        contentLabel.textAlignment = .center
        contentLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        return contentLabel
    }()
    private let deleteButton : UIButton = {
       let delete = UIButton()
        delete.setTitle("삭제", for: .normal)
        delete.setTitleColor(.white, for: .normal)
        delete.backgroundColor = .black
        delete.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
        delete.layer.cornerRadius = 8
        delete.frame = CGRect(x: 20, y: 210, width: 40, height: 30)
        delete.addTarget(self, action: #selector(deletePost), for: .touchUpInside)
        return delete
    }()
    private let updateButton : UIButton = {
       let update = UIButton()
        update.setTitle("수정", for: .normal)
        update.setTitleColor(.black, for: .normal)
        update.backgroundColor = .white
        update.layer.borderColor = UIColor.black.cgColor
        update.layer.borderWidth = 1
        update.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .light)
        update.layer.cornerRadius = 8
        update.frame = CGRect(x: 70, y: 210, width: 40, height: 30)
        update.addTarget(self, action: #selector(updatePost), for: .touchUpInside)
        return update
    }()
    private let userImage : UIImageView = {
       let userImage = UIImageView()
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child(UserData.userID)
        reference.downloadURL { (url,error) in
            if let error = error {
                print(error)
            }else{
                do{
                    let data = try Data(contentsOf: url!)
                    let imageData = UIImage(data: data)
                    userImage.image = imageData
                }catch{
                    print(error)
                }
            }
        }
        userImage.contentMode = .scaleAspectFill
        userImage.backgroundColor = .white
        userImage.layer.masksToBounds = false
        userImage.clipsToBounds = true
        userImage.frame = CGRect(x: 20, y: 30, width: 20, height: 20)
        userImage.layer.cornerRadius = userImage.frame.height / 2
        return userImage
    }()
    private let mainScrollView : UIScrollView = {
       let  mainScrollView = UIScrollView()
        mainScrollView.backgroundColor = .white
        mainScrollView.isScrollEnabled = true
        return mainScrollView
    }()
    private let mainSmallButton : UIButton = {
        let mainSmallButton = UIButton(type: .custom)
        mainSmallButton.setImage(UIImage(named: "DtSmallImage"), for: .normal)
        mainSmallButton.sizeToFit()
        mainSmallButton.clipsToBounds = true
        mainSmallButton.addTarget(self, action: #selector(backHandel), for: .touchUpInside)
        return mainSmallButton
    }()
    private let boardTitle : UILabel = {
       let boardTitle = UILabel()
        boardTitle.textAlignment = .left
        boardTitle.backgroundColor = .black
        boardTitle.textColor = .white
        boardTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return boardTitle
    }()
    private let postTitle : UILabel = {
       let postTitle = UILabel()
        postTitle.textAlignment = .center
        postTitle.textColor = .black
        postTitle.numberOfLines = 0
        postTitle.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        postTitle.layer.borderColor = UIColor.lightGray.cgColor
        postTitle.layer.borderWidth = 1
        return postTitle
    }()
    private let contentImage : UIImageView = {
       let contentImage = UIImageView()
        contentImage.contentMode = .scaleToFill
        return contentImage
    }()
    private let contentView : UIView = {
        let contentView = UIView()
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.darkGray.cgColor
        return contentView
    }()
    
    var comentStringArray = [String]()
    var idStringArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        comentsTableView.delegate = self
        comentsTableView.dataSource = self
        view.backgroundColor = .white
        navigationItem.titleView = mainSmallButton
        configure()
    }
    override func viewWillAppear(_ animated: Bool) {
        getDataFire()
        loadFirebaseData()
    }
    private func configure(){
        loadFirebaseData()
        getDataFire()
        mainScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        mainScrollView.contentSize = CGSize(width: view.frame.width, height: 1300)
        view.addSubview(mainScrollView)
        postTitle.frame = CGRect(x: 20, y: 140, width: mainScrollView.frame.width - 40, height: 60)
        mainScrollView.addSubview(postTitle)
        boardTitle.frame = CGRect(x: 20, y: 80, width: postTitle.frame.width, height: 35)
        mainScrollView.addSubview(boardTitle)
        mainScrollView.addSubview(userImage)
        mainScrollView.addSubview(tipWriteButton)
        mainScrollView.addSubview(userButton)
        mainScrollView.addSubview(dateLabel)
        mainScrollView.addSubview(writerLabel)
        if contentImage.image == nil {
            contentView.frame = CGRect(x: 20, y: 260, width: mainScrollView.frame.width - 40, height: 500)
            mainScrollView.addSubview(contentView)
        }else{
            contentView.frame = CGRect(x: 20, y: 260, width: mainScrollView.frame.width - 40, height: 800)
            mainScrollView.addSubview(contentView)
        }
        contentImage.frame = CGRect(x:(contentView.frame.width / 2) - 90, y: 10, width: 180, height: 180)
        contentView.addSubview(contentImage)
        contentLabel.frame = CGRect(x: 0, y: 180, width: contentView.frame.width, height: 300)
        contentView.addSubview(contentLabel)
        comentsTextField.frame = CGRect(x: 20, y: 260 + contentView.frame.height + 100, width: 290, height: 25)
        mainScrollView.addSubview(comentsTextField)
        comentsButton.frame = CGRect(x: 320, y: 260 + contentView.frame.height + 100, width: 50, height: 25)
        mainScrollView.addSubview(comentsButton)
        comentsTableView.frame = CGRect(x: 20, y: 260 + contentView.frame.height + 150, width: view.frame.width - 40 , height: 300)
        mainScrollView.addSubview(comentsTableView)
        likeButton.frame = CGRect(x: 100, y: contentView.frame.height + 280, width: 80 , height: 50)
        mainScrollView.addSubview(likeButton)
        hateButton.frame = CGRect(x: 200, y: contentView.frame.height + 280, width: 80 , height: 50)
        mainScrollView.addSubview(hateButton)
        
        mainScrollView.addSubview(updateButton)
        mainScrollView.addSubview(deleteButton)
    }
    private func getDataFire(){
        boardTitle.text = "\t\(userCategory)"
        let db = Firestore.firestore()
        db.collection(userCategory).document(userSelectPost).getDocument { snapShot, error in
            if let _ = error {
                print("파이어베이스 정보 가져오기 에러")
            }else{
                guard let title = snapShot?.get("Title") else { return }
                guard let date = snapShot?.get("Date") else { return }
                guard let writer = snapShot?.get("UserID") else { return }
                guard let contents = snapShot?.get("Content") else { return }
                guard let imageID = snapShot?.get("ImageID") else { return }
                guard let like = snapShot?.get("Like") else {
                    return }
                guard let hate = snapShot?.get("Hate") else {
                    return }
                let childID = imageID as! String
                let storageRef = Storage.storage().reference()
                let reference = storageRef.child(childID)
                reference.downloadURL { (url,error) in
                    if let _ = error {
                        print("포스트 이미지 에러")
                    }else{
                        do{
                            let data = try Data(contentsOf: url!)
                            let imageData = UIImage(data: data)
                            self.contentImage.image = imageData
                        }catch{
                            print("포스트 이미지 캐치 에러")
                        }
                    }
                }
                self.likeCount = like as! Int
                self.likeButton.setTitle("좋아요\(like)", for: .normal)
                self.hateCount = hate as! Int
                self.hateButton.setTitle("싫어요\(hate)", for: .normal)
                let name = "작성자:\(writer)님"
                self.writerLabel.text = name
                self.dateLabel.text = date as? String
                self.postTitle.text = title as? String
                self.contentLabel.text = contents as? String
                if UserData.userID == writer as! String{
                    self.deleteButton.isHidden = false
                    self.updateButton.isHidden = false
                }else{
                    self.deleteButton.isHidden = true
                    self.updateButton.isHidden = true
                }
            }
        }
    }
    @objc func comentsAct(){
        if UserData.userID.isEmpty != true {
        }else{
            let alert = UIAlertController(title: "로그인", message: "로그인 후 댓글작성 가능합니다.", preferredStyle: .alert)
            let alertOk = UIAlertAction(title: "OK", style: .destructive) { sucAct in
                let logVC = LogInPageController()
                logVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(logVC, animated: true)
                self.view.removeFromSuperview()
            }
            let alertCancel = UIAlertAction(title: "Cancel", style: .cancel) { act in }
            alert.addAction(alertCancel)
            alert.addAction(alertOk)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if comentsTextField.text?.isEmpty == true {
            let alert = UIAlertController(title: "작성", message: "댓글을 작성해주세요.", preferredStyle: .alert)
            let alertAct = UIAlertAction(title: "OK", style: .destructive) { act in}
            alert.addAction(alertAct)
            self.present(alert, animated: true, completion: nil)
        }else{
            let date = Date()
            let dateString = self.writeDate.string(from: date)
            let db = Firestore.firestore()
            guard let comentTxt = self.comentsTextField.text else{ return }
            let coment = "\(UserData.userID)\t\(dateString)"
            db.collection(userCategory).document(userSelectPost).getDocument { snapShot, error in
               guard let count = snapShot?.get("ComentCount") else { return }
                self.comentCount = count as! Int
                db.collection(self.userCategory).document(self.userSelectPost).setData(["ComentCount":self.comentCount + 1],merge: true) { err in
                if let _ = err {
                        print("댓글 에러")
                }else{
                    db.collection("Top").document(self.userSelectPost).setData(["ComentCount" : self.comentCount + 1],merge: true)
                }
            }
            }
            db.collection("Coment").document(userSelectPost).setData([coment:comentTxt], merge: true, completion: nil)
            db.collection("Users").document(UserData.userID).setData(["\(userSelectPost)\(dateString)":comentTxt], merge: true, completion: nil)
        }
            self.comentsTableView.reloadData()
            self.comentsTextField.text = ""
            self.viewWillAppear(true)
    }
    @objc func backHandel(){
        
        let mainVC = MainPageController()
        mainVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(mainVC, animated: true)
        view.removeFromSuperview()
    }
    @objc private func userPage(){
        let myPage = MyPageController()
        myPage.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(myPage, animated: true)
        view.removeFromSuperview()
    }
    @objc private func likeAct(){
        let db = Firestore.firestore()
        db.collection(userCategory).document(userSelectPost).getDocument { snapShot, err in
            if let _ = err {
               print("좋아요 에러")
            }else{
               guard let beCount = snapShot?.get("Like") else { return }
               let beValue = beCount as! Int + 1
                db.collection(self.userCategory).document(self.userSelectPost).setData(["Like":beValue], merge: true, completion: nil)
                if beValue > 10 {
                    db.collection("Top").getDocuments { docSnapShot, error in
                        if let _ = error {
                            print("탑텐 가져오기 에러")
                        }else{
                            if docSnapShot?.isEmpty == true {
                                db.collection(self.userCategory).document(self.userSelectPost).getDocument { topSnap, err in
                                    if let _ = err {
                                        print("데이터 옮기기 에러")
                                    }else{
                                        let moveData = topSnap?.data()
                                        db.collection("Top").document(self.userSelectPost).setData(moveData!,merge: true,completion: nil)
                                    }
                                }
                            }else{
                                for inData in docSnapShot!.documents {
                                    if inData.documentID == self.userSelectPost {
                                        print("이미 있는 데이터")
                                        inData.reference.setData(["Like":beValue], merge: true)
                                        return
                                    }else{
                                        print("없는 데이터")
                                        db.collection(self.userCategory).document(self.userSelectPost).getDocument { newSnap, err in
                                            if let _ = err {
                                                print("새로운 인기게시글 저장 에러")
                                            }else{
                                                let newData = newSnap?.data()
                                                db.collection("Top").document(self.userSelectPost).setData(newData!,merge: true,completion: nil)
                                                db.collection("MonthBest").document(self.userSelectPost).setData(newData!,merge: true,completion: nil)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                self.viewWillAppear(true)
            }
        }
    }
    @objc private func hateAct(){
        let db = Firestore.firestore()
        db.collection(userCategory).document(userSelectPost).getDocument { snapShot, err in
            if let _ = err {
                print("싫어요 에러")
            }else{
               guard let beCount = snapShot?.get("Hate") else { return }
               let beValue = beCount as! Int + 1
                db.collection(self.userCategory).document(self.userSelectPost).setData(["Hate":beValue], merge: true, completion: nil)
                self.viewWillAppear(true)
            }
        }
    }
    @objc func tipWrite(_ sender : UIButton){
        if userButton.isHidden == true {
            let alert = UIAlertController(title: "로그인", message: "로그인 하시겠습니까?", preferredStyle: .alert)
            let alertAct = UIAlertAction(title: "OK", style: .destructive) { act in
                let logVC = LogInPageController()
                logVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(logVC, animated: true)
                self.view.removeFromSuperview()
            }
            let alertCan = UIAlertAction(title: "Cancel", style: .cancel) { act in
            }
            alert.addAction(alertAct)
            alert.addAction(alertCan)
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Tip", message: "Tip을 작성하시겠습니까?", preferredStyle: .alert)
            let alertAct = UIAlertAction(title: "OK", style: .destructive) { act in
                let writeVC = WritePageController()
                writeVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(writeVC, animated: true)
                self.view.removeFromSuperview()
            }
            let alertCan = UIAlertAction(title: "Cancel", style: .cancel) { act in
            }
            alert.addAction(alertAct)
            alert.addAction(alertCan)
            self.present(alert, animated: true, completion: nil)
        }
    }
    private func loadFirebaseData(){
        let db = Firestore.firestore()
        db.collection("Coment").document(userSelectPost).getDocument { snapShot, error in
            if let _ = error {
                    print("코멘트 에러")
            }else{
                guard let data = snapShot?.data() else { return }
                for (key,value) in data {
                    if self.comentStringArray.contains(value as! String) != true {
                        self.comentStringArray.append(value as! String)
                    }
                    if self.idStringArray.contains(key) != true {
                        self.idStringArray.append(key)
                    }
                }
            }
            self.comentsTableView.reloadData()
        }
    }
    @objc func deletePost(){
        let db = Firestore.firestore()
        db.collection(userCategory).document(userSelectPost).delete() { err in
            if let _ = err {
                print("삭제에러")
            }else{
                let alert = UIAlertController(title: "삭제", message: "포스트가 삭제되었습니다.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .destructive) { act in
                    print("\(self.userCategory):\(self.userSelectPost) 삭제")
                    let main = MainPageController()
                    main.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(main, animated: true)
                    self.view.removeFromSuperview()
                }
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @objc func updatePost(){
        let wrVC = WritePageController()
        wrVC.updateCount = 1
        wrVC.imageID = userSelectPost
        wrVC.category = userCategory
        wrVC.writeNameTextField.text = postTitle.text
        wrVC.writeTextView.text = contentLabel.text
        wrVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(wrVC, animated: true)
        view.removeFromSuperview()
    }
}
extension PostPageController : UITableViewDelegate {

}
extension PostPageController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comentStringArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostPageTableViewCell.identifier, for: indexPath) as! PostPageTableViewCell
        cell.coment.text = self.comentStringArray[indexPath.row]
        cell.comentUserId.text = self.idStringArray[indexPath.row]
        return cell
    }


}
