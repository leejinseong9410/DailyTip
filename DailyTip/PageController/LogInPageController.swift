//
//  LogInPageController.swift
//  DailyTip
//
//  Created by MacBookPro on 2021/09/05.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore


protocol LoginManagerDeleagate {
    func userInfo(userName : String)
}
class LogInPageController: UIViewController {
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
    private let phoneNumberTextField : UITextField = {
       let phoneNumberTextField = UITextField()
        phoneNumberTextField.placeholder = "전화번호를 입력해주세요."
        phoneNumberTextField.layer.borderWidth = 1
        phoneNumberTextField.layer.borderColor = UIColor.lightGray.cgColor
        phoneNumberTextField.layer.cornerRadius = 10
        phoneNumberTextField.font = UIFont.systemFont(ofSize: 12)
        phoneNumberTextField.addLeftPadding()
        return phoneNumberTextField
    }()
    private let idTextField : UITextField = {
       let idTextField = UITextField()
        idTextField.placeholder = "아이디를 입력해주세요."
        idTextField.layer.borderWidth = 1
        idTextField.layer.borderColor = UIColor.lightGray.cgColor
        idTextField.layer.cornerRadius = 10
        idTextField.font = UIFont.systemFont(ofSize: 12)
        idTextField.addLeftPadding()
        return idTextField
    }()
    private let loginButton : UIButton = {
       let loginButton = UIButton()
        loginButton.setTitle("로그인", for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        loginButton.layer.cornerRadius = 10
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.lightGray.cgColor
        loginButton.addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        return loginButton
    }()
    private let signUpButton : UIButton = {
       let signUpButton = UIButton()
        signUpButton.setTitle("DT 계정이없으신가요? 회원가입.", for: .normal)
        signUpButton.setTitleColor(.blue, for: .normal)
        signUpButton.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        return signUpButton
    }()
    private let findUserInfo : UIButton = {
       let findUserInfo = UIButton()
        findUserInfo.setTitle("개인정보가 기억나지 않습니다.", for: .normal)
        findUserInfo.setTitleColor(.blue, for: .normal)
        findUserInfo.addTarget(self, action: #selector(findAction), for: .touchUpInside)
        findUserInfo.titleLabel?.font = UIFont.systemFont(ofSize: 12)
       return findUserInfo
    }()
    private let differentUserLabel : UILabel = {
        let differentUserLabel = UILabel()
        differentUserLabel.text = "다른계정 로그인"
        differentUserLabel.textColor = .lightGray
        differentUserLabel.textAlignment = .center
        differentUserLabel.font = UIFont.systemFont(ofSize: 14)
        return differentUserLabel
    }()
    private let errorMessage : UILabel = {
       let errorMessage = UILabel()
        errorMessage.text = "개인정보가 일치 하지 않습니다."
        errorMessage.textColor = .red
        errorMessage.font = UIFont.systemFont(ofSize: 10)
        errorMessage.alpha = 0
        return errorMessage
    }()
    private let autoLogin : UISwitch = {
       let auto = UISwitch()
        auto.frame = CGRect(x: 285, y: 500, width: 40, height: 20)
        return auto
    }()
    private let autoLoginLabel : UILabel = {
       let autoLogLabel = UILabel()
        autoLogLabel.text = "자동로그인"
        autoLogLabel.textColor = .black
        autoLogLabel.textAlignment = .right
        autoLogLabel.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        autoLogLabel.frame = CGRect(x: 180, y: 505, width: 100, height: 20)
        return autoLogLabel
    }()
    public var logInDelegate : LoginManagerDeleagate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
    }
    private func configure(){
        backButtonBarItem.target = self
        navigationItem.leftBarButtonItem = backButtonBarItem
        mainLogoImage.frame = CGRect(x: (view.frame.width / 2) - 80, y: 200, width: 160, height: 124)
        view.addSubview(mainLogoImage)
        phoneNumberTextField.frame = CGRect(x: 37, y: 324 + 60, width: 300, height: 40)
        view.addSubview(phoneNumberTextField)
        idTextField.frame = CGRect(x: 37, y: 324 + 60 + 40 + 30, width: 300, height: 40)
        view.addSubview(idTextField)
        errorMessage.frame = CGRect(x: 47, y: 324 + 60 + 40 + 30
                                    + 50, width: 140, height: 10)
        view.addSubview(errorMessage)
        loginButton.frame = CGRect(x: (view.frame.width / 2) - 60, y: 550, width: 120, height: 40)
        view.addSubview(loginButton)
        signUpButton.frame = CGRect(x: (view.frame.width / 2) - 80, y: 600, width: 160, height: 15)
        view.addSubview(signUpButton)
        findUserInfo.frame = CGRect(x: (view.frame.width / 2) - 80, y: 630, width: 160, height: 15)
        view.addSubview(findUserInfo)
        differentUserLabel.frame = CGRect(x: (view.frame.width / 2) - 60, y: 660, width: 120, height: 20)
        view.addSubview(differentUserLabel)
        view.addSubview(autoLogin)
        view.addSubview(autoLoginLabel)
    }
    @objc private func showMainPage(){
        let main = MainPageController()
        main.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(main, animated: true)
        print("remove LogInView")
        view.removeFromSuperview()
    }
    @objc private func loginAction(){
        if (phoneNumberTextField.text!.isEmpty || idTextField.text!.isEmpty) == true {
            print("textField is Empty")
            let alert = UIAlertController(title: "오류", message: "로그인 정보 미작성", preferredStyle: .alert)
            let alertAct = UIAlertAction(title: "Cancel", style: .cancel) { act in
                self.phoneNumberTextField.text = ""
                self.idTextField.text = ""
            }
            alert.addAction(alertAct)
            self.present(alert, animated: true, completion: nil)
        }else{
            let db = Firestore.firestore()
            guard let userID = idTextField.text else {return}
            guard let phone = phoneNumberTextField.text else { return }
            var userKRPhone = phone
            let userSavePhone = phone
            userKRPhone.removeFirst()
            let usersPhoneNumber = "+82\(userKRPhone)"
            db.collection("Users").document(userID).getDocument { (snap, error) in
                if error == nil {
                    guard let docPhone = snap!.get("Phone") else {
                        let alert = UIAlertController(title: "로그인 에러", message: "정보가 일치 하지 않습니다.", preferredStyle: .alert)
                        let alertAct = UIAlertAction(title: "Cancel", style: .cancel) { act in
                            self.phoneNumberTextField.text = ""
                            self.idTextField.text = ""
                            return
                        }
                            alert.addAction(alertAct)
                            self.present(alert, animated: true, completion: nil)
                        return }
                    guard let docGender = snap!.get("Gender") else { return }
                    if docPhone as! String == usersPhoneNumber {
                        // 로그인 성공
                        if self.autoLogin.isOn {
                            UserDefaults.standard.setValue(userID, forKey: "userPWdata")
                            UserDefaults.standard.setValue(userSavePhone, forKey: "userIDdata")
                            UserDefaults.standard.synchronize()
                        }else{
                            UserDefaults.standard.setValue(nil, forKey: "userPWdata")
                            UserDefaults.standard.setValue(nil, forKey: "userIDdata")
                            UserDefaults.standard.synchronize()
                        }
                        let alert = UIAlertController(title: "로그인", message: "로그인 되었습니다.", preferredStyle: .alert)
                        let alertAct = UIAlertAction(title: "OK", style: .destructive) { act in
                            UserData.userID = userID
                            UserData.userGender = docGender as! String
                            UserData.userPhone = docPhone as! String
                            let main = MainPageController()
                            main.modalPresentationStyle = .fullScreen
                            self.navigationController?.pushViewController(main, animated: false)
                        }
                            alert.addAction(alertAct)
                            self.present(alert, animated: true, completion: nil)
                    }else{
                        let alert = UIAlertController(title: "에러", message: "없는 정보입니다.", preferredStyle: .alert)
                        let alertAct = UIAlertAction(title: "Cancel", style: .cancel) { act in
                        }
                            alert.addAction(alertAct)
                            self.present(alert, animated: true, completion: nil)
                            return
                    }
                }else{
            
                    if let err = error {
                        print(err)
                        return
                    }
                }
            }
        }
    }
    @objc private func signUpAction(){
        let signUpVC = SignUpPageController()
        signUpVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    @objc private func findAction(){
        let findVC = FindInfoPageController()
        findVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(findVC, animated: true)
    }
  
}
extension UITextField {
  func addLeftPadding() {
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
    self.leftView = paddingView
    self.leftViewMode = ViewMode.always
  }
}
