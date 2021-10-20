//
//  MyPageController.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/09/05.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

class MyPageController: UIViewController{
    
    private let backButtonBarItem : UIBarButtonItem = {
        let back = UIBarButtonItem()
        back.image = UIImage(named: "DtBackButtonImage")?.withRenderingMode(.alwaysOriginal)
        back.action = #selector(showMainPage)
        return back
    }()
    private let myPostTable : UITableView = {
       let myPostTable = UITableView()
        myPostTable.layer.borderWidth = 1
        myPostTable.layer.borderColor = UIColor.lightGray.cgColor
        myPostTable.backgroundColor = .white
        myPostTable.register(ImageTableViewCell.self, forCellReuseIdentifier: ImageTableViewCell.identifier)
        return myPostTable
    }()
    
    private let userProfile : UIImageView = {
        // firestroge 로 에 userID 로 document 생성하고 그곳에 이미지 저장하기.
        // 꺼내올때도 그곳에서 꺼내오기.
        let userProfile = UIImageView()
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child(UserData.userID)
        reference.downloadURL { (url,error) in
            if let error = error {
                print(error)
            }else{
                do{
                    let data = try Data(contentsOf: url!)
                    let imageData = UIImage(data: data)
                    userProfile.image = imageData
                }catch{
                    print(error)
                }
            }
        }
        userProfile.contentMode = .scaleAspectFill
        userProfile.backgroundColor = .white
        userProfile.layer.masksToBounds = false
        userProfile.clipsToBounds = true
        return userProfile
    }()
    private let userProfileView : UIView = {
       let userProfileView = UIView()
        userProfileView.frame = CGRect(x: 0, y: 0, width: 130, height: 130)
        userProfileView.layer.cornerRadius = userProfileView.frame.height / 2
        userProfileView.layer.borderWidth = 1
        userProfileView.layer.borderColor = UIColor.lightGray.cgColor
        return userProfileView
    }()
    private let userProfileCorrectionButton : UIButton = {
        let userProfileCorrectionButton = UIButton()
        userProfileCorrectionButton.setImage(#imageLiteral(resourceName: "그룹 71"), for: .normal)
        userProfileCorrectionButton.contentMode = .scaleToFill
        userProfileCorrectionButton.setTitle(nil, for: .normal)
        userProfileCorrectionButton.addTarget(self, action: #selector(CorrectionHandle), for: .touchUpInside)
        return userProfileCorrectionButton
    }()
    private let idLabel : UILabel = {
        let idLabel = UILabel()
        idLabel.text = "ID"
        idLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        idLabel.textAlignment = .left
        idLabel.textColor = .lightGray
        idLabel.frame = CGRect(x: 37, y: 176, width: 23, height: 23)
        return idLabel
    }()
    
    private let idCorrectionButton : UIButton = {
       let idCorrectionButton = UIButton()
        idCorrectionButton.setImage(#imageLiteral(resourceName: "그룹 72"), for: .normal)
        idCorrectionButton.setTitle(nil, for: .normal)
        idCorrectionButton.contentMode = .scaleToFill
        idCorrectionButton.addTarget(self, action: #selector(idCorrect), for: .touchUpInside)
        idCorrectionButton.frame = CGRect(x: 120, y: 210, width: 40, height: 40)
       return idCorrectionButton
    }()
    
    private let userIdTextField : UITextField = {
        let id = UITextField()
        if let userDataID = UserDefaults.standard.string(forKey: "userPWdata") {
            id.text = userDataID
        }else{
            if UserData.userID.isEmpty != true {
                id.text = UserData.userID
            }
        }
        id.textColor = .black
        id.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        id.textAlignment = .left
        id.isEnabled = false
        id.frame = CGRect(x: 37, y: 220, width: 100, height: 23)
        return id
    }()
    private let phoneLabel : UILabel = {
        let phoneLabel = UILabel()
        phoneLabel.text = "Phone"
        phoneLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        phoneLabel.textAlignment = .left
        phoneLabel.textColor = .lightGray
        phoneLabel.frame = CGRect(x: 37, y: 276, width: 60, height: 23)
        return phoneLabel
    }()
    private let userPhoneNum : UILabel = {
        let phone = UILabel()
        let db = Firestore.firestore()
        if let userId = UserDefaults.standard.string(forKey: "userPWdata") {
            db.collection("Users").document(userId).getDocument { docsnap, err in
                if let _ = err {
                    print("phone 에러")
                }else{
                    guard let genderValue = docsnap?.get("Phone") else { return }
                    phone.text = genderValue as? String
                }
            }
        }else{
            if UserData.userPhone.isEmpty != true {
                phone.text = UserData.userPhone
            }
        }
        phone.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        phone.textAlignment = .left
        phone.textColor = .black
        phone.frame = CGRect(x: 37, y: 320, width: 200, height: 23)
        return phone
    }()
    private let genderLabel : UILabel = {
        let genderLabel = UILabel()
        genderLabel.text = "Gender"
        genderLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        genderLabel.textAlignment = .left
        genderLabel.textColor = .lightGray
        genderLabel.frame = CGRect(x: 37, y: 376, width: 70, height: 23)
        return genderLabel
    }()
    private let userGender : UILabel = {
        let gender = UILabel()
        let db = Firestore.firestore()
        if let userId = UserDefaults.standard.string(forKey: "userPWdata") {
            db.collection("Users").document(userId).getDocument { docsnap, err in
                if let _ = err {
                    print("젠더 에러")
                }else{
                    guard let genderValue = docsnap?.get("Gender") else { return }
                    gender.text = genderValue as? String
                }
            }
        }else{
            if UserData.userGender.isEmpty != true {
                gender.text = UserData.userGender
            }
        }
        gender.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        gender.textAlignment = .left
        gender.textColor = .black
        gender.frame = CGRect(x: 37, y: 420, width: 100, height: 23)
        return gender
    }()
    private let gradeLabel : UILabel = {
        let gradeLabel = UILabel()
        gradeLabel.text = "Grade"
        gradeLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        gradeLabel.textAlignment = .left
        gradeLabel.textColor = .lightGray
        gradeLabel.frame = CGRect(x: 37, y: 476, width: 70, height: 23)
        return gradeLabel
    }()
    private let grade : UILabel = {
        let gradeLabel = UILabel()
        gradeLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        gradeLabel.textAlignment = .left
        gradeLabel.textColor = .black
        gradeLabel.frame = CGRect(x: 37, y: 510, width: 70, height: 23)
        return gradeLabel
    }()
    private let postBoard : UILabel = {
        let postBoard = UILabel()
        postBoard.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        postBoard.textAlignment = .left
        postBoard.textColor = .black
        postBoard.frame = CGRect(x: 200, y: 520, width: 200, height: 23)
        return postBoard
    }()
    private let scrollView : UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.isScrollEnabled = true
        return scrollView
    }()
    
    private let pickerView = UIImagePickerController()
    
    let sucessBtn = UIButton()
    
    var titleArray = [String]()
    var postManArray = [String]()
    var postDateArray = [String]()
    var postImageIDarray = [String]()
    var postContentArray = [String]()
    var likeArray = [Int]()
    var hateArray = [Int]()
    var comentArray = [Int]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        pickerView.delegate = self
        myPostTable.delegate = self
        myPostTable.dataSource = self
        configure()
    }
    private func configure(){
        loadMyPostData()
        backButtonBarItem.target = self
        navigationItem.leftBarButtonItem = backButtonBarItem
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.width, height: 1000)
        view.addSubview(scrollView)
        
        scrollView.addSubview(userProfileView)
        userProfileView.frame = CGRect(x: (scrollView.frame.width / 2) - 65, y: 20, width: 130, height: 130)
        
        userProfileView.addSubview(userProfile)
        userProfile.frame = CGRect(x: 0, y: 0, width: 130, height: 130)
        userProfile.layer.cornerRadius = userProfile.frame.height / 2
        userProfileView.contentMode = .scaleAspectFill
        
        scrollView.addSubview(userProfileCorrectionButton)
        userProfileCorrectionButton.frame = CGRect(x: (scrollView.frame.width / 2) - 25, y: 120 , width: 50, height: 50)
        
        scrollView.addSubview(idLabel)
        scrollView.addSubview(userIdTextField)
        scrollView.addSubview(idCorrectionButton)
        scrollView.addSubview(phoneLabel)
        scrollView.addSubview(userPhoneNum)
        scrollView.addSubview(genderLabel)
        scrollView.addSubview(userGender)
        scrollView.addSubview(gradeLabel)
        myPostTable.frame = CGRect(x: 0, y: 550, width: scrollView.frame.width, height: 300)
        scrollView.addSubview(myPostTable)
        scrollView.addSubview(postBoard)
        scrollView.addSubview(grade)
    }
    
    private func loadMyPostData(){
        let dbPath = ["Car","Covid","Food","Mens","Womans","Wear","House","SNS","Hair","Gym","Dog","Computer"]
        let db = Firestore.firestore()
        for data in dbPath{
            db.collection(data).getDocuments { (querySnap, err) in
                if let _ = err {
                    print("myPageDataError")
                }else{
                    for userPost in querySnap!.documents {
                        let userID = userPost["UserID"] as! String
                        if UserData.userID == userID {
                            self.titleArray.append(userPost["Title"] as! String)
                            self.postManArray.append(userID)
                            self.postDateArray.append(userPost["Date"] as! String)
                            self.postImageIDarray.append(userPost["ImageID"] as! String)
                            self.likeArray.append(userPost["Like"] as! Int)
                            self.hateArray.append(userPost["Hate"] as! Int)
                            self.comentArray.append(userPost["ComentCount"] as! Int)
                        }else{
                            return
                        }
                    }
                            self.myPostTable.reloadData()
                    
                    if self.titleArray.count == 0 {
                            self.grade.text = "뉴비"
                    }else if self.titleArray.count >= 10{
                            self.grade.text = "리스너"
                    }else if self.titleArray.count >= 20 {
                        self.grade.text = "팁잘알"
                    }else if self.titleArray.count >= 30 {
                        self.grade.text = "팁신"
                    }else{
                        
                    }
                    self.postBoard.text = "내가 쓴 글 목록(\(self.titleArray.count))개"
                }
            }
        }
        
    }
    
    @objc private func showMainPage(){
        let main = MainPageController()
        main.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(main, animated: true)
        print("remove LogInView")
        view.removeFromSuperview()
    }
    @objc private func CorrectionHandle(){
        let alert =  UIAlertController(title: "카메라 갤러리", message: "접근 하겠습니다.", preferredStyle: .actionSheet)
        let library =  UIAlertAction(title: "사진앨범", style: .default) { (action) in self.openLibrary()
        }
        let camera =  UIAlertAction(title: "카메라", style: .default) { (action) in
        self.openCamera()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(library)
        alert.addAction(camera)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    func openLibrary(){
      pickerView.sourceType = .photoLibrary
      present(pickerView, animated: false, completion: nil)
    }
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
        pickerView.sourceType = .camera
        present(pickerView, animated: false, completion: nil)
        }else{
        print("아이폰이 없어서 카메라 실행 불가")
        }
    }
    @objc private func idCorrect(){
        userIdTextField.isEnabled = true
        idCorrectionButton.isHidden = true
        sucessBtn.setTitle("변경", for: .normal)
        sucessBtn.setTitleColor(.black, for: .normal)
        sucessBtn.backgroundColor = .white
        sucessBtn.layer.cornerRadius = 10
        sucessBtn.layer.borderWidth = 1
        sucessBtn.layer.borderColor = UIColor.lightGray.cgColor
        sucessBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        sucessBtn.addTarget(self, action: #selector(sucessHandle), for: .touchUpInside)
        sucessBtn.frame = CGRect(x: 120, y: 210, width: 40, height: 40)
        scrollView.addSubview(sucessBtn)
        
    }
    
    
    @objc private func sucessHandle(){
        // 새로운 document 생성 후에 기존에 있던 document data 를 모두 새로운 document로 옮긴후
        // 기존 document remove 그리고 Users collection 이 아닌 Board 들에 있는 기존 userID 로 저장되있는 필드들 전부
        // 새로운 ID로 수정하기. 그후 변경완료. bottom sheet 로 ui 나타내주기.
        // firestorge 에 있는 유저 프로필 사진도 같이 삭제후 새로운 아이디로 다시 만들기.
        // 이미지 변경없을시 기존 이미지 그대로 가져와서 다시 추가후 생성.
        let dbPath = ["Car","Covid","Food","Mens","Womans","Wear","House","SNS","Hair","Gym","Dog","Computer","Top","MonthBest"]
        let db = Firestore.firestore()
        db.collection("Users").document(UserData.userID).getDocument { document, err in
            if err == nil {
                guard let phone = document?.get("Phone") else { return }
                guard let gender = document?.get("Gender") else { return }
                let newPhone = phone as! String
                let newGender = gender as! String
            let newDb = Firestore.firestore()
            guard let userChangeID = self.userIdTextField.text else {
                print("text필드 에러")
                return}
            newDb.collection("Users").document(userChangeID).setData(["Phone":newPhone,"Gender":newGender])
            db.collection("Users").document(UserData.userID).delete { error in
            if error == nil {
            print("원래 계정 삭제")
            UserData.userID = self.userIdTextField.text!
                }else{
                print("계정삭제 에러")
                                                            }
                                                        }
                for data in dbPath {
                    db.collection(data).getDocuments { snap, err in
                        if let _ = err {
                            print("에러")
                        }else{
                            for doc in snap!.documents {
                                let name = doc.documentID
                                db.collection(data).document(name).updateData(["UserID":userChangeID])
                            }
                        }
                    }
                }
            let alert = UIAlertController(title: "ID변경", message: "\(UserData.userID) 에서 \(userChangeID)로 변경", preferredStyle: .alert)
            let alertAct = UIAlertAction(title: "OK", style:.destructive) { act in
            var data = Data()
            guard let userImage = self.userProfile.image else {
            print("imageData Error")
            return
            }
            UserDefaults.standard.removeObject(forKey: "userPWdata")
            UserDefaults.standard.setValue(userChangeID, forKey: "userPWdata")
            UserData.userImage = userImage
            data = userImage.jpegData(compressionQuality: 0.8)!
            let meta = StorageMetadata()
            meta.contentType = "image/png"
            let storage = Storage.storage()
            storage.reference().child(userChangeID).putData(data,metadata: meta) {
            (metaData,err) in
            if let error = err {
            print(error.localizedDescription)
            return
            }else{
            let oldImage = storage.reference().child(UserData.userID)
            oldImage.delete { error in
            if let err = error {
            print(err.localizedDescription)
            }else{
            print("remove oldImageData")
                                        }
                                    }
                                }
                            }
                
                        }
                alert.addAction(alertAct)
                self.present(alert, animated: true, completion: nil)
                self.userIdTextField.isEnabled = false
                UserData.userID = userChangeID
                self.idCorrectionButton.isHidden = false
                self.sucessBtn.isHidden = true
                self.myPostTable.reloadData()
            }else{
                print("document Error")
            }
        }
    }
}
extension MyPageController : UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            UserData.userImage = image
            self.userProfile.image = UserData.userImage
        dismiss(animated: true, completion: nil)
    }
}
}
extension MyPageController : UITableViewDelegate {
    
}
extension MyPageController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageTableViewCell.identifier, for: indexPath) as! ImageTableViewCell
        cell.postTitle.text = "\(self.titleArray[indexPath.row])(\(self.comentArray[indexPath.row]))"
        cell.postDate.text = self.postDateArray[indexPath.row]
        cell.postNumber.text = String(indexPath.row + 1)
        cell.postWriter.text = self.postManArray[indexPath.row]
        cell.postRecomend.text = "추천\(likeArray[indexPath.row])"
        cell.postNotRecomend.text = "비추천\(hateArray[indexPath.row])"
        let storageRef = Storage.storage().reference()
        let reference = storageRef.child(postImageIDarray.reversed()[indexPath.row])
        reference.downloadURL { (url,error) in
            if let _ = error {
                print("테이블뷰 이미지 가져오기 에러")
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
        
        let postTitle = postImageIDarray[indexPath.row]
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
