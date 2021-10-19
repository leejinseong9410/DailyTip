//
//  FindInfoPageController.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/09/11.
//

import UIKit
import FirebaseAuth
import Firebase
import UserNotifications
import FirebaseFirestore

class FindInfoPageController: UIViewController {
    
    private let dtLogo : UIImageView = {
       let mainLogo = UIImageView()
        mainLogo.image = UIImage(named: "DtMainImage")
        mainLogo.contentMode = .scaleAspectFill
        mainLogo.translatesAutoresizingMaskIntoConstraints = false
        return mainLogo
    }()
    private let phoneNumberTextField : UITextField = {
       let phoneNumberTextField = UITextField()
        phoneNumberTextField.placeholder = "휴대폰 번호를 적어주세요 ('-'제외)"
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberTextField.keyboardType = .numberPad
        phoneNumberTextField.layer.borderWidth = 1
        phoneNumberTextField.layer.borderColor = UIColor.black.cgColor
        phoneNumberTextField.layer.cornerRadius = 10
        phoneNumberTextField.font = UIFont.systemFont(ofSize: 12, weight: .light)
        phoneNumberTextField.textColor = .black
        phoneNumberTextField.addLeftPadding()
        return phoneNumberTextField
    }()
    private let credentialButton : UIButton = {
       let button = UIButton()
        button.setTitle("인증번호 발송", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(credentialAct), for: .touchUpInside)
        return button
    }()
    private let credentialNumberField : UITextField = {
       let credentialNumberField = UITextField()
        credentialNumberField.placeholder = "발송된 인증번호를 적어주세요"
        credentialNumberField.addLeftPadding()
        credentialNumberField.translatesAutoresizingMaskIntoConstraints = false
        credentialNumberField.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        credentialNumberField.layer.borderWidth = 1
        credentialNumberField.layer.borderColor = UIColor.black.cgColor
        credentialNumberField.textColor = .blue
        credentialNumberField.keyboardType = .numberPad
        credentialNumberField.layer.cornerRadius = 10
        credentialNumberField.isHidden = true
       return credentialNumberField
    }()
    private let credentialNumberCheckButton : UIButton = {
       let credentialNumberCheckButton = UIButton()
        credentialNumberCheckButton.setTitle("인증번호 확인", for: .normal)
        credentialNumberCheckButton.setTitleColor(.blue, for: .normal)
        credentialNumberCheckButton.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        credentialNumberCheckButton.layer.borderWidth = 1
        credentialNumberCheckButton.layer.borderColor = UIColor.black.cgColor
        credentialNumberCheckButton.layer.cornerRadius = 10
        credentialNumberCheckButton.translatesAutoresizingMaskIntoConstraints = false
        credentialNumberCheckButton.addTarget(self, action: #selector(credentialCheck), for: .touchUpInside)
        credentialNumberCheckButton.isHidden = true
        return credentialNumberCheckButton
    }()
    private let getUserData : UILabel = {
       let userData = UILabel()
        userData.translatesAutoresizingMaskIntoConstraints = false
        userData.textColor = .black
        userData.textAlignment = .center
        userData.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        userData.layer.borderWidth = 1
        userData.layer.borderColor = UIColor.black.cgColor
        userData.layer.cornerRadius = 10
        userData.isHidden = true
        return userData
    }()
    
    private var verifyID : String = ""
    private var userPhoneNumber : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        confi()
    }
    private func confi(){
        view.addSubview(dtLogo)
        dtLogo.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true
        dtLogo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        dtLogo.widthAnchor.constraint(equalToConstant: 160).isActive = true
        dtLogo.heightAnchor.constraint(equalToConstant: 124).isActive = true
        view.addSubview(phoneNumberTextField)
        phoneNumberTextField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 260).isActive = true
        phoneNumberTextField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        phoneNumberTextField.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true
        phoneNumberTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.addSubview(credentialButton)
        credentialButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 320).isActive = true
        credentialButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        credentialButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        credentialButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.addSubview(credentialNumberField)
        credentialNumberField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 370).isActive = true
        credentialNumberField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        credentialNumberField.widthAnchor.constraint(equalToConstant: self.view.frame.width - 40).isActive = true
        credentialNumberField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.addSubview(credentialNumberCheckButton)
        credentialNumberCheckButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 430).isActive = true
        credentialNumberCheckButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true
        credentialNumberCheckButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        credentialNumberCheckButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        view.addSubview(getUserData)
        getUserData.topAnchor.constraint(equalTo: self.view.topAnchor,constant: 490).isActive = true
        getUserData.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        getUserData.widthAnchor.constraint(equalToConstant: 150).isActive = true
        getUserData.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    @objc func credentialAct(){
        if phoneNumberTextField.text?.isEmpty != true {
            guard let phone = phoneNumberTextField.text else { return }
            var userKRPhone = phone
            userKRPhone.removeFirst()
            let usersPhoneNumber = "+82\(userKRPhone)"
            Auth.auth().languageCode = "kr";
            PhoneAuthProvider.provider().verifyPhoneNumber(usersPhoneNumber, uiDelegate: nil) { (verificationID, error) in
                if let err = error {
                    print(err.localizedDescription)
                    let alert = UIAlertController(title: "오류", message: "번호가 잘못 되었습니다.", preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: "OK", style: .destructive) { act in
                        return
                    }
                    alert.addAction(alertAction)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    self.credentialNumberField.isHidden = false
                    self.credentialNumberCheckButton.isHidden = false
                    self.verifyID = verificationID ?? ""
                    self.userPhoneNumber = usersPhoneNumber
                }
            }
           
        }else{
            let alert = UIAlertController(title: "정보 입력", message: "휴대폰 번호를 입력해주세요.", preferredStyle: .alert)
            let alertAct = UIAlertAction(title: "OK", style: .destructive) { act in
                return
            }
            alert.addAction(alertAct)
            self.present(alert, animated: true, completion: nil)
        }
    }
    @objc func credentialCheck(){
    if credentialNumberField.text?.isEmpty != true {
    let crede = PhoneAuthProvider.provider().credential(withVerificationID: self.verifyID, verificationCode: self.credentialNumberField.text ?? "")
    if crede.provider.isEmpty != true {
        let alert = UIAlertController(title: "확인", message: "인증번호가 확인되셨습니다.", preferredStyle: .alert)
        let alertActions = UIAlertAction(title: "OK", style: .destructive) { act in
            let db = Firestore.firestore()
            db.collection("Users").getDocuments { querySnap, err in
                if let error = err {
                    print(error.localizedDescription)
                }else{
                    for data in querySnap!.documents {
                        let userPhone = data["Phone"] as! String
                        if userPhone == self.userPhoneNumber {
                            let userID = data.documentID
                            self.getUserData.text = "아이디:\(userID)"
                            self.getUserData.isHidden = false
                        }else{
                            return
                        }
                    }
                }
            }
        }
        alert.addAction(alertActions)
        self.present(alert, animated: true, completion: nil)
    }
    }else{
            let alert = UIAlertController(title: "정보 입력", message: "인증 번호를 입력해주세요.", preferredStyle: .alert)
            let alertAct = UIAlertAction(title: "OK", style: .destructive) { act in
                return
            }
            alert.addAction(alertAct)
            self.present(alert, animated: true, completion: nil)
            }
        }
    }
