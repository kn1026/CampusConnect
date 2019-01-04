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

class TripDetail: UIViewController {
    
    @IBOutlet weak var timeLbl: UILabel!
    
    @IBOutlet weak var priceLbl: UILabel!
    
    @IBOutlet weak var progressLbl: UILabel!
    
    @IBOutlet weak var last4DigitsLbl: UILabel!
    @IBOutlet weak var brandCard: UIImageView!
    
   
    @IBOutlet weak var pickUpLbl: UILabel!
    
    @IBOutlet weak var destinationLbl: UILabel!
    
    @IBOutlet weak var carRegistrationLbl: UILabel!
    
    @IBOutlet weak var driverImg: borderAvatarView!
    @IBOutlet weak var carModelLbl: UILabel!
    
    
    @IBOutlet weak var driverNameLbl: UILabel!
    
    
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
        priceLbl.text = "$\(self.price!)"
        last4DigitsLbl.text = " •••• \(self.last4Digits!)"
        brandCard.image = UIImage(named: self.brandCards!)
        pickUpLbl.text = self.pickUpName
        destinationLbl.text  = self.destinationName!
        carRegistrationLbl.text = self.carRegistration!
        carModelLbl.text = self.carModel!
        
        
        let fullNameArr = self.name?.components(separatedBy: " ")
        driverNameLbl.text = fullNameArr![0].firstUppercased
        loadDriverImg()
        
 
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

    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func back1BtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
}
