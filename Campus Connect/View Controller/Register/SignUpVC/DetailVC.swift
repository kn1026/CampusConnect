//
//  DetailVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/19/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    
    var name: String?
    var birthday: String?
    
    var phoneNumber: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var campus: String?
    
    
    @IBOutlet weak var firstNameTxtView: UITextField!
    @IBOutlet weak var lastNameTxtView: UITextField!
    @IBOutlet weak var birthDayTxtView: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        
        
        firstNameTxtView.layer.borderColor = UIColor.white.cgColor
        firstNameTxtView.layer.borderWidth = 1.0
        firstNameTxtView.layer.cornerRadius = 3.0
        
        lastNameTxtView.layer.borderColor = UIColor.white.cgColor
        lastNameTxtView.layer.borderWidth = 1.0
        lastNameTxtView.layer.cornerRadius = 3.0
        
        
       
        birthDayTxtView.borderStyle = .none
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: birthDayTxtView.frame.size.height - width, width:  birthDayTxtView.frame.size.width + 30, height: birthDayTxtView.frame.size.height)
        
        border.borderWidth = width
        birthDayTxtView.layer.addSublayer(border)
        birthDayTxtView.layer.masksToBounds = true
        
        
        let datePickerView: UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        datePickerView.maximumDate = Date()
        birthDayTxtView.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(DetailVC.datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        birthDayTxtView.text = dateFormatter.string(from: sender.date)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        firstNameTxtView.becomeFirstResponder()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.endEditing(true)
        
    }

    @IBAction func backBtn1Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backBtn2Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func nextBtnPressed(_ sender: Any) {
        
        
        
        if let birthday = birthDayTxtView.text, birthday != "", firstNameTxtView.text != "", lastNameTxtView.text != "" {
            
            
            let date = Date()
            let calendar = Calendar.current
            
            let year = calendar.component(.year, from: date)
            
            var isBirthday = false
            var FinalBirthday = [String]()
            let testBirthdaylArr = Array(birthday)
            
            
            for i in testBirthdaylArr  {
                
                if isBirthday == false {
                    
                    if i == "," {
                        
                        isBirthday = true
                        
                    }
                    
                } else {
                    
                    let num = String(i)
                    
                    
                    FinalBirthday.append(num)
                    
                }
                
            }
            
            
            let result = FinalBirthday.dropFirst()
            if let bornYear = Int(result.joined()) {
                
                
                
                let currentAge = year - bornYear
                if currentAge >= 17 {
                    
                    
                    self.firstName = firstNameTxtView.text
                    self.lastName = lastNameTxtView.text
                    self.birthday = birthDayTxtView.text
                    
                    
                    self.performSegue(withIdentifier: "moveToPaymentVC", sender: nil)
                    
                } else {
                    
                    self.showErrorAlert("Oops !!!", msg: "Your age need to be above 16")
                    
                    
                }
            }
            
            
            
            
        } else {
            
            self.showErrorAlert("Oops !!!", msg: "Please fill all the fields")
            
        }
        
        
        
        
        
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
       self.view.endEditing(true)
        
    }
    
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "moveToPaymentVC"{
            if let destination = segue.destination as? paymentVC {
                destination.email = email
                destination.birthday = self.birthday
                destination.name = self.name
                destination.phoneNumber = self.phoneNumber
                destination.firstName = firstName
                destination.lastName = lastName
                destination.campus = campus
            }
        }
        
        
    }
    
    
}

extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}
