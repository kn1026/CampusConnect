//
//  AddNewCardVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/28/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Stripe
import Alamofire
import Firebase

class AddNewCardVC: UIViewController, STPPaymentCardTextFieldDelegate, CardIOPaymentViewControllerDelegate {
    
    
    @IBOutlet weak var saveBtn: UIButton!
    
    @IBOutlet weak var paymentField: UIView!
    var ids = ""
    var cardField = STPPaymentCardTextField()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        saveBtn.setTitleColor(UIColor.black, for: .normal)
        
        CardIOUtilities.preload()
        
        cardField.delegate = self
        // Do any additional setup after loading the view.
        paymentField.addSubview(cardField)
        title = "Card Field"
        cardField.textColor = UIColor.black
        cardField.postalCodeEntryEnabled = true
        cardField.borderWidth = 1.0
        
        edgesForExtendedLayout = []
        cardField.becomeFirstResponder()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let padding: CGFloat = 15
        cardField.frame = CGRect(x: 0,
                                 y: 0,
                                 width: view.bounds.width - (padding * 2),
                                 height: 50)
    }
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            
            self.dismiss(animated: true, completion: nil)
            
            
            let card: STPCardParams = STPCardParams()
            
            
            card.number = info.cardNumber
            card.expMonth = info.expiryMonth
            card.expYear = info.expiryYear
            card.cvc = info.cvv
            card.address.postalCode = ""
            
            cardField.cardParams = card
            
        }
    }

    @IBAction func openScanCardBtnPressed(_ sender: Any) {
        
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
        
    }
    
   
    
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        
        
        if cardField.cardParams.cvc != "", cardField.cardParams.number != "", cardField.cardParams.address.postalCode != "" {         
            
            swiftLoader()
            
            let card = cardField.cardParams
            
            
            if STPCardValidator.validationState(forCard: card) == .valid {
                // the card is valid.
                
                let url = MainAPIClient.shared.baseURLString
                let urls = URL(string: url!)?.appendingPathComponent("retrieve_token")
                
                 Alamofire.request(urls!, method: .post, parameters: [
                 
                    "number": card.number!,
                    "exp_month": card.expMonth,
                    "exp_year": card.expYear,
                    "cvc": card.cvc!
                 
                 ])
                 
                 .validate(statusCode: 200..<500)
                 .responseJSON { responseJSON in
                 
                switch responseJSON.result {
                 
                    case .success(let json):
                 
                        SwiftLoader.hide()
                        if let dict = json as? [String: AnyObject] {
                        
                            
                            
                           for i in dict {
                            
                            if i.key == "id" {
                                
                                self.ids = (i.value as? String)!
                                
                            }
                            
                            
                            if i.key == "card" {
                                
                                if let result = i.value as? [String: AnyObject] {
                                    
                                    if let fingerprint = result["fingerprint"] as? String {
                                        
                                        
                                        
                                        DataService.instance.mainDataBaseRef.child("fingerPrint").child(userUID).child(fingerprint).observeSingleEvent(of: .value, with: { (snapData) in
                                            
                                            if snapData.exists() {
                                                
                                                SwiftLoader.hide()
                                                self.showErrorAlert("Oopps !!!", msg: "This card has been added with your account")
                                                
                                            } else {
                                                
                                            
                                                
                                                let urlss = URL(string: url!)?.appendingPathComponent("card")
                                                
                                                Alamofire.request(urlss!, method: .post, parameters: [
                                                    
                                                    "cus_id": stripeID,
                                                    "source": self.ids
                                                    
                                                    ])
                                                    
                                                    .validate(statusCode: 200..<500)
                                                    .responseJSON { responseJSON in
                                                        
                                                        switch responseJSON.result {
                                                            
                                                        case .success( _):
                                                            
                                                            
                                                        DataService.instance.mainDataBaseRef.child("fingerPrint").child(userUID).child(fingerprint).setValue(["Timestamp": ServerValue.timestamp()])
                                                            SwiftLoader.hide()
                                                            NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "refreshPayment")), object: nil)
                                                            self.dismiss(animated: true, completion: nil)
                                                            
                                                            
                                                        case .failure(let errors):
                                                            
                                                            SwiftLoader.hide()
                                                            print(errors.localizedDescription)
                                                            self.showErrorAlert("Oopps !!!", msg: "Invalid card, please re-type or use another card")
                                                            
                                                            
                                                        }
                                                        
                                                        
                                                        
                                                }
                                                
                                            }
                                            
                                            
                                        })
                                        
                                    }
                                    
                                }
                                
                                
                            }
                            
                        }
                            
                        }
                 
                case .failure( _):
                 
                        SwiftLoader.hide()
                        
                        self.showErrorAlert("Oopps !!!", msg: "Invalid card, please re-type or use another card")
                 
                 
                 }
                 
                 
                 
                 }
                 
                 
                
                
            }
            
            
        }
            
        
        
       
        
        
        
        
    }
    
    //func show error alert
    
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
        
    
    @IBAction func dissmis1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func dismiss2BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}

