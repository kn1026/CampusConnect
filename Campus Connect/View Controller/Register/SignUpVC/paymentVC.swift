//
//  paymentVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/19/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Stripe
import Alamofire
import Firebase
import FirebaseAuth
import Cache
import ZSWTappableLabel
import ZSWTaggedString
import SafariServices


class paymentVC: UIViewController, STPPaymentCardTextFieldDelegate, CardIOPaymentViewControllerDelegate, ZSWTappableLabelTapDelegate  {
    
    
    var name: String?
    var birthday: String?
    
    var phoneNumber: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var campus: String?
    
    
    @IBOutlet weak var termOfUseLbl: ZSWTappableLabel!
    @IBOutlet weak var paymentField: UIView!
    var cardField = STPPaymentCardTextField()
    
    
    static let URLAttributeName = NSAttributedStringKey(rawValue: "URL")
    
    enum LinkType: String {
        case Privacy = "Privacy"
        case TermsOfUse = "TOU"
        case CodeOfProduct = "COP"
        
        var URL: Foundation.URL {
            switch self {
            case .Privacy:
                return Foundation.URL(string: "http://campusconnectonline.com/wp-content/uploads/2017/07/Web-Privacy-Policy.pdf")!
            case .TermsOfUse:
                return Foundation.URL(string: "http://campusconnectonline.com/wp-content/uploads/2017/07/Website-Terms-of-Use.pdf")!
            case .CodeOfProduct:
                return Foundation.URL(string: "http://campusconnectonline.com/wp-content/uploads/2017/07/User-Code-of-Conduct.pdf")!
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        termOfUseLbl.tapDelegate = self
        
        let options = ZSWTaggedStringOptions()
        options["link"] = .dynamic({ tagName, tagAttributes, stringAttributes in
            guard let typeString = tagAttributes["type"] as? String,
                let type = LinkType(rawValue: typeString) else {
                    return [NSAttributedStringKey: AnyObject]()
            }
            
            return [
                .tappableRegion: true,
                .tappableHighlightedBackgroundColor: UIColor.lightGray,
                .tappableHighlightedForegroundColor: UIColor.white,
                .foregroundColor: UIColor.white,
                .underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
                paymentVC.URLAttributeName: type.URL
                
            ]
        })
        
        let string = NSLocalizedString("By clicking Sign Up or Skip, you agree to our <link type='TOU'>Terms of use</link>, <link type='Privacy'>Privacy Policy</link> and <link type='COP'>User Code of Conduct</link>.", comment: "")
        
        termOfUseLbl.attributedText = try? ZSWTaggedString(string: string).attributedString(with: options)
        
        
       
        
        CardIOUtilities.preload()
        
        cardField.delegate = self
        // Do any additional setup after loading the view.
        paymentField.addSubview(cardField)
        title = "Card Field"
        cardField.textColor = UIColor.white
        cardField.postalCodeEntryEnabled = true
        cardField.borderWidth = 1.0
        
        edgesForExtendedLayout = []
        cardField.becomeFirstResponder()
        

        
        if name == nil {
            
            if firstName != nil, lastName != nil {
                
                if (firstName?.contains("\0"))! {
                    firstName = firstName!.replacingOccurrences(of: "\0", with: "", options: NSString.CompareOptions.literal, range:nil)
                }
                
                if (lastName?.contains("\0"))! {
                    lastName = lastName!.replacingOccurrences(of: "\0", with: "", options: NSString.CompareOptions.literal, range:nil)
                }
                
                
                name = firstName! + " " + lastName!
            }
            
            
        }
 
        
        
    }
    
    
    func tappableLabel(_ tappableLabel: ZSWTappableLabel, tappedAt idx: Int, withAttributes attributes: [NSAttributedStringKey : Any] = [:]) {
        guard let URL = attributes[paymentVC.URLAttributeName] as? URL else {
            return
        }
        
        if #available(iOS 9, *) {
            show(SFSafariViewController(url: URL), sender: self)
        } else {
            UIApplication.shared.openURL(URL)
        }
    }
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            //info.cardNumber holds the credit card number
            //NSString(format:"%02lu/%lu",info.expiryMonth, info.expiryYear) holds expiry date
            //info.cvv holds cvv number of carnil
            self.dismiss(animated: true, completion: nil)
            
            
            let card: STPCardParams = STPCardParams()
            
            
            card.number = info.cardNumber
            card.expMonth = info.expiryMonth
            card.expYear = info.expiryYear
            card.cvc = info.cvv

            cardField.cardParams = card
            
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 15
        cardField.frame = CGRect(x: 0,
                                 y: 0,
                                 width: view.bounds.width - (padding * 2),
                                 height: 50)
    }

    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func back2BtnPressed(_ sender: Any) {
        
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
        
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
        
        
    }
    @IBAction func skipBtnPressed(_ sender: Any) {
        
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("customers")
        swiftLoader()
        Alamofire.request(urls!, method: .post, parameters: [
            
            
            "email": self.email!
            
            ])
            
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                
                switch responseJSON.result {
                    
                case .success(let json):
                    if let dict = json as? [String: AnyObject] {
                        
                        for i in dict {
                            
                            if i.key == "id" {
                                
                                if let id = i.value as? String {
                                    
                                    if id.contains("cus") {
                                        
                                        
                                        stripeID = id
                                        
                                        guard let fcmToken = Messaging.messaging().fcmToken else { return }
                                        
                            
                                            let profile: Dictionary<String, AnyObject> = ["birthday": self.birthday as AnyObject, "user_name": self.name as AnyObject, "email": self.email as AnyObject, "avatarUrl": "nil" as AnyObject,"Timestamp": ServerValue.timestamp() as AnyObject, "userUID": userUID as AnyObject, "phone": self.phoneNumber as AnyObject, "stripe_cus": id as AnyObject, "campus": self.campus as AnyObject]
                                            
                                            DataService.instance.checkEmailUserRef.child(testEmailed).setValue(["Timestamp": ServerValue.timestamp()])
                                            DataService.instance.checkPhoneUserRef.child(self.phoneNumber!).setValue(["Timestamp": ServerValue.timestamp(), "Email": self.email!])
                                            
                                            DataService.instance.mainDataBaseRef.child("User").child(userUID).setValue(profile)
                                            DataService.instance.mainDataBaseRef.child("fcmtoken").child(userUID).child(fcmToken).setValue(1)
                                            
                                            try? InformationStorage?.setObject("nil", forKey: "avatarUrl")
                                            try? InformationStorage?.setObject(self.phoneNumber, forKey: "phone")
                                            try? InformationStorage?.setObject(id, forKey: "stripe_cus")
                                            try? InformationStorage?.setObject(self.email, forKey: "email")
                                            try? InformationStorage?.setObject(self.name, forKey: "user_name")
                                            try? InformationStorage?.setObject(self.birthday, forKey: "birthday")
                                            try? InformationStorage?.setObject(self.campus, forKey: "campus")
                                        
                                        
                                            SwiftLoader.hide()
                                            self.performSegue(withIdentifier: "moveToMapVC", sender: nil)
                                            
                                            
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                        }
                        
                    }
                    
                case .failure(let error):
                    print(error)
                    
                }
                
        }
                    
                

        
        
    }
    
    @IBAction func DoneBtnPressed(_ sender: Any) {
        
        if cardField.cardParams.cvc != "", cardField.cardParams.number != "", cardField.cardParams.address.postalCode != "" {

            let card = cardField.cardParams
            
            swiftLoader()
            if STPCardValidator.validationState(forCard: card) == .valid {
                // the card is valid.
                
                
                
                STPAPIClient.shared().createToken(withCard: card) { (token: STPToken?, error: Error?) in
                    guard let _ = token, error == nil else {
                        // Present error to user...
                        
                        
                        SwiftLoader.hide()
                        print("Err: generalize token for card")
                        self.showErrorAlert("Oopps !!!", msg: "Invalid card, please re-type or use another card")
                        
                        return
                    }
                    
                    
                    if let ids = token {
                        
                        
                        
                        
                        
                        let url = MainAPIClient.shared.baseURLString
                        let urls = URL(string: url!)?.appendingPathComponent("customers")
                        
                        Alamofire.request(urls!, method: .post, parameters: [
                            
                            
                            "email": self.email!
                            
                            ])
                            
                            .validate(statusCode: 200..<500)
                            .responseJSON { responseJSON in
                                
                                switch responseJSON.result {
                                    
                                case .success(let json):
                                    
                                    if let dict = json as? [String: AnyObject] {
                                        
                                        for i in dict {
                                            
                                            if i.key == "id" {
                                                
                                                if let id = i.value as? String {
                                                    
                                                    if id.contains("cus") {
                                                        
                                                        stripeID = id
                                                        
                                                        let urlss = URL(string: url!)?.appendingPathComponent("card")
                                                        
                                                        Alamofire.request(urlss!, method: .post, parameters: [
                                                            
                                                            "cus_id": id,
                                                            "source": ids
                                                            
                                                            ])
                                                            
                                                            .validate(statusCode: 200..<500)
                                                            .responseJSON { responseJSON in
                                                                
                                                                switch responseJSON.result {
                                                                    
                                                                case .success(let json):
                                                                    
                                                                    if let dict = json as? [String: AnyObject] {
                                                                        
                                                                       let fingerPrint = dict["fingerprint"] as? String
                                                                        
                                                                        
                                                                        
                                                                        guard let fcmToken = Messaging.messaging().fcmToken else { return }
                                                                        
                                                                  
                                                                            let profile: Dictionary<String, AnyObject> = ["birthday": self.birthday as AnyObject, "user_name": self.name as AnyObject, "email": self.email as AnyObject, "avatarUrl": "nil" as AnyObject,"Timestamp": ServerValue.timestamp() as AnyObject, "userUID": userUID as AnyObject, "phone": self.phoneNumber as AnyObject, "stripe_cus": id as AnyObject, "campus": self.campus as AnyObject]
                                                                            
                                                                            
                                                                            DataService.instance.mainDataBaseRef.child("fingerPrint").child(userUID).child(fingerPrint!).setValue(["Timestamp": ServerValue.timestamp()])
                                                                            
                                                                            DataService.instance.checkEmailUserRef.child(testEmailed).setValue(["Timestamp": ServerValue.timestamp()])
                                                                            DataService.instance.checkPhoneUserRef.child(self.phoneNumber!).setValue(["Timestamp": ServerValue.timestamp(), "Email": self.email!])
                                                                            
                                                                            DataService.instance.mainDataBaseRef.child("User").child(userUID).setValue(profile)
                                                                            DataService.instance.mainDataBaseRef.child("fcmtoken").child(userUID).child(fcmToken).setValue(1)
                                                                            
                                                                            
                                                                            try? InformationStorage?.setObject("nil", forKey: "avatarUrl")
                                                                            try? InformationStorage?.setObject(self.phoneNumber, forKey: "phone")
                                                                            try? InformationStorage?.setObject(id, forKey: "stripe_cus")
                                                                            try? InformationStorage?.setObject(self.email, forKey: "email")
                                                                            try? InformationStorage?.setObject(self.name, forKey: "user_name")
                                                                            try? InformationStorage?.setObject(self.birthday, forKey: "birthday")
                                                                            try? InformationStorage?.setObject(self.campus, forKey: "campus")
                                                                            
                                                                           
                                                                            
                                                                        SwiftLoader.hide()
                                                                        self.performSegue(withIdentifier: "moveToMapVC", sender: nil)
                                                                        
                                                                    }
                                                                    
                                                                    
                                                                    
                                                                    
                                                                case .failure(let error):
                                                                    SwiftLoader.hide()
                                                                    self.showErrorAlert("Oopps !!!", msg: "Invalid card, please re-type or use another card")
                                                                    print(error)
                                                                    
                                                                }
                                                                
                                                                
                                                                
                                                        }
                                                        
                                                        
                                                        
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        
                                    }
                                    
                                    
                                case .failure(let error):
                                    print(error.localizedDescription)
                                    SwiftLoader.hide()
                                    self.showErrorAlert("Oopps !!!", msg: "Error occured, please check your internet connection and try again")
                                    
                                }
                                
                                
                                
                        }
                        
                    }
                }
                
                
                
            } else {
                
                self.showErrorAlert("Oopps !!!", msg: "Your card is invalid, please try again")
                
            }
            
            
            
            
        } else {
            
            
            self.showErrorAlert("Oopps !!!", msg: "Please enter your card")
            
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

