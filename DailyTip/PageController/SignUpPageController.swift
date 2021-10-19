//
//  SignUpPageController.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/09/05.
//

import UIKit
import FirebaseAuth
import Firebase
import UserNotifications
import FirebaseFirestore



class SignUpPageController: UIViewController {
    private let backButtonBarItem : UIBarButtonItem = {
        let back = UIBarButtonItem()
        back.image = UIImage(named: "DtBackButtonImage")?.withRenderingMode(.alwaysOriginal)
        back.action = #selector(showMainPage)
        return back
    }()
    private let mainLogoImage : UIImageView = {
        let mainLogoImage = UIImageView()
        mainLogoImage.image = #imageLiteral(resourceName: "DtMainImage")
        mainLogoImage.contentMode = .scaleToFill
        return mainLogoImage
    }()
    
    private let nameTextField : UITextField = {
       let nameTextField = UITextField()
        nameTextField.placeholder = "이름 또는 ID 를 입력해주세요."
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.borderColor = UIColor.lightGray.cgColor
        nameTextField.layer.cornerRadius = 10
        nameTextField.font = UIFont.systemFont(ofSize: 12)
        nameTextField.text = ""
        nameTextField.addLeftPadding()
        return nameTextField
    }()
    private let nameCheckButton : UIButton = {
       let nameCheckButton = UIButton()
        nameCheckButton.setTitle("중복확인", for: .normal)
        nameCheckButton.setTitleColor(.blue, for: .normal)
        nameCheckButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        nameCheckButton.layer.cornerRadius = 10
        nameCheckButton.layer.borderWidth = 1
        nameCheckButton.layer.borderColor = UIColor.lightGray.cgColor
        nameCheckButton.addTarget(self, action: #selector(nameCheck), for: .touchUpInside)
        return nameCheckButton
    }()
    private let genderSegment : UISegmentedControl = {
       let genderArray = ["남성","여성"]
       let genderSegment = UISegmentedControl(items: genderArray)
        genderSegment.layer.borderWidth = 1
        genderSegment.layer.borderColor = UIColor.lightGray.cgColor
        genderSegment.layer.cornerRadius = 10
        genderSegment.backgroundColor = .white
        genderSegment.selectedSegmentTintColor = .white
        genderSegment.tintColor = .darkGray
        genderSegment.addTarget(self, action: #selector(genderSeg), for: .valueChanged)
       return genderSegment
    }()
    private let phoneTextField : UITextField = {
       let phoneTextField = UITextField()
        phoneTextField.placeholder = "휴대폰 번호를 입력해주세요(- 제외)."
        phoneTextField.keyboardType = .numberPad
        phoneTextField.layer.borderWidth = 1
        phoneTextField.layer.borderColor = UIColor.lightGray.cgColor
        phoneTextField.layer.cornerRadius = 10
        phoneTextField.font = UIFont.systemFont(ofSize: 12)
        phoneTextField.addLeftPadding()
        return phoneTextField
    }()
    private let codeNumberCheckTextField : UITextField = {
       let codeNumberCheckTextField = UITextField()
        codeNumberCheckTextField.placeholder = "인증번호를 입력해주세요."
        codeNumberCheckTextField.keyboardType = .numberPad
        codeNumberCheckTextField.layer.borderWidth = 1
        codeNumberCheckTextField.layer.borderColor = UIColor.lightGray.cgColor
        codeNumberCheckTextField.layer.cornerRadius = 10
        codeNumberCheckTextField.font = UIFont.systemFont(ofSize: 12)
        codeNumberCheckTextField.isHidden = true
        codeNumberCheckTextField.addLeftPadding()
        return codeNumberCheckTextField
    }()
    private let codeNumberCheckButton : UIButton = {
       let codeNumberCheckButton = UIButton()
        codeNumberCheckButton.setTitle("인증확인", for: .normal)
        codeNumberCheckButton.setTitleColor(.blue, for: .normal)
        codeNumberCheckButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        codeNumberCheckButton.layer.borderWidth = 1
        codeNumberCheckButton.layer.borderColor = UIColor.lightGray.cgColor
        codeNumberCheckButton.layer.cornerRadius = 10
        codeNumberCheckButton.addTarget(self, action: #selector(numberCheck), for: .touchUpInside)
        codeNumberCheckButton.isHidden = true
        return codeNumberCheckButton
    }()
    private let signUp : UIButton = {
       let signUp = UIButton()
        signUp.setTitle("회원가입", for: .normal)
        signUp.setTitleColor(.black, for: .normal)
        signUp.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        signUp.layer.cornerRadius = 10
        signUp.layer.borderWidth = 1
        signUp.layer.borderColor = UIColor.lightGray.cgColor
        signUp.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        return signUp
    }()
    private let sendMessageButton : UIButton = {
        let sendMessageButton = UIButton()
        sendMessageButton.setTitle("번호받기", for: .normal)
        sendMessageButton.setTitleColor(.blue, for: .normal)
        sendMessageButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        sendMessageButton.layer.borderWidth = 1
        sendMessageButton.layer.borderColor = UIColor.lightGray.cgColor
        sendMessageButton.layer.cornerRadius = 10
        sendMessageButton.addTarget(self, action: #selector(sendMessageAction), for: .touchUpInside)
        return sendMessageButton
    }()
    
    private let mainScrollView : UIScrollView = {
       let mainScrollView = UIScrollView()
        mainScrollView.backgroundColor = .white
        mainScrollView.translatesAutoresizingMaskIntoConstraints = false
        return mainScrollView
    }()
    
    
     private var gender = ""
    
     private var verifyID : String = ""
     
     private var userCredential : PhoneAuthCredential?
    
     private var userPhoneNumber : String?
    
     private var sucessArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainConfigure()
        configure()
     
    }
    private func mainConfigure(){
        mainScrollView.contentSize = CGSize(width: view.frame.width, height: 1000)
        view.addSubview(mainScrollView)
        mainScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        mainScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        mainScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        mainScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    private func configure(){
        backButtonBarItem.target = self
        navigationItem.leftBarButtonItem = backButtonBarItem
        mainLogoImage.frame = CGRect(x: (view.frame.width / 2) - 80, y: 100, width: 160, height: 124)
        mainScrollView.addSubview(mainLogoImage)
        nameTextField.frame = CGRect(x: 37, y: 224 + 60, width: 300, height: 40)
        mainScrollView.addSubview(nameTextField)
        nameCheckButton.frame = CGRect(x: 260, y: 224 + 60 + 40 + 30, width: 80, height: 20)
        mainScrollView.addSubview(nameCheckButton)
        genderSegment.frame = CGRect(x: 37, y: 224 + 60 + 40 + 30 + 20 + 30, width: 300, height: 40)
        mainScrollView.addSubview(genderSegment)
        phoneTextField.frame = CGRect(x: 37, y: 224 + 60 + 40 + 30 + 20 + 30 + 40 + 30, width: 300, height: 40)
        mainScrollView.addSubview(phoneTextField)
        sendMessageButton.frame = CGRect(x: 260, y:224 + 60 + 40 + 30 + 20 + 30 + 40 + 40 + 30 + 20, width: 80, height: 20)
        mainScrollView.addSubview(sendMessageButton)
        codeNumberCheckTextField.frame = CGRect(x: 37, y: 224 + 60 + 40 + 30 + 20 + 30 + 40 + 40 + 20 + 30 + 30, width: 300, height: 40)
        mainScrollView.addSubview(codeNumberCheckTextField)
        codeNumberCheckButton.frame = CGRect(x: 260, y: 224 + 60 + 40 + 30 + 20 + 30 + 40 + 40 + 20 + 40 + 30 + 50, width: 80, height: 20)
        mainScrollView.addSubview(codeNumberCheckButton)
        signUp.frame = CGRect(x: (view.frame.width / 2) - 60, y: 224 + 340 + 30 + 60, width: 120, height: 40)
        mainScrollView.addSubview(signUp)
    }
    
    @objc private func showMainPage(){
        print("go")
        let main = MainPageController()
        main.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(main, animated: true)
    }
    
    // ID 중복검사.
    @objc private func nameCheck(){
        if nameTextField.text?.isEmpty == true {
            let nameAlert = UIAlertController(title: "오류", message: "ID 미작성", preferredStyle: .alert)
            let nameAlertAct = UIAlertAction(title: "Cancel", style: .cancel) { act in
            }
            nameAlert.addAction(nameAlertAct)
            present(nameAlert, animated: true, completion: nil)
            return
        }
        guard let name = nameTextField.text else {return}
        let db = Firestore.firestore()
        var docID = [String]()
        db.collection("Users").getDocuments { (snap, error) in
            if error == nil {
                for data in snap!.documents{
                    docID.append(data.documentID)
                }
                if docID.contains(name) == true {
                    // 닉네임 중복
                    let alert = UIAlertController(title: "오류", message: "ID가 중복됩니다.", preferredStyle: .alert)
                    let alertAct = UIAlertAction(title: "Cancel", style: .cancel) { act in
                        self.nameTextField.text = ""
                    }
                    alert.addAction(alertAct)
                    self.present(alert, animated: true, completion: nil)
                    return
                }else{
                    // 닉네임 중복x
                    let alert = UIAlertController(title: "성공", message: "ID가 사용가능합니다.", preferredStyle: .alert)
                    let alertAct = UIAlertAction(title: "Ok", style: .destructive) { act in
                        if self.sucessArray.contains("nameCheckSuccess") != true {
                            self.sucessArray.append("nameCheckSuccess")
                        }
                    }
                    alert.addAction(alertAct)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    @objc private func genderSeg(value : UISegmentedControl){
        switch value.selectedSegmentIndex {
        case 0: self.gender = "남성"
        case 1: self.gender = "여성"
        default:
                self.gender = "선택없음"
        }
    }
    @objc private func signUpAction(){
        print(gender)
        if gender == "" {
            let alert = UIAlertController(title: "오류", message: "성별을 선택해주세요.", preferredStyle: .alert)
            let alertAct = UIAlertAction(title: "Cancel", style: .cancel) { act in
            }
            alert.addAction(alertAct)
            self.present(alert, animated: true, completion: nil)
            return
        }
        if sucessArray.count < 2 {
            let alert = UIAlertController(title: "오류", message: "정보 작성을 완료해주세요.", preferredStyle: .alert)
            let alertAct = UIAlertAction(title: "Cancel", style: .cancel) { act in
            }
            alert.addAction(alertAct)
            self.present(alert, animated: true, completion: nil)
            return
        }
        guard let credential = self.userCredential else { return }
        guard let name =  self.nameTextField.text else { return }
        Auth.auth().signIn(with: credential) { (resul, error) in
            if error == nil {
                let db = Firestore.firestore()
                guard let clearNumber = self.userPhoneNumber else { return }
                db.collection("Users").document(name).setData(["Phone":clearNumber,"Gender":self.gender])
                let alert = UIAlertController(title: "회원가입 성공", message: "로그인 하시겠습니까?", preferredStyle: .alert)
                let alertAct = UIAlertAction(title: "OK", style: .destructive) { act in
                    let log = LogInPageController()
                    log.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(log, animated: true)
                }
                let alerCanCel = UIAlertAction(title: "Cancel", style: .cancel) { act in
                    self.showMainPage()
                }
                alert.addAction(alertAct)
                alert.addAction(alerCanCel)
                self.present(alert, animated: true, completion: nil)
            }else{
                print(error?.localizedDescription ?? "SignUP Error")
                let alert = UIAlertController(title: "오류", message: "인증번호 및 휴대폰번호를 확인해주세요.", preferredStyle: .alert)
                let alertAct = UIAlertAction(title: "Cancel", style: .cancel) { act in
                    self.phoneTextField.text = ""
                    self.codeNumberCheckTextField.text = ""
                }
                alert.addAction(alertAct)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func numberCheck(){
        let alert = UIAlertController(title: "확인", message: "인증 번호 확인", preferredStyle: .alert)
        let alertAct = UIAlertAction(title: "OK", style: .destructive) { act in
let credential =
                PhoneAuthProvider.provider().credential(withVerificationID: self.verifyID, verificationCode: self.codeNumberCheckTextField.text ?? "")
            self.userCredential = credential
        }
        alert.addAction(alertAct)
        present(alert, animated: true, completion: nil)
    }
    @objc private func sendMessageAction(){
        guard let phone = phoneTextField.text else { return }
        var userKRPhone = phone
        userKRPhone.removeFirst()
        let usersPhoneNumber = "+82\(userKRPhone)"
        Auth.auth().languageCode = "kr";
        PhoneAuthProvider.provider().verifyPhoneNumber(usersPhoneNumber, uiDelegate: nil) { verificationID, error in
            if error == nil {
                self.codeNumberCheckTextField.isHidden = false
                self.codeNumberCheckButton.isHidden = false
                self.userPhoneNumber = usersPhoneNumber
                self.verifyID = verificationID ?? ""
                if self.sucessArray.contains("numberSucess") != true{
                    self.sucessArray.append("numberSucess")
                }
            }else{
                let alert = UIAlertController(title: "오류", message: "잘못된 전화번호 입니다.", preferredStyle: .alert)
                let alertAct = UIAlertAction(title: "Cancel", style: .cancel) { act in
                    self.phoneTextField.text = ""
                }
                alert.addAction(alertAct)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
}
