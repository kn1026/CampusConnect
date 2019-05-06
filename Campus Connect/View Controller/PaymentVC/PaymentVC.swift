//
//  PaymentVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/27/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Stripe
import Alamofire
import MGSwipeTableCell
import Firebase
import PassKit


class PaymentVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard, PKPaymentNetwork.amex, PKPaymentNetwork.discover]
    
    var paymentArr = [PaymentModel]()
    var listCard = [PaymentModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if isSelected == true {
            
            self.tableView.allowsSelection = true
            
            isSelected = false
        } else {
            
            
            self.tableView.allowsSelection = false
        }
        
        
        
        
        
        paymentArr.removeAll()
        self.listCard.removeAll()
        
        self.RetrieveCard(cus_id: stripeID)
        
        // load apple pay
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: self.SupportedPaymentNetworks) == true {
            
            self.loadApplePay()
            
        }
        
        
    }
    
    func loadApplePay () {
        
        let paymentInfo: Dictionary<String, AnyObject> = ["Brand": "Apple_pay" as AnyObject]
        
        let PaymentData = PaymentModel(postKey: "Apple_pay", PaymentModel: paymentInfo)
        
        self.paymentArr.append(PaymentData)
        self.tableView.reloadData()
        
    }
    
    func retrieve_promoteCode(completed: @escaping DownloadComplete) {
        
        DataService.instance.mainDataBaseRef.child("Promote_code").child(userUID).observeSingleEvent(of: .value, with: { (promoteCode) in
            
            if promoteCode.exists() {
                
                if let snap = promoteCode.children.allObjects as? [DataSnapshot] {
                    
                    for item in snap {
                        if let postDict = item.value as? Dictionary<String, Any> {
                            
                            let key = promoteCode.key
                            let searchData = PaymentModel(postKey: key, PaymentModel: postDict)
                            self.paymentArr.append(searchData)
                            
                            
                            
                        }
                        
                        self.tableView.reloadData()
                        
                    }
                    
                    completed()
                    
                }
                
                
                
                
            } else {
                
                completed()
                
            }
            
            
            
            
        })
        
        
    }
    
    func load_bank(cus_id: String) {
        
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("customers_bank")
        
        Alamofire.request(urls!, method: .post, parameters: [
            
            "cus_id": cus_id
            
            ])
            
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                
                switch responseJSON.result {
                    
                case .success(let json):
                    
                    if let dict = json as? [String: AnyObject] {
                        
                        for i in dict {
                            
                            if let result = i.value as? [Dictionary<String, AnyObject>] {
                                
                                
                                
                                for x in result {
                                    
                                    let paymentInfo: Dictionary<String, AnyObject> = ["Last4": x["last4"] as AnyObject, "Exp_month": x["exp_month"] as AnyObject, "Brand": x["brand"] as AnyObject, "Id": x["id"] as AnyObject, "Exp_year": x["exp_year"] as AnyObject, "Funding": x["funding"] as AnyObject, "Fingerprint": x["fingerprint"] as AnyObject, "Country": x["country"] as AnyObject]
                                    
                                    let PaymentData = PaymentModel(postKey: x["id"] as! String, PaymentModel: paymentInfo)
                                    
                                    let id = x["id"] as? String
                                    
                                    if id == defaultCardID {
                                        
                                        
                                        self.paymentArr.insert(PaymentData, at: 0)
                                        
                                        
                                    } else {
                                        
                                        self.paymentArr.append(PaymentData)
                                        
                                    }
                                    
                                    
                                    self.listCard.append(PaymentData)
                                    
                                    
                                    self.tableView.reloadData()
                                    
                                    
                                }
                                
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    
                case .failure(let error):
                    
                    print(error)
                    
                }
                
                
                
        }
        
    }

    
    func RetrieveCard(cus_id: String) {
        
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("customers_card")

        Alamofire.request(urls!, method: .post, parameters: [
            
            "cus_id": cus_id
            
            ])
            
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                
            switch responseJSON.result {
                    
                case .success(let json):
                    
                    if let dict = json as? [String: AnyObject] {
                        
                        for i in dict {
                            
                            if let result = i.value as? [Dictionary<String, AnyObject>] {
                                
                                
                               
                                for x in result {
                                    
                                    let paymentInfo: Dictionary<String, AnyObject> = ["Last4": x["last4"] as AnyObject, "Exp_month": x["exp_month"] as AnyObject, "Brand": x["brand"] as AnyObject, "Id": x["id"] as AnyObject, "Exp_year": x["exp_year"] as AnyObject, "Funding": x["funding"] as AnyObject, "Fingerprint": x["fingerprint"] as AnyObject, "Country": x["country"] as AnyObject]
                                    
                                    let PaymentData = PaymentModel(postKey: x["id"] as! String, PaymentModel: paymentInfo)
                                    
                                    let id = x["id"] as? String
                                    
                                    if id == defaultCardID {
                                        
                                        
                                        self.paymentArr.insert(PaymentData, at: 0)
                                        
                                        
                                    } else {
                                        
                                        self.paymentArr.append(PaymentData)
                                        
                                    }
                                    
                                    
                                    self.listCard.append(PaymentData)
                                    
                                    
                                    self.tableView.reloadData()
                                    
                                    
                                }
                                
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    
                case .failure(let error):
                    
                    print(error)
                    
                }
                
                
                
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentArr.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if indexPath.row < paymentArr.count{
            
            
            
            
            let payment = paymentArr[indexPath.row]
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cardCell") as? cardCell {
                
                if indexPath.row > 0 {
                    
                    let lineFrame = CGRect(x:20, y:0, width: Double(self.view.frame.width) - 42, height: 1)
                    let line = UIView(frame: lineFrame)
                    line.backgroundColor = UIColor.groupTableViewBackground
                    cell.addSubview(line)
                    
                } else {
                    
                    if self.listCard.isEmpty != true {
                        
                        cell.defaultImg.isHidden = false
                        
                    }
                    
                    
                }
                cell.delegate = self
                cell.configureCell(payment)
                
                return cell
                
            } else {
                
                return cardCell()
                
            }
            
            
            
        } else{ 
            
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "addNewPaymentCell") as? addNewPaymentCell {

                cell.addCardBtn.addTarget(self, action: #selector(PaymentVC.addCardBtnPressed), for: .touchUpInside)
                return cell
                
                
            } else {
                
                return addNewPaymentCell()
                
            }
            
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = paymentArr[indexPath.row]
        
        
        chargedCardID = card.Id
        cardBrand = card.Brand
        cardLast4Digits = card.Last4
        
        
        
        chargedlast4Digit = card.Last4
        chargedCardBrand = card.Brand
        
        NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "setPayment")), object: nil)
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func swipeTableCell(_ cell: MGSwipeTableCell, canSwipe direction: MGSwipeDirection) -> Bool {
        return true;
    }
    
    
    
    @objc func addCardBtnPressed() {
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(PaymentVC.refreshPayment), name: (NSNotification.Name(rawValue: "refreshPayment")), object: nil)
        self.performSegue(withIdentifier: "moveTochoosePaymentVC", sender: nil)
        
        
    }
    

    
    
    func swipeTableCell(_ cell: MGSwipeTableCell, swipeButtonsFor direction: MGSwipeDirection, swipeSettings: MGSwipeSettings, expansionSettings: MGSwipeExpansionSettings) -> [UIView]? {
        
        swipeSettings.transition = MGSwipeTransition.border;
        expansionSettings.buttonIndex = 0
        let defaultcolor = UIColor.black
        let removedColor = UIColor.red
        let padding = 7
        if direction == MGSwipeDirection.rightToLeft {
            expansionSettings.fillOnTrigger = false;
            expansionSettings.threshold = 1.1
            
            
            let remove = MGSwipeButton(title: "Remove", backgroundColor: removedColor, padding: padding,  callback: { (cell) -> Bool in
                
                
                
                self.deleteAtIndexPath(self.tableView.indexPath(for: cell)!)
                
                return false; //don't autohide to improve delete animation
            });
            
            
            
            let defaults = MGSwipeButton(title: "Default", backgroundColor: defaultcolor, padding: padding, callback: { (cell) -> Bool in
                
              
                self.defaultAtIndexPath(self.tableView.indexPath(for: cell)!)
                
                return false; //autohide
            });
            
            return [defaults, remove]
        } else {
            
            return nil
        }
        
        
        
        
    }
    
     func defaultAtIndexPath(_ path: IndexPath) {
        
        
        
        
        
        
        let card = paymentArr[path.row]
        
        
        if defaultCardID != card.Id {
            
            
            if card.Brand != "Promote_code" ||  card.Brand != "Apple_pay" {
                
                
                swiftLoader()
                
                let url = MainAPIClient.shared.baseURLString
                let urls = URL(string: url!)?.appendingPathComponent("set_default")
                
                Alamofire.request(urls!, method: .post, parameters: [
                    
                    "Card_Id": card.Id!,
                    "cus_id": stripeID,
                    
                    ])
                    
                    .validate(statusCode: 200..<500)
                    .responseJSON { responseJSON in
                        
                        switch responseJSON.result {
                            
                        case .success( _):
                            
                            
                            SwiftLoader.hide()
                            defaultCardID = card.Id
                            defaultcardLast4Digits = card.Last4
                            defaultBrand = card.Brand
                            self.paymentArr.remove(at: (path as NSIndexPath).row)
                            self.paymentArr.insert(card, at: 0)
                            self.tableView.reloadData()
                            
                            
                            
                        case .failure(let error):
                            
                            SwiftLoader.hide()
                            self.showErrorAlert("Oops !!!", msg: error.localizedDescription)
                            
                            
                        }
                        
                }
                
                
            } else {
                
                
                self.showErrorAlert("Oops !!!", msg: "Cannot default your free ride or your Apple pay")
                
                
            }
            
            
            
            
            
        } else {
            
            
            self.showErrorAlert("Oops !!!", msg: "This is already your default card ")
            
            
        }
        
        
        
    
        
        
        
        
    }
    
    
    func deleteAtIndexPath(_ path: IndexPath) {
        
        
        
        
        
        
        
        let card = paymentArr[path.row]
        
        if card.Brand != "Promote_code" || card.Brand != "Apple_pay" {
            
            swiftLoader()
            
            let url = MainAPIClient.shared.baseURLString
            let urls = URL(string: url!)?.appendingPathComponent("delete_card")
            
            
            Alamofire.request(urls!, method: .post, parameters: [
                
                "Card_Id": card.Id!,
                "cus_id": stripeID,
                
                ])
                
                .validate(statusCode: 200..<500)
                .responseJSON { responseJSON in
                    
                    switch responseJSON.result {
                        
                    case .success( _):
                        
                        SwiftLoader.hide()
                        let fingerPrint = card.Fingerprint
                        DataService.instance.mainDataBaseRef.child("fingerPrint").child(userUID).child(fingerPrint!).removeValue()
                        self.paymentArr.remove(at: (path as NSIndexPath).row)
                        self.tableView.deleteRows(at: [path], with: .left)
                        
                        if defaultCardID == card.Id {
                            
                        
                            if self.paymentArr.isEmpty != true {
                                
                                let next = self.paymentArr[0]
                                
                                if next.Brand != "Promote_code" {
                                    
                                    defaultCardID = next.Id
                                    self.tableView.reloadData()
                                    
                                }
                                
                                
                                
                            }
                            
                         
                        }
                        
                       
                        
                    case .failure(let error):
                        SwiftLoader.hide()
                        self.showErrorAlert("Oops !!!", msg: error.localizedDescription)
                        
                    }
                    
                    
                    
            }
            
        } else {
            
            SwiftLoader.hide()
            self.showErrorAlert("Oops !!!", msg: "Cannot remove your free ride or your Apple pay")
            
            
        }
        
        
        
        
        
        
        
    }
    
    @objc func refreshPayment() {
        
        NotificationCenter.default.removeObserver(self, name: (NSNotification.Name(rawValue: "refreshPayment")), object: nil)
        paymentArr.removeAll()
        self.listCard.removeAll()
        self.RetrieveCard(cus_id: stripeID)
        self.retrieve_promoteCode() {
            
            // load apple pay
            if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: self.SupportedPaymentNetworks) == true {
                
                self.loadApplePay()
                
            }
            
        }
        
        
    }
    

    @IBAction func backBtn1Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func backBtn2Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        
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
    
}
