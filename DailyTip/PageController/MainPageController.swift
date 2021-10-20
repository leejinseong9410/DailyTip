//
//  ViewController.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/09/03.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage

protocol dataDeleagate {
    func userData(sendData:String)
}

class MainPageController: UIViewController,WearManagerDelegate,LoginManagerDeleagate,StoreManagerDelegate,TopManagerDelegate, MonthManagerDelegate{
    
    private let categoryBestView : UIScrollView = {
       let categoryBestView = UIScrollView()
        categoryBestView.layer.borderWidth = 1
        categoryBestView.layer.borderColor = UIColor.white.cgColor
        categoryBestView.isPagingEnabled = true
        categoryBestView.backgroundColor = .white
        categoryBestView.isScrollEnabled = true
       return categoryBestView
    }()
    private let categoryBestView2 : UIScrollView = {
       let categoryBestView = UIScrollView()
        categoryBestView.layer.borderWidth = 1
        categoryBestView.layer.borderColor = UIColor.white.cgColor
        categoryBestView.isPagingEnabled = true
        categoryBestView.backgroundColor = .white
        categoryBestView.isScrollEnabled = true
       return categoryBestView
    }()
    private let categoryBestLabel : UILabel = {
       let label = UILabel()
        label.text = "Category Tip Best One"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.frame = CGRect(x: 0, y: 740, width: 170, height: 15)
        return label
    }()
    private let covidLabel : UILabel = {
       let label = UILabel()
        label.text = "COVID-19 Issue"
        label.textColor = .red
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    private let covidScroll : UIScrollView = {
       let covidScroll = UIScrollView()
        covidScroll.backgroundColor = .white
        covidScroll.isPagingEnabled = true
        covidScroll.isScrollEnabled = true
        return covidScroll
    }()
    private let dailyWearTittle : UILabel = {
        let dailyWearTittle = UILabel()
        dailyWearTittle.textColor = .black
        dailyWearTittle.text = ""
        dailyWearTittle.textAlignment = .left
        dailyWearTittle.numberOfLines = 0
        dailyWearTittle.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        dailyWearTittle.frame = CGRect(x: 0, y: 225, width: 120, height: 10)
        return dailyWearTittle
    }()
    private let dailyWearImageView : UIImageView = {
       let dailyWearImageView = UIImageView()
        dailyWearImageView.contentMode = .scaleToFill
        dailyWearImageView.frame = CGRect(x: 0, y: 240, width: 160, height: 210)
        dailyWearImageView.backgroundColor = .white
        return dailyWearImageView
    }()
    private let mainScrollView : UIScrollView = {
       let mainScrollView = UIScrollView()
        mainScrollView.backgroundColor = .white
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        return mainScrollView
    }()
    private let mainSmallButton : UIButton = {
       let mainSmallButton = UIButton()
        mainSmallButton.setImage(nil, for: .normal)
        mainSmallButton.setTitle(nil, for: .normal)
        mainSmallButton.setBackgroundImage(#imageLiteral(resourceName: "DtSmallImage"), for: .normal)
        mainSmallButton.frame.size = CGSize(width: 50, height: 27)
        mainSmallButton.addTarget(self, action: #selector(backHandel), for: .touchUpInside)
        return mainSmallButton
    }()
    public let userNameLabel : UILabel = {
       let userNameLabel = UILabel()
        if let id = UserDefaults.standard.string(forKey: "userPWdata") {
            userNameLabel.text = id
            UserData.userID = id
        }else{
            if UserData.userID.isEmpty == true {
                userNameLabel.text = "로그인이필요합니다."
            }else{
                userNameLabel.text = UserData.userID
            }
        }
        userNameLabel.textAlignment = .left
        userNameLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        userNameLabel.textColor = .black
        userNameLabel.frame = CGRect(x: 0, y: 60, width: 125, height: 20)
        return userNameLabel
    }()
//    private let logOutButton : UIButton = {
//       let logOut = UIButton()
//        logOut.setTitle("LogOut", for: .normal)
//        logOut.setTitleColor(.black, for: .normal)
//        logOut.layer.borderWidth = 1
//        logOut.layer.borderColor = UIColor.black.cgColor
//        logOut.layer.cornerRadius = 10
//        logOut.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
//        logOut.addTarget(self, action: #selector(logOutAction), for: .touchUpInside)
//        return logOut
//    }()
    private let logOut : UIBarButtonItem = {
       let logOut = UIBarButtonItem()
        logOut.image = UIImage(named: "그룹 129")?.withRenderingMode(.alwaysOriginal)
        logOut.action = #selector(logOutAction)
        return logOut
    }()
    private let writingTipButton : UIButton = {
            let writingTipButton = UIButton()
        writingTipButton.setTitle("Tip 작성", for: .normal)
        writingTipButton.frame = CGRect(x: 0, y: 90, width: 50, height: 20)
        writingTipButton.layer.cornerRadius = writingTipButton.frame.height / 2
        writingTipButton.backgroundColor = .black
        writingTipButton.setTitleColor(.white, for: .normal)
        writingTipButton.titleLabel?.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
        writingTipButton.addTarget(self, action: #selector(writingHandel), for: .touchUpInside)
        return writingTipButton
    }()
    private let userInfoButton : UIButton = {
       let userInfoButton = UIButton()
        userInfoButton.setTitle("My", for: .normal)
        userInfoButton.frame = CGRect(x: 60, y: 90, width: 20, height: 20)
        userInfoButton.backgroundColor = .black
        userInfoButton.layer.cornerRadius = userInfoButton.frame.height / 2
        userInfoButton.setTitleColor(.white, for: .normal)
        userInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
        userInfoButton.addTarget(self, action: #selector(userInfoHandle), for: .touchUpInside)
        return userInfoButton
    }()
    private let categoryCollectionView : UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let categoryCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        categoryCollectionView.frame = CGRect(x: 0, y: 120, width: 400, height: 60)
        categoryCollectionView.backgroundColor = .white
        categoryCollectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        return categoryCollectionView
    }()
    private let dailyWearLabel : UILabel = {
       let dailyWearLabel = UILabel()
        dailyWearLabel.text = "Wear DT"
        dailyWearLabel.textColor = .black
        dailyWearLabel.textAlignment = .left
        dailyWearLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        dailyWearLabel.frame = CGRect(x: 0, y: 192, width: 63, height: 16)
        return dailyWearLabel
    }()
    private let monthBestLabel : UILabel = {
       let monthBest = UILabel()
        monthBest.text = "이달의 Best"
        monthBest.textColor = .black
        monthBest.textAlignment = .left
        monthBest.font = UIFont.systemFont(ofSize: 15,weight: .bold)
        monthBest.frame = CGRect(x: 0, y: 470, width: 100, height: 16)
        return monthBest
    }()
    private let monthPageButton : UIButton = {
       let monthPageButton = UIButton()
        monthPageButton.setTitle("전체보기", for: .normal)
        monthPageButton.setTitleColor(.white, for: .normal)
        monthPageButton.titleLabel?.font = UIFont.systemFont(ofSize: 10,weight: .semibold)
        monthPageButton.frame = CGRect(x: 90, y: 465, width: 58, height: 22)
        monthPageButton.layer.cornerRadius = 5
        monthPageButton.backgroundColor = .black
        monthPageButton.addTarget(self, action: #selector(monthPageHand), for: .touchUpInside)
        return monthPageButton
    }()
    private let monthScrollView : UIScrollView = {
        let monthScroll = UIScrollView()
        monthScroll.isPagingEnabled = true
        monthScroll.isScrollEnabled = true
        monthScroll.backgroundColor = .white
        return monthScroll
    }()
    private let dailyWearInfo : UIButton = {
       let dailyWearInfo = UIButton()
        dailyWearInfo.setTitle("추천 Wear 보러 가기", for: .normal)
        dailyWearInfo.setTitleColor(.white, for: .normal)
        dailyWearInfo.titleLabel?.font = UIFont.systemFont(ofSize: 9, weight: .semibold)
        dailyWearInfo.frame = CGRect(x: 80, y: 190, width: 90, height: 22)
        dailyWearInfo.layer.cornerRadius = 5
        dailyWearInfo.backgroundColor = .black
        dailyWearInfo.addTarget(self, action: #selector(dailyWearInfoHandle), for: .touchUpInside)
        return dailyWearInfo
    }()
    private let todayHOTtenLabel : UILabel = {
       let todayHOTtenLabel = UILabel()
        todayHOTtenLabel.text = "디티의 HOT 10"
        todayHOTtenLabel.textAlignment = .left
        todayHOTtenLabel.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        todayHOTtenLabel.frame = CGRect(x: 190, y: 192, width: 100, height: 16)
        return todayHOTtenLabel
    }()
    private let todayHOTtenShowBtn : UIButton = {
       let todayHOTtenShowBtn = UIButton()
        todayHOTtenShowBtn.setTitle("전체보기", for: .normal)
        todayHOTtenShowBtn.setTitleColor(.white, for: .normal)
        todayHOTtenShowBtn.titleLabel?.font = UIFont.systemFont(ofSize: 10,weight: .semibold)
        todayHOTtenShowBtn.frame = CGRect(x: 290, y: 190, width: 58, height: 22)
        todayHOTtenShowBtn.layer.cornerRadius = 5
        todayHOTtenShowBtn.backgroundColor = .black
        todayHOTtenShowBtn.addTarget(self, action: #selector(tenShowHandel), for: .touchUpInside)
        return todayHOTtenShowBtn
    }()
    private let todayHOTtenScrollView : UIScrollView = {
        let todayHOTtenScrollView = UIScrollView()
        todayHOTtenScrollView.layer.borderWidth = 1
        todayHOTtenScrollView.layer.borderColor = UIColor.white.cgColor
        todayHOTtenScrollView.isPagingEnabled = true
        todayHOTtenScrollView.backgroundColor = .white
        todayHOTtenScrollView.isScrollEnabled = true
        return todayHOTtenScrollView
    }()
    private let storeLabel : UILabel = {
        let label = UILabel()
        let writeDate = DateFormatter()
        writeDate.dateFormat = "MM"
        let date = Date()
        let str = writeDate.string(from: date)
        label.text = "\(str)월의 편의점 1+1 행사"
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15,weight: .bold)
        return label
    }()
    private let storeTB : UITableView = {
       let tb = UITableView()
        tb.layer.borderWidth = 1
        tb.layer.borderColor = UIColor.darkGray.cgColor
        tb.backgroundColor = .white
        tb.register(StoreTableViewCell.self, forCellReuseIdentifier: StoreTableViewCell.indentifier)
        return tb
    }()
    private let covidStack : UIStackView = {
       let covidStack = UIStackView()
        let data = ["그룹 126","그룹 127","그룹 125"]
        for (i,stackButton) in data.enumerated() {
            let button = UIButton()
            button.setBackgroundImage(UIImage(named: stackButton), for: .normal)
            button.addTarget(self, action: #selector(covidStackHD), for: .touchUpInside)
            button.sizeToFit()
            button.tag = i
            covidStack.addArrangedSubview(button)
        }
        covidStack.spacing = 10
        covidStack.backgroundColor = .white
        covidStack.distribution = .equalSpacing
        return covidStack
    }()
    var storeSelect = "cu"
    var userID = ""
    var gender = ""
    var arrayCount = 0
    var boardTitle = [String]()
    var boardName = [String]()
    var boardTag = [[String()]]
    var boardDate = [String]()
    var boardImageID = [String]()
    var boardContent = [String]()
    var storeTitle = [String]()
    var storePrice = [String]()
    var searchDataTitle = [String]()
    
    let dbPath = ["Car","Covid","Food","Mens","Womans","Wear","House","SNS","Hair","Gym","Dog","Computer"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        logOut.target = self
        if userNameLabel.text != "로그인이필요합니다." {
            self.navigationItem.rightBarButtonItem = logOut
        }
        view.backgroundColor = .white
        categoryCollectionView.dataSource = self
        categoryCollectionView.delegate = self
        todayHOTtenScrollView.delegate = self
        storeTB.delegate = self
        storeTB.dataSource = self
        configure()
    }
    
    private func configure(){
        navigationItem.titleView = mainSmallButton
        view.addSubview(mainScrollView)
        getStore(name: self.storeSelect)
        mainScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        mainScrollView.contentSize = CGSize(width: view.frame.width - 40, height: 1000)
        todayHOTtenConfigure()
        addScrollViewContent()
        storeTB.frame = CGRect(x: view.frame.width / 2 , y: 530, width: 150, height:190)
        mainScrollView.addSubview(storeTB)
        categoryBestView.frame = CGRect(x: 0, y: 770, width: 160, height: 80)
        mainScrollView.addSubview(categoryBestLabel)
        categoryBestView2.frame = CGRect(x: 0, y: 860, width: 160, height: 80)
        mainScrollView.addSubview(categoryBestView2)
        mainScrollView.addSubview(categoryBestView)
        covidScroll.frame = CGRect(x: view.frame.width / 2, y: 770, width: 160, height: 110)
        mainScrollView.addSubview(covidScroll)
        covidStack.frame = CGRect(x: view.frame.width / 2 - 10, y: 890, width: 160, height: 50)
        mainScrollView.addSubview(covidStack)
        covidData()
        categoryBestDataSet()
    }
    private func addScrollViewContent(){
        mainScrollView.addSubview(userNameLabel)
        mainScrollView.addSubview(writingTipButton)
        mainScrollView.addSubview(userInfoButton)
        mainScrollView.addSubview(categoryCollectionView)
        mainScrollView.addSubview(dailyWearLabel)
        mainScrollView.addSubview(dailyWearInfo)
        mainScrollView.addSubview(todayHOTtenLabel)
        mainScrollView.addSubview(todayHOTtenShowBtn)
        mainScrollView.addSubview(monthBestLabel)
        mainScrollView.addSubview(monthPageButton)
        covidLabel.frame = CGRect(x: view.frame.width/2, y: 740, width: 170, height: 15)
        mainScrollView.addSubview(covidLabel)
        storeLabel.frame = CGRect(x: view.frame.width/2, y: 470, width: 200, height: 15)
        mainScrollView.addSubview(storeLabel)
        let stA = ["그룹 13","그룹 17","그룹 18","그룹 19"]
        var j = 0
        for i in 0..<stA.count {
            let str = UIButton()
            str.setBackgroundImage(UIImage(named: stA[i]), for: .normal)
            str.frame = CGRect(x: view.frame.width/2 + CGFloat(j) - 10, y: 490, width: 40, height: 30)
            str.tag = i
            str.addTarget(self, action: #selector(strHandle), for: .touchUpInside)
            self.mainScrollView.addSubview(str)
            j += 40
        }
        dailyWearMg()
    }
    private func todayHOTtenConfigure(){
        todayHOTtenScrollView.frame = CGRect(x: view.frame.width/2, y: 240, width: 160, height: 220)
        monthScrollView.frame = CGRect(x: 0, y: 500, width: 160, height: 220)
        mainScrollView.addSubview(monthScrollView)
        mainScrollView.addSubview(todayHOTtenScrollView)
    }
    private func dailyWearMg(){
        mainScrollView.addSubview(dailyWearImageView)
        mainScrollView.addSubview(dailyWearTittle)
        var topTen = TopTenBoardManager()
        topTen.delegate = self
        topTen.loadFireBaseData(boardName: "Top")
        var monthBest = MonthBestManger()
        monthBest.delegate = self
        monthBest.loadFireData(name: "MonthBest")
        var wearManager = WearManager()
        wearManager.delegate = self
        if let userDFvalue = UserDefaults.standard.string(forKey: "userPWdata") {
            let db = Firestore.firestore()
            db.collection("Users").document(userDFvalue).getDocument { docSnap, err in
                if let _ = err {
                    print("젠더에러")
                }else{
                    guard let genderData = docSnap?.get("Gender") else { return }
                    if UserData.userGender.isEmpty == true {
                        UserData.userGender = genderData as! String
                        if UserData.userGender.contains("남성") == true {
                            //남성
                            wearManager.dailyWearCraw(url: "https://magazine.musinsa.com/index.php?m=lookbook&showFlag=1")
                        }else if UserData.userGender.contains("여성") == true {
                            // 여성
                            wearManager.dailyWearCraw(url: "https://magazine.musinsa.com/index.php?m=lookbook&showFlag=2")
                        }else{
                            wearManager.dailyWearCraw(url: "https://magazine.musinsa.com/index.php?m=lookbook&showFlag=3")
                        }
                    }else{
                        if UserData.userGender.contains("남성") == true {
                            //남성
                            wearManager.dailyWearCraw(url: "https://magazine.musinsa.com/index.php?m=lookbook&showFlag=1")
                        }else if UserData.userGender.contains("여성") == true {
                            // 여성
                            wearManager.dailyWearCraw(url: "https://magazine.musinsa.com/index.php?m=lookbook&showFlag=2")
                        }else{
                            wearManager.dailyWearCraw(url: "https://magazine.musinsa.com/index.php?m=lookbook&showFlag=3")
                        }
                    }
                }
            }
        }else{
            wearManager.dailyWearCraw(url: "https://magazine.musinsa.com/index.php?m=lookbook&showFlag=3")
        }
   
    }
    func didDailyWearImage(images: [UIImage],title: [String]) {
        for (_,_) in images.enumerated() {
            UIView.animate(withDuration: 0.5, animations: {
                self.dailyWearImageView.image = images[0]
                self.dailyWearTittle.text = title[0]
            })
        }
    }
    func userInfo(userName: String) {
        print(userName)
    }
    @objc private func backHandel(){
        print("click-on")
    }
    @objc private func strHandle(sender:UIButton){
        if sender.tag == 0 {
            self.storeSelect = "cu"
        }else if sender.tag == 1{
            self.storeSelect = "emart24"
        }else if sender.tag == 2 {
            self.storeSelect = "gs25"
        }else if sender.tag == 3{
            self.storeSelect = "7-eleven"
        }else{
            print("편의점 에러")
        }
        print(self.storeSelect)
        getStore(name: self.storeSelect)
        storeTB.reloadData()
    }
    @objc func logOutAction(){
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 되셨습니다.", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .destructive) { act in
            UserDefaults.standard.removeObject(forKey: "userPWdata")
            UserDefaults.standard.removeObject(forKey: "userIDdata")
            UserData.userID = ""
            UserData.userPhone = ""
            UserData.userGender = ""
            UserData.userImage = UIImage(named: "userImageDef")!
            self.userNameLabel.text = "로그인이필요합니다."
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    private func getStore(name:String){
        print("getTab")
        var store = StoreManager()
        store.store = self
        switch name {
        case "cu" :
              store.didGetData(url: "https://pyony.com/brands/cu/?event_type=1&category=1&item=&sort=&q=")
            break
        case "emart24" :
            store.didGetData(url:"https://pyony.com/brands/emart24/?event_type=1&category=1&item=&sort=&q=")
            break
        case "gs25" :
            store.didGetData(url:"https://pyony.com/brands/gs25/?event_type=1&category=1&item=&sort=&q=")
            break
        case "7-eleven" :
            store.didGetData(url: "https://pyony.com/brands/seven/?event_type=1&category=1&item=&sort=&q=")
            break
        default :
            print("디폴트")
            break
        }
        storeTB.reloadData()
    }
    @objc func covidStackHD(sender:UIButton) {
        var selects = ""
        switch sender.tag {
        case 0 :
            selects = "https://www.kdca.go.kr/index.es?sid=a2"
            break
        case 1 :
            selects = "http://www.arcgis.com/apps/opsdashboard/index.html#/85320e2ea5424dfaaa75ae62e5c06e61"
            break
        case 2 :
            selects = "https://korean.cdc.gov/coronavirus/2019-ncov/symptoms-testing/symptoms.html"
            break
        default :
            break
        }
        let wearWebView = WearWebViewPageController()
        wearWebView.select = selects
        wearWebView.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(wearWebView, animated: true)
        view.removeFromSuperview()
    }
    func categoryBestDataSet(){
        let db = Firestore.firestore()
        let storageRef = Storage.storage().reference()
        for (i,dbData) in self.dbPath.enumerated(){
            db.collection(dbData).getDocuments { (snap,error) in
                if let err = error {
                    print(err.localizedDescription)
                }else{
                    var dictionary = [Dictionary<String,Any>]()
                    for aClear in snap!.documents {
                    let docName = aClear.documentID
                    let title = aClear["Title"] as! String
                    let postImageID = aClear["ImageID"] as! String
                    let like = aClear["Like"] as! Int
                    let newDictionary = ["title": title,"imageID":postImageID,
                                         "like" : like,"docID" : docName] as [String : Any]
                    dictionary.append(newDictionary)
                    }
                    let sortedArray = dictionary.sorted { $0["like"] as? Int ?? .zero > $1["like"] as? Int ?? .zero }
                    for j in 0..<sortedArray.count {
                        if j == 0 {
                            let button = UIButton()
                            let titleLabel = UILabel()
                            titleLabel.text = sortedArray[j]["title"] as? String
                            titleLabel.textColor = .white
                            titleLabel.textAlignment = .center
                            titleLabel.font = UIFont.systemFont(ofSize: 7, weight: .semibold)
                            button.titleLabel?.text = sortedArray[j]["imageID"] as? String
                            button.addTarget(self, action: #selector(self.abAct), for: .touchUpInside)
                            let label = UILabel()
                            label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
                            label.textColor = .black
                            label.textAlignment = .center
                            label.text = dbData
                            let reference = storageRef.child(sortedArray[j]["imageID"] as! String)
                            reference.downloadURL { url, error in
                            if let err = error {
                            print(err.localizedDescription)
                            }else{
                            do{
                            let data = try Data(contentsOf: url!)
                            let imageData = UIImage(data: data)
                            button.setBackgroundImage(imageData, for: .normal)
                            }catch{
                            print("이미지 다운 캐치 에러")
                                               }
                                           }
                                       }
                            self.categoryBestView.contentSize.width = 600
                            self.categoryBestView2.contentSize.width = 600
                            switch dbData {
                            case "Car" :
                                let xPosition = self.categoryBestView2.frame.width / 2 * CGFloat(i)
                                label.frame = CGRect(x: xPosition, y: 0, width: 50, height: 16)
                                button.frame = CGRect(x: xPosition, y: 10, width: 80, height: 80)
                                titleLabel.frame = CGRect(x: xPosition, y: 50, width: 80, height: 14)
                                self.categoryBestView2.addSubview(button)
                                self.categoryBestView2.addSubview(label)
                                self.categoryBestView2.addSubview(titleLabel)
                                break
                            case "Covid" :
                                let xPosition = self.categoryBestView2.frame.width / 2 * CGFloat(i)
                                label.frame = CGRect(x: xPosition, y: 0, width: 50, height: 16)
                                button.frame = CGRect(x: xPosition, y: 10, width: 80, height: 80)
                                titleLabel.frame = CGRect(x: xPosition, y: 50, width: 80, height: 14)
                                self.categoryBestView2.addSubview(button)
                                self.categoryBestView2.addSubview(label)
                                self.categoryBestView2.addSubview(titleLabel)
                                break
                            case "Food" :
                                let xPosition = self.categoryBestView2.frame.width / 2 * CGFloat(i)
                                label.frame = CGRect(x: xPosition, y: 0, width: 50, height: 16)
                                button.frame = CGRect(x: xPosition, y: 10, width: 80, height: 80)
                                titleLabel.frame = CGRect(x: xPosition, y: 50, width: 80, height: 14)
                                self.categoryBestView2.addSubview(button)
                                self.categoryBestView2.addSubview(label)
                                self.categoryBestView2.addSubview(titleLabel)
                                break
                            case "Mens" :
                                let xPosition = self.categoryBestView2.frame.width / 2 * CGFloat(i)
                                label.frame = CGRect(x: xPosition, y: 0, width: 50, height: 16)
                                button.frame = CGRect(x: xPosition, y: 10, width: 80, height: 80)
                                titleLabel.frame = CGRect(x: xPosition, y: 50, width: 80, height: 14)
                                
                                self.categoryBestView2.addSubview(button)
                                self.categoryBestView2.addSubview(label)
                                self.categoryBestView2.addSubview(titleLabel)
                                break
                            case "Womans" :
                                let xPosition = self.categoryBestView2.frame.width / 2 * CGFloat(i)
                                label.frame = CGRect(x: xPosition, y: 0, width: 50, height: 16)
                                button.frame = CGRect(x: xPosition, y: 10, width: 80, height: 80)
                                titleLabel.frame = CGRect(x: xPosition, y: 50, width: 80, height: 14)
                               
                                self.categoryBestView2.addSubview(button)
                                self.categoryBestView2.addSubview(label)
                                self.categoryBestView2.addSubview(titleLabel)
                                break
                            case "Wear" :
                                let xPosition = self.categoryBestView.frame.width / 2 * 0
                                label.frame = CGRect(x: xPosition, y: 0, width: 50, height: 16)
                                button.frame = CGRect(x: xPosition, y: 10, width: 80, height: 80)
                                titleLabel.frame = CGRect(x: xPosition, y: 50, width: 80, height: 14)
                                
                                self.categoryBestView.addSubview(button)
                                self.categoryBestView.addSubview(label)
                                self.categoryBestView.addSubview(titleLabel)
                                break
                            case "House" :
                                let xPosition = self.categoryBestView.frame.width / 2 * 1
                                label.frame = CGRect(x: xPosition, y: 0, width: 50, height: 16)
                                button.frame = CGRect(x: xPosition, y: 10, width: 80, height: 80)
                                titleLabel.frame = CGRect(x: xPosition, y: 50, width: 80, height: 14)
                              
                                self.categoryBestView.addSubview(button)
                                self.categoryBestView.addSubview(label)
                                self.categoryBestView.addSubview(titleLabel)
                                break
                            case "SNS" :
                                let xPosition = self.categoryBestView.frame.width / 2 * 2
                                label.frame = CGRect(x: xPosition, y: 0, width: 50, height: 16)
                                button.frame = CGRect(x: xPosition, y: 10, width: 80, height: 80)
                                titleLabel.frame = CGRect(x: xPosition, y: 50, width: 80, height: 14)
                                
                                self.categoryBestView.addSubview(button)
                                self.categoryBestView.addSubview(label)
                                self.categoryBestView.addSubview(titleLabel)
                                break
                            case "Hair" :
                                let xPosition = self.categoryBestView.frame.width / 2 * 3
                                label.frame = CGRect(x: xPosition, y: 0, width: 50, height: 16)
                                button.frame = CGRect(x: xPosition, y: 10, width: 80, height: 80)
                                titleLabel.frame = CGRect(x: xPosition, y: 50, width: 80, height: 14)
                              
                                self.categoryBestView.addSubview(button)
                                self.categoryBestView.addSubview(label)
                                self.categoryBestView.addSubview(titleLabel)
                                break
                            case "Gym" :
                                let xPosition = self.categoryBestView.frame.width / 2 * 4
                                label.frame = CGRect(x: xPosition, y: 0, width: 50, height: 16)
                                button.frame = CGRect(x: xPosition, y: 10, width: 80, height: 80)
                                titleLabel.frame = CGRect(x: xPosition, y: 50, width: 80, height: 14)
                                
                                self.categoryBestView.addSubview(button)
                                self.categoryBestView.addSubview(label)
                                self.categoryBestView.addSubview(titleLabel)
                                break
                            case "Dog" :
                                let xPosition = self.categoryBestView.frame.width / 2 * 5
                                label.frame = CGRect(x: xPosition, y: 0, width: 50, height: 16)
                                button.frame = CGRect(x: xPosition, y: 10, width: 80, height: 80)
                                titleLabel.frame = CGRect(x: xPosition, y: 50, width: 80, height: 14)
                              
                                self.categoryBestView.addSubview(button)
                                self.categoryBestView.addSubview(label)
                                self.categoryBestView.addSubview(titleLabel)
                                break
                            case "Computer" :
                                let xPosition = self.categoryBestView.frame.width / 2 * 6
                                label.frame = CGRect(x: xPosition, y: 0, width: 50, height: 16)
                                button.frame = CGRect(x: xPosition, y: 10, width: 80, height: 80)
                                titleLabel.frame = CGRect(x: xPosition, y: 50, width: 80, height: 14)
                              
                                self.categoryBestView.addSubview(button)
                                self.categoryBestView.addSubview(label)
                                self.categoryBestView.addSubview(titleLabel)
                                break
                            default:
                                print("err")
                                break
                            }
                        }else{
                            print("erl")
                        }
                    }
                    print("erl")
                }
            }
        }
    }
    @objc func abAct(sender : UIButton ) {
        guard let documentID = sender.titleLabel?.text else { return }
        let postPage = PostPageController()
        postPage.userSelectPost = documentID
        if documentID.contains("Car") == true {
            postPage.userCategory = "Car"
        }else if documentID.contains("Covid") == true {
            postPage.userCategory = "Covid"
        }else if documentID.contains("Food") == true {
            postPage.userCategory = "Food"
        }else if documentID.contains("Mens") == true {
            postPage.userCategory = "Mens"
        }else if documentID.contains("Woman") == true {
            postPage.userCategory = "Woman"
        }else if documentID.contains("Wear") == true {
            postPage.userCategory = "Wear"
        }else if documentID.contains("House") == true {
            postPage.userCategory = "House"
        }else if documentID.contains("SNS") == true {
            postPage.userCategory = "SNS"
        }else if documentID.contains("Hair") == true {
            postPage.userCategory = "Hair"
        }else if documentID.contains("Gym") == true {
            postPage.userCategory = "Gym"
        }else if documentID.contains("Dog") == true {
            postPage.userCategory = "Dog"
        }else if documentID.contains("Computer") == true {
            postPage.userCategory = "Computer"
        }else{
            print("포스트 페이지 이동 에러")
        }
        postPage.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(postPage, animated: true)
        view.removeFromSuperview()
    }
    func storeDataGetting(title: [String], price: [String]) {
        storePrice.removeAll()
        storeTitle.removeAll()
        for ti in title {
            self.storeTitle.append(ti)
        }
        for pr in price {
            self.storePrice.append(pr)
        }
        storeTB.reloadData()
    }
    @objc private func writingHandel(){
        if userNameLabel.text == "로그인이필요합니다." {
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
    
    private func covidData(){
        let db = Firestore.firestore()
        db.collection("Covid").getDocuments { snap, err in
            if let _ = err {
                print("covidError")
            }else{
                var i = 0
                for covidData in snap!.documents {
                    let button = UIButton()
                    button.titleLabel?.text = covidData["ImageID"] as? String
                    button.addTarget(self, action: #selector(self.topButtonAct), for: .touchUpInside)
                    let titleLabel = UILabel()
                    titleLabel.text = covidData["Title"] as? String
                    titleLabel.textColor = .white
                    titleLabel.textAlignment = .center
                    titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
                    let xPosition = self.covidScroll.frame.width * CGFloat(i)
                    let storageRef = Storage.storage().reference()
                    let reference = storageRef.child(covidData["ImageID"] as! String)
                    reference.downloadURL { url, error in
                    if let err = error {
                    print(err.localizedDescription)
                    }else{
                    do{
                                            let data = try Data(contentsOf: url!)
                                            let imageData = UIImage(data: data)
                                            button.setBackgroundImage(imageData, for: .normal)
                                        }catch{
                                         print("이미지 다운 캐치 에러")
                                        }
                                    }
                                }
                    self.covidScroll.contentSize.width =
                                self.view.frame.width * CGFloat(1+i)
                    button.frame = CGRect(x: xPosition, y: 0, width: 160, height: 100)
                    titleLabel.frame = CGRect(x: xPosition, y: 65, width: 160, height: 12)
                    self.covidScroll.addSubview(button)
                    self.covidScroll.addSubview(titleLabel)
                    i += 1
                }
            }
        }
    }
    @objc private func monthPageHand(){
        let topVC = Top10PageController()
        topVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(topVC, animated: true)
        view.removeFromSuperview()
    }
    @objc private func tenShowHandel(sender : UIButton){
            let topVC = Top10PageController()
            topVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(topVC, animated: true)
        view.removeFromSuperview()
       
    }
    func monthDataGet(dictionary: [Dictionary<String, Any>]) {
        for i in 0..<dictionary.count{
            let topButton = UIButton()
            topButton.layer.borderColor = UIColor.white.cgColor
            topButton.layer.borderWidth = 1
            topButton.addTarget(self, action: #selector(topButtonAct), for: .touchUpInside)
            topButton.titleLabel?.text = dictionary[i]["imageID"] as? String
            topButton.setTitleColor(.clear, for: .normal)
            let titleLabel = UILabel()
            let tagLabel = UILabel()
            tagLabel.textColor = .white
            tagLabel.textAlignment = .center
            tagLabel.font = UIFont.systemFont(ofSize: 10,weight: .semibold)
            let tagTxT = dictionary[i]["tag"] as! [String]
            let textFormat = tagTxT.joined()
            if textFormat.isEmpty == true {
                tagLabel.text = "태그없음"
                tagLabel.textColor = .lightGray
            }else{
                tagLabel.text = textFormat
            }
            titleLabel.text = dictionary[i]["title"] as? String
            titleLabel.textColor = .white
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 15,weight: .semibold)
            let storageRef = Storage.storage().reference()
            let reference = storageRef.child(dictionary[i]["imageID"] as! String)
            reference.downloadURL { url, error in
                if let err = error {
                    print(err.localizedDescription)
                }else{
                    do{
                        let data = try Data(contentsOf: url!)
                        let imageData = UIImage(data: data)
                        topButton.setBackgroundImage(imageData, for: .normal)
                    }catch{
                     print("이미지 다운 캐치 에러")
                    }
                }
            }
            topButton.contentMode = .scaleAspectFit
            let xPosition = self.monthScrollView.frame.width * CGFloat(i)
            topButton.frame = CGRect(x: xPosition, y: 10,
            width: 160 ,height: 210)
            titleLabel.frame = CGRect(x: xPosition + 8, y: 160, width: 130, height: 20)
            tagLabel.frame = CGRect(x: xPosition + 8, y: 180, width: 150, height: 15)
            self.monthScrollView.contentSize.width =
            self.view.frame.width * CGFloat(1+i)
            self.monthScrollView.addSubview(topButton)
            self.monthScrollView.addSubview(titleLabel)
            self.monthScrollView.addSubview(tagLabel)
            let numLabel = UILabel()
            numLabel.text = String(i + 1)
            numLabel.textColor = .white
            numLabel.textAlignment = .center
            numLabel.font = UIFont.systemFont(ofSize: 14)
            numLabel.frame = CGRect(x: xPosition, y: 0, width: 16, height: 16)
            numLabel.layer.cornerRadius = numLabel.frame.height / 2
            numLabel.layer.borderWidth = 1
            numLabel.layer.borderColor = UIColor.black.cgColor
            numLabel.backgroundColor = .black
            numLabel.contentMode = .scaleToFill
            self.monthScrollView.addSubview(numLabel)
         }
    }
    func getTopData(dictionary: [Dictionary<String, Any>]) {
        for i in 0..<dictionary.count{
            let topButton = UIButton()
            topButton.layer.borderColor = UIColor.white.cgColor
            topButton.layer.borderWidth = 1
            topButton.addTarget(self, action: #selector(topButtonAct), for: .touchUpInside)
            topButton.titleLabel?.text = dictionary[i]["imageID"] as? String
            topButton.setTitleColor(.clear, for: .normal)
            let titleLabel = UILabel()
            let tagLabel = UILabel()
            tagLabel.textColor = .white
            tagLabel.textAlignment = .center
            tagLabel.font = UIFont.systemFont(ofSize: 10,weight: .semibold)
            let tagTxT = dictionary[i]["tag"] as! [String]
            let textFormat = tagTxT.joined()
            if textFormat.isEmpty == true {
                tagLabel.text = "태그없음"
                tagLabel.textColor = .lightGray
            }else{
                tagLabel.text = textFormat
            }
            titleLabel.text = dictionary[i]["title"] as? String
            titleLabel.textColor = .white
            titleLabel.textAlignment = .center
            titleLabel.font = UIFont.systemFont(ofSize: 15,weight: .semibold)
            let storageRef = Storage.storage().reference()
            let reference = storageRef.child(dictionary[i]["imageID"] as! String)
            reference.downloadURL { url, error in
                if let err = error {
                    print(err.localizedDescription)
                }else{
                    do{
                        let data = try Data(contentsOf: url!)
                        let imageData = UIImage(data: data)
                        topButton.setBackgroundImage(imageData, for: .normal)
                    }catch{
                     print("이미지 다운 캐치 에러")
                    }
                }
            }
            topButton.contentMode = .scaleAspectFit
            let xPosition = self.todayHOTtenScrollView.frame.width * CGFloat(i)
            topButton.frame = CGRect(x: xPosition, y: 0,
            width: 160 ,height: 210)
            titleLabel.frame = CGRect(x: xPosition + 8, y: 160, width: 130, height: 20)
            tagLabel.frame = CGRect(x: xPosition + 8, y: 180, width: 150, height: 15)
            self.todayHOTtenScrollView.contentSize.width =
                self.view.frame.width * CGFloat(1+i)
            self.todayHOTtenScrollView.addSubview(topButton)
            self.todayHOTtenScrollView.addSubview(titleLabel)
            self.todayHOTtenScrollView.addSubview(tagLabel)
         }
    }
    @objc private func topButtonAct(sender:UIButton){
        guard let documentID = sender.titleLabel?.text else { return }
        let postPage = PostPageController()
        postPage.userSelectPost = documentID
        if documentID.contains("Car") == true {
            postPage.userCategory = "Car"
        }else if documentID.contains("Covid") == true {
            postPage.userCategory = "Covid"
        }else if documentID.contains("Food") == true {
            postPage.userCategory = "Food"
        }else if documentID.contains("Mens") == true {
            postPage.userCategory = "Mens"
        }else if documentID.contains("Woman") == true {
            postPage.userCategory = "Woman"
        }else if documentID.contains("Wear") == true {
            postPage.userCategory = "Wear"
        }else if documentID.contains("House") == true {
            postPage.userCategory = "House"
        }else if documentID.contains("SNS") == true {
            postPage.userCategory = "SNS"
        }else if documentID.contains("Hair") == true {
            postPage.userCategory = "Hair"
        }else if documentID.contains("Gym") == true {
            postPage.userCategory = "Gym"
        }else if documentID.contains("Dog") == true {
            postPage.userCategory = "Dog"
        }else if documentID.contains("Computer") == true {
            postPage.userCategory = "Computer"
        }else{
            print("포스트 페이지 이동 에러")
        }
        postPage.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(postPage, animated: true)
        view.removeFromSuperview()
    }
    @objc private func userInfoHandle(){
        if userNameLabel.text?.contains("로그인이필요합니다.") == true {
            print("로그인 안함")
            // 로그인 페이지로 연결
            let logVC = LogInPageController()
            logVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(logVC, animated: true)
            view.removeFromSuperview()
        }else{
            print("로그인 함")
            // 마이페이지로 연결
            let myVC = MyPageController()
            myVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(myVC, animated: true)
            view.removeFromSuperview()
        }
    }
    @objc private func dailyWearInfoHandle(){
        let wearWebView = WearWebViewPageController()
        wearWebView.modalPresentationStyle = .fullScreen
        wearWebView.select = UserSelect.userSelectURL
        self.navigationController?.pushViewController(wearWebView, animated: true)
        view.removeFromSuperview()
    }
    
    
}
extension MainPageController : UICollectionViewDelegate {
    
}
extension MainPageController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryCollectionViewCell.buttonImageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.categoryButton.setImage(CategoryCollectionViewCell.buttonImageArray[indexPath.row], for: .normal)
        cell.categoryButton.tag = indexPath.row
        cell.configure(widthValue: 0)
        cell.categoryButton.addTarget(self, action: #selector(didButtonTab), for: .touchUpInside)
        return cell
    }
    @objc func didButtonTab(sender:UIButton) {
        let carVC = BoardPageController()
        print(sender.tag)
        if sender.tag == 0 {
            carVC.title = "Car"
        }else if sender.tag == 1{
            carVC.title = "Covid"
        }else if sender.tag == 2{
            carVC.title = "Food"
        }else if sender.tag == 3{
            carVC.title = "Mens"
        }else if sender.tag == 4{
            carVC.title = "Wear"
        }else if sender.tag == 5 {
            carVC.title = "House"
        }else if sender.tag == 6 {
            carVC.title = "Gym"
        }else if sender.tag == 7 {
            carVC.title = "Computer"
        }else if sender.tag == 8 {
            carVC.title = "Hair"
        }else if sender.tag == 9 {
            carVC.title = "SNS"
        }else if sender.tag == 10 {
            carVC.title = "Womans"
        }else if sender.tag == 11 {
            carVC.title = "Dog"
        }else{
            print(sender.tag)
        }
        carVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(carVC, animated: true)
    }
    
}
extension MainPageController : UITableViewDelegate {
    
}
extension MainPageController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storeTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreTableViewCell.indentifier, for: indexPath) as! StoreTableViewCell
        cell.titleTxt.text = self.storeTitle[indexPath.row]
        cell.priceTxt.text = self.storePrice[indexPath.row]
        return cell
    }
    
    
}
