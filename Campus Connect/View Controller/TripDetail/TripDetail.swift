//
//  TripDetail.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/8/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Cache
import Alamofire
import AlamofireImage
import PassKit
import Stripe
import Firebase

class TripDetail: UIViewController {
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var progressLbl: UILabel!
    
    @IBOutlet weak var last4DigitsLbl: UILabel!
    @IBOutlet weak var brandCard: UIImageView!
    
    @IBOutlet weak var tipView: UIView!
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var pickUpLbl: UILabel!
    
    @IBOutlet weak var destinationLbl: UILabel!
    
    @IBOutlet weak var carRegistrationLbl: UILabel!
    
    @IBOutlet weak var driverImg: borderAvatarView!
    @IBOutlet weak var carModelLbl: UILabel!
    
    
    @IBOutlet weak var driverNameLbl: UILabel!
    
    
    @IBOutlet weak var NoneDollarTip: UIButton!
    @IBOutlet weak var FiveDollarTip: UIButton!
    @IBOutlet weak var TwoDollarTip: UIButton!
    @IBOutlet weak var OneDollarTip: UIButton!
    
    var time: Any?
    var price: Double?
    var progress: String?
    var last4Digits: String?
    var brandCards: String?
    var pickUpName: String?
    var destinationName: String?
    var carRegistration: String?
    var driverUrlImg: String?
    var carModel: String?
    var name: String?
    var phone: String?
    var driver_uid: String?
    var Trip_key: String?
    var capturedKey = ""
    
    var tip = 0
    
    @IBOutlet weak var TipLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        
         
        
        let times = time as? TimeInterval
        let date = Date(timeIntervalSince1970: times!/1000)
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        let timess = timeFormatter.string(from: date)
        if dayDifference(from: date) == "Today" {
            
            timeLbl.text = "Today \(timess)"
            
        } else if dayDifference(from: date) == "Yesterday" {
            
            timeLbl.text = "Yesterday \(timess)"
            
        } else {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = DateFormatter.Style.medium
            let Dateresult = dateFormatter.string(from: date)
            
            
            timeLbl.text = "\(Dateresult) \(timess)"

        }
        
        
        progressLbl.text = self.progress!

        if progress == "Canceled" {
            
            progressLbl.textColor = UIColor.red
            
        }
        priceLbl.text = "$\(String(format:"%.2f", self.price!))"
        last4DigitsLbl.text = " •••• \(self.last4Digits!)"
        brandCard.image = UIImage(named: self.brandCards!)
        pickUpLbl.text = self.pickUpName
        destinationLbl.text  = self.destinationName!
        carRegistrationLbl.text = self.carRegistration!
        carModelLbl.text = self.carModel!
        
        
        let fullNameArr = self.name?.components(separatedBy: " ")
        driverNameLbl.text = fullNameArr![0].firstUppercased
        TipLbl.text = "Leave tip for \(fullNameArr![0].firstUppercased)"
        loadDriverImg()
        
 
    }
    
    @IBAction func NoneDollarTip(_ sender: Any) {
        
        OneDollarTip.backgroundColor = UIColor.clear
        TwoDollarTip.backgroundColor = UIColor.clear
        FiveDollarTip.backgroundColor = UIColor.clear
        NoneDollarTip.backgroundColor = UIColor.yellow
        
        
        tip = 0
    }
    
    
    @IBAction func oneDollarBtn(_ sender: Any) {
        
        OneDollarTip.backgroundColor = UIColor.yellow
        TwoDollarTip.backgroundColor = UIColor.clear
        FiveDollarTip.backgroundColor = UIColor.clear
        NoneDollarTip.backgroundColor = UIColor.clear
        
        tip = 1
        
    }
    
    @IBAction func twoDollarBtn(_ sender: Any) {
        
        OneDollarTip.backgroundColor = UIColor.clear
        TwoDollarTip.backgroundColor = UIColor.yellow
        FiveDollarTip.backgroundColor = UIColor.clear
        NoneDollarTip.backgroundColor = UIColor.clear
        
        
        tip = 2
    }
    
    @IBAction func fiveDollarBtn(_ sender: Any) {
        
        OneDollarTip.backgroundColor = UIColor.clear
        TwoDollarTip.backgroundColor = UIColor.clear
        FiveDollarTip.backgroundColor = UIColor.yellow
        NoneDollarTip.backgroundColor = UIColor.clear
        
        
        tip = 5
        
    }
    
    @IBAction func ChargeTipBtnPressed(_ sender: Any) {
        
        if tip != 0 {
            
            swiftLoader()
            
            let price = Double(self.tip)
            var roundedPrice = price.roundTo(places: 2)
            
            roundedPrice = roundedPrice * 100
            
            
            self.chargeForTip(charged: roundedPrice, name: self.name!, DriverUID: self.driver_uid!)
            
            
            
        }
        
    }
    
    func chargeForTip(charged: Double, name: String, DriverUID: String) {
        
        
        let currentDateTime = Date()
        
        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        // get the date time String from the date object
        let result = formatter.string(from: currentDateTime)
        let description = "Tip to \(name) from Campus Connect at \(result)"
        
        
        
        if chargedCardID == "" {
            
            SwiftLoader.hide()
            isSelected = true
            NotificationCenter.default.addObserver(self, selector: #selector(MapView.setPayment), name: (NSNotification.Name(rawValue: "setPayment")), object: nil)
            self.performSegue(withIdentifier: "moveToPaymentVC", sender: nil)
            
            return
            
        }
        
        
        if chargedCardBrand == "Apple_pay" {
            
            
            self.makeApple_pay(text: description)
            
            
        } else {
            
            
            makePayment(captured: true, price: charged, text: description) {
                
                self.prepare_payDriver(price: charged, DriverUID: DriverUID)
                
            }
            
            
        }
        
        
        
        
        
        
        
        
        
    }

    
    func makeApple_pay(text: String) {
        
        
        SwiftLoader.hide()
        
        let request = PKPaymentRequest()
        request.merchantIdentifier = STPPaymentConfiguration.shared().appleMerchantIdentifier!
        request.supportedNetworks = [.visa, .amex, .masterCard, .discover]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.paymentSummaryItems = calculateSummaryItemsFromSwag(text: text)
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayController?.delegate = self
        if applePayController != nil {
            
            self.present(applePayController!, animated: true, completion: nil)
            
        } else {
            
            print("Nil")
            
        }
        
        
        
        
        
        
    }
    
    func calculateSummaryItemsFromSwag(text: String) -> [PKPaymentSummaryItem] {
        var summaryItems = [PKPaymentSummaryItem]()
        let price = NSDecimalNumber(string: finalPrice)
        
        summaryItems.append(PKPaymentSummaryItem(label: text, amount: price))
        return summaryItems
    }
    
    
    func prepare_payDriver(price: Double, DriverUID: String){
        DataService.instance.mainDataBaseRef.child("Stripe_Driver_Connect_Account").child(DriverUID).observeSingleEvent(of: .value, with: { (Connect) in
            
            if Connect.exists() {
                
                if let acc = Connect.value as? Dictionary<String, Any> {
                    
                    if let account = acc["Stripe_Driver_Connect_Account"] as? String {
                        
                        
                        self.make_payment_driver(price: price, account: account, driverUID: DriverUID)
                        
                        
                    }
                    
                }
            }
            
        })
        
        
    }
    
    func make_payment_driver(price: Double, account: String, driverUID: String){
        
        
        let fPrice = Int(price)
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("Transfer_payment")
        
        Alamofire.request(urls!, method: .post, parameters: [
            
            "price": fPrice,
            "account": account
            
            ])
            
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                
                switch responseJSON.result {
                    
                case .success( _):
                    
                    
                    if let name = try? InformationStorage?.object(ofType: String.self, forKey: "user_name") {
                        
                        let fullNameArr = name?.components(separatedBy: " ")
                        let firstName = fullNameArr![0].firstUppercased
                        
                        DataService.instance.mainDataBaseRef.child("TipNoti").child(driverUID).childByAutoId().setValue(["RiderName": firstName,"Timestamp": ServerValue.timestamp(), "Price": price])
                        
                        self.blurView.isHidden = true
                        self.tipView.isHidden = true
                        SwiftLoader.hide()
                    }
                    
                    
                    
                    
                case .failure( _):
                    
                    
                    
                    self.blurView.isHidden = true
                    self.tipView.isHidden = true
                    SwiftLoader.hide()
                    
                    self.showErrorAlert("Oops !!!", msg: "Due to some unknown errors, we can't completely process your transaction. Please contact us to solve the issue")
                    
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
    
    
    func makePayment(captured: Bool, price: Double, text: String, completed: @escaping DownloadComplete) {
        
        //chargedCardID
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("pre_authorization")
        
        
        
        
        
        self.capturedKey = ""
        
        
        if let email = try? InformationStorage?.object(ofType: String.self, forKey: "email") {
            
            
            Alamofire.request(urls!, method: .post, parameters: [
                
                "cus_id": stripeID,
                "amount": price,
                "source": chargedCardID,
                "captured": captured,
                "description": text,
                "receipt_email": email!,
                
                
                ])
                
                .validate(statusCode: 200..<500)
                .responseJSON { responseJSON in
                    
                    switch responseJSON.result {
                        
                    case .success(let json):
                        
                        
                        if let dict = json as? [String: AnyObject] {
                            
                            
                            if let outcome = dict["outcome"] as? Dictionary<String, AnyObject> {
                                
                                
                                
                                
                                if let risk_level = outcome["risk_level"] as? String, let type = outcome["type"] as? String {
                                    
                                    if risk_level == "high" || risk_level == "elevated" || risk_level == "highest" || type == "issuer_declined" || type == "blocked"
                                        || type == "invalid"
                                        
                                    {
                                        
                                        
                                        if let reason = outcome["reason"] as? String {
                                            
                                            SwiftLoader.hide()
                                            self.capturedKey = ""
                                            self.showErrorAlert("Oops !!!", msg: "This card is flagged by our system as fraudulent, please contact us and the payment will be released immediately - \(reason)")
                                            
                                            return
                                            
                                        }
                                        
                                        return
                                    }
                                    
                                    if let captureID = dict["id"] as? String {
                                        
                                        self.capturedKey = captureID
                                        
                                        completed()
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                        
                        
                        
                        
                        
                        
                    case .failure( _):
                        SwiftLoader.hide()
                        self.showErrorAlert("Oops !!!", msg: "This card can't be used for this ride, please revise or choose another card")
                        
                    }
                    
                    
            }
            
            
            
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
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
    
    
    func loadDriverImg() {
        
        
        
        DataService.instance.mainDataBaseRef.child("Driver_Info").child(driver_uid!).observeSingleEvent(of: .value, with: { (DriverData) in
            
            
            if let DriverDict = DriverData.value as? Dictionary<String, Any> {
                
                if let FaceUrl = DriverDict["FaceUrl"] as? String {
                    
                    
                    if let CacheDriverImg = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: FaceUrl).image {
                        
                        self.driverImg.image = CacheDriverImg
                        
                    } else {
                        
                        Alamofire.request(FaceUrl).responseImage { response in
                            
                            if let image = response.result.value {
                                
                                let wrapper = ImageWrapper(image: image)
                                self.driverImg.image = image
                                try? InformationStorage?.setObject(wrapper, forKey: FaceUrl)
                                
                                
                            }
                            
                            
                        }
                        
                        
                        
                    }
                    
                    
                    
                }
                
                
                
                
            }
            
            
        })
        
        
        
        
    }
    
    
    func dayDifference(from date : Date) -> String
    {
        let calendar = NSCalendar.current
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInToday(date) { return "Today" }
        else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 { return "\(abs(day)) days ago" }
            else { return "In \(day) days" }
        }
    }
    
    @IBAction func lostItemBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToReportLostItemVC", sender: nil)
        
    }
    
    @IBAction func reportAnotherIssueBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToReportIssueVC", sender: nil)
        
        
    }
    
    ///phone
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "moveToReportLostItemVC"{
            if let destination = segue.destination as? reportLostItem
            {
                
                destination.phone = phone
                
                
            }
            
        } else {
            
            if segue.identifier == "moveToReportIssueVC"{
                
                if let destination = segue.destination as? reportAnotherIssue
                {
                    
                    destination.Trip_key = Trip_key
                    
                    
                }
                
                
            }
            
            
            
            
        }
    }

    @IBAction func tipBtnPressed(_ sender: Any) {
        
        blurView.isHidden = false
        tipView.isHidden = false
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if blurView.isHidden == false {
            
            blurView.isHidden = true
            tipView.isHidden = true
            
        }
        
        
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
}

extension TripDetail: PKPaymentAuthorizationViewControllerDelegate {
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        
        STPAPIClient.shared().createToken(with: payment) { (token, err) in
            
            if (err != nil) {
                self.showErrorAlert("Oops !!!", msg: "This card cannot be used !!!")
                completion(PKPaymentAuthorizationStatus.failure)
                return
            }
            
            var description = ""
            
            let url = MainAPIClient.shared.baseURLString
            let urls = URL(string: url!)?.appendingPathComponent("pre_authorization_apple_pay")
            
            let currentDateTime = Date()
            
            // initialize the date formatter and set the style
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            
            // get the date time String from the date object
            let result = formatter.string(from: currentDateTime)
            
            
            var roundedPrice: Double!
            
            
            if self.tip != 0 {
                
                
                
                let price = Double(self.tip)
                roundedPrice = price.roundTo(places: 2)
                
                roundedPrice = roundedPrice! * 100
                
                
                if let name = self.name {
                    
                    description = "Tip to \(name) from Campus Connect at \(result)"
                } else {
                    
                    description = "Tip to driver from Campus Connect at \(result)"
                    
                }
                
                
                
                
            }
            
            self.capturedKey = ""
            
            
            if let email = try? InformationStorage?.object(ofType: String.self, forKey: "email") {
                
                
                Alamofire.request(urls!, method: .post, parameters: [
                    
                    
                    
                    "cus_id": stripeID,
                    "amount": roundedPrice!,
                    "token": token!,
                    "captured": true,
                    "description": description,
                    "receipt_email": email!,
                    
                    
                    ])
                    
                    .validate(statusCode: 200..<500)
                    .responseJSON { responseJSON in
                        
                        switch responseJSON.result {
                            
                        case .success( _):
                            
                            completion(PKPaymentAuthorizationStatus.success)
                            
                            self.prepare_payDriver(price: roundedPrice!, DriverUID: self.driver_uid!)
                            
                            
                            
                            
                        case .failure( _):
                            
                            
                            completion(PKPaymentAuthorizationStatus.failure)
                            return
                            
                        }
                        
                        
                }
                
            }
            
            
            
            
        }
        
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    
}
