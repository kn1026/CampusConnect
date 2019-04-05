//
//  emailVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/19/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class emailVC: UIViewController {
    
    
    var name: String?
    var birthday: String?
    
    var phoneNumber: String?
    var email: String?
    var campus: String?
    
    
    @IBOutlet weak var emailNickName: UITextField!
    
    var uniName: String?
    
    @IBOutlet weak var uniDomainTxt: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        if let uni = uniName {
            
            uniDomainTxt.text = Unidict[uni]
            emailNickName.becomeFirstResponder()
            emailNickName.borderStyle = .none
            let border = CALayer()
            let width = CGFloat(2.0)
            border.borderColor = UIColor.white.cgColor
            border.frame = CGRect(x: 0, y: emailNickName.frame.size.height - width, width:  emailNickName.frame.size.width, height: emailNickName.frame.size.height)
            
            border.borderWidth = width
            emailNickName.layer.addSublayer(border)
            emailNickName.layer.masksToBounds = true
            
            
        }
        
        
    
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emailNickName.becomeFirstResponder()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.endEditing(true)
    }

    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func NextBtnPressed(_ sender: Any) {
        
        if emailNickName.text != "" {
            
            if let email = emailNickName.text {
                
                var finalEmail = ""
                
                
                
                if uniDomainTxt.text != "Campus-connect-test"  {
                    
                    finalEmail = email + Unidict[uniName!]!
                    
                } else {
                    
                    if email.contains("@") && email.contains(".") {
                        finalEmail = email
                    } else {
                        self.showErrorAlert("Ops !!!", msg: "Please use your valid email for test account")
                        return
                    }
                    
                    
                }
                
                
                self.email = finalEmail
                
                swiftLoader()
                
                
                var testEmails = ""
                var  dotCount = [Int]()
                var count = 0
                
                
                
                var testEmailArr = Array(finalEmail)
                for _ in 0..<(testEmailArr.count) {
                    if testEmailArr[count] == "." {
                        
                        dotCount.append(count)
                        
                    }
                    count += 1
                }
                
                
                
                for indexCount in dotCount {
                    testEmailArr[indexCount] = ","
                    let testEmail = String(testEmailArr)
                    testEmails = testEmail
                    testEmailed = testEmail
                }
                
                
                
                Auth.auth().createUser(withEmail: finalEmail, password: dpwd, completion: { (user, error) in
                    
                    
                    
                    if error != nil {

                        DataService.instance.checkEmailUserRef.child(testEmails).observeSingleEvent(of: .value, with: { (snapData) in
                            
                            
                            if snapData.exists() {
                                
                                
                                SwiftLoader.hide()
                                self.showErrorAlert("Oopss !!!", msg: "This email has been used")
                                return
                                
                            } else {
                                
                                Auth.auth().signIn(withEmail: finalEmail, password: dpwd, completion: { (users, error) in
                                    
                                    
                                    if error != nil {
                                        
                                        SwiftLoader.hide()
                                        self.showErrorAlert("Oopss !!!", msg: (error?.localizedDescription)!)
                                        return
                                    }
                                    if users?.user.isEmailVerified == true {
                                        
                                        users?.user.delete(completion: { (err) in
                                            
                                            if err != nil {
                                                
                                                 SwiftLoader.hide()
                                                self.showErrorAlert("Oopss !!!", msg: (err?.localizedDescription)!)
                                                return
                                                
                                            }
                                            
                                            Auth.auth().createUser(withEmail: finalEmail, password: dpwd, completion: { (usered, error) in
                                                
                                                if error != nil {
                                                    
                                                    
                                                     SwiftLoader.hide()
                                                    self.showErrorAlert("Oopss !!!", msg: (err?.localizedDescription)!)
                                                    
                                                    return
                                                }
                                                
                                                usered?.user.sendEmailVerification(completion: { (err) in
                                                    if err != nil {
                                                        
                                                        
                                                         SwiftLoader.hide()
                                                        self.showErrorAlert("Oopss !!!", msg: "Couldn't verify this email")
                                                        return
                                                        
                                                    }
                                                    
                                                    print("Verification email sent")
                                                    
                                                    SwiftLoader.hide()
                                                    self.performSegue(withIdentifier: "moveToVerifyEmailVC", sender: nil)
                                                })
                                                
                                            })
                                            
                                        })
                                        
                                        
                                        
                                    } else {
                                        
                                        
                                        
                                        
                                        users?.user.sendEmailVerification(completion: { (err) in
                                            if err != nil {
                                                
                                                SwiftLoader.hide()
                                                self.showErrorAlert("Oopss !!!", msg: "Couldn't verify this email")
                                                return
                                                
                                            }
                                            
                                            print("Verification email sent")
                                            SwiftLoader.hide()
                                            self.performSegue(withIdentifier: "moveToVerifyEmailVC", sender: nil)
                                            
                                            
                                        })
                                        
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                })
                                
                            }
                            
                        })
                        
                    } else {
                        
                        
                        user?.user.sendEmailVerification(completion: { (err) in
                            if err != nil {
                                
                                self.showErrorAlert("Oopss !!!", msg: "Couldn't verify this email")
                                return
                                
                            }
                            
                            print("Verification email sent")
                            SwiftLoader.hide()
                            self.performSegue(withIdentifier: "moveToVerifyEmailVC", sender: nil)
                        })
                        
                        
                    }
                    
                    
                    
                    
                })
                
                
            }
           
            
        } else {
            
            
            
            self.showErrorAlert("Oopss !!!", msg: "Please enter your email id to continue")
            
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "moveToVerifyEmailVC"{
            if let destination = segue.destination as? verifyEmailVC {
                destination.email = email
                destination.birthday = self.birthday
                destination.name = self.name
                destination.phoneNumber = self.phoneNumber
                destination.campus = campus
            }
        }
        
        
    }
    
    
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }

    
    func swiftLoader() {
        
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 170
        
        config.backgroundColor = UIColor.clear
        config.spinnerColor = UIColor.white
        config.titleTextColor = UIColor.white
        
        
        config.spinnerLineWidth = 3.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.7
        
        
        SwiftLoader.setConfig(config: config)
        
        
        SwiftLoader.show(title: "", animated: true)
        
        
        
        
        
        
    }
}
