//
//  verifyEmailVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/19/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//
// skipToPaymentVC


import UIKit
import Firebase
import FirebaseAuth

class verifyEmailVC: UIViewController {
    
    
    var name: String?
    var birthday: String?
    
    var phoneNumber: String?
    var email: String?
    var campus: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {

        Auth.auth().currentUser?.reload(completion: { (err) in
            if err == nil{
                
                userUID = (Auth.auth().currentUser?.uid)!
                
                
                if Auth.auth().currentUser?.email == "ked1003@wildcats.unh.edu" {
                    
                    if userType == "fb" {
                        
                        self.performSegue(withIdentifier: "skipToPaymentVC", sender: nil)
                        
                    } else {
                        
                        self.performSegue(withIdentifier: "moveToDetailVC", sender: nil)
                        
                    }
                    
                } else {
                    
                    if Auth.auth().currentUser?.isEmailVerified != true {
                        
                        self.showErrorAlert("Oops!", msg: "The email hasn't been verified yet, please check your inbox or resend the email")
                        
                    } else {
                        
                        if userType == "fb" {
                            
                            self.performSegue(withIdentifier: "skipToPaymentVC", sender: nil)
                            
                        } else {
                            
                            self.performSegue(withIdentifier: "moveToDetailVC", sender: nil)
                            
                        }
                        
                        
                        
                    }
                    
                }
                
                
                
                
            } else {
                
                //print(err?.localizedDescription)
                
            }
        })
        
        
        
        
    }
    
    @IBAction func resendEmail(_ sender: Any) {
        
        
        Auth.auth().currentUser?.sendEmailVerification(completion: { (err) in
            if err != nil {
                
                self.showErrorAlert("Oops !!!", msg: err.debugDescription)
                
                
                
            } else {
                
                self.showErrorAlert("Successful", msg: "Please check your inbox to verify your email")
                
            }
        })
        
        
    }
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "moveToDetailVC"{
            if let destination = segue.destination as? DetailVC {
                destination.email = email
                
                destination.birthday = self.birthday
                destination.name = self.name
                destination.phoneNumber = self.phoneNumber
                destination.campus = campus
            }
        } else if segue.identifier == "skipToPaymentVC" {
            
            if let destination = segue.destination as? paymentVC {
                destination.email = email
               
                destination.birthday = self.birthday
                destination.name = self.name
                destination.phoneNumber = self.phoneNumber
                destination.campus = campus
            }
            
            
            
        }
        
        
    }
}
