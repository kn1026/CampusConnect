//
//  MapView.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/19/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Foundation
import GoogleMaps
import GooglePlaces
import Firebase
import MapKit
import Pulsator
import Alamofire
import SwiftyJSON
import Cache
import SafariServices
import GeoFire
import Stripe
import UserNotifications
import KDCircularProgress
import AVFoundation
import PassKit
import SCLAlertView
import JDropDownAlert


class MapView: UIViewController, GMSMapViewDelegate, UITextViewDelegate, UNUserNotificationCenterDelegate {
    
    
    var Driver_Tip_name: String?
    
    @IBOutlet weak var introView: UIView!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var bookStack: UIStackView!
    @IBOutlet weak var NoneDollarTip: UIButton!
    @IBOutlet weak var FiveDollarTip: UIButton!
    @IBOutlet weak var TwoDollarTip: UIButton!
    @IBOutlet weak var OneDollarTip: UIButton!
    @IBOutlet weak var LeaveTipLbl: UILabel!
    @IBOutlet weak var driverRateCount: UILabel!
    
    @IBOutlet weak var rateProfile: UILabel!
    var tapGesture: UITapGestureRecognizer!
    var acceptBookCar = false
    var handelCancelFromDriver: UInt?
    var handelCancelFromRider: UInt?
    
    @IBOutlet weak var DriverMessage: UILabel!
    @IBOutlet weak var BookCarBtn: UIButton!
    
    
    @IBOutlet weak var InfoViewLbl: UIView!
    @IBOutlet weak var OffCampusFareLbl: UILabel!
    @IBOutlet weak var OnCampusFareLbl: UILabel!
    //@IBOutlet weak var restaurantView: UIView!
    //@IBOutlet weak var restaurantTrailing: NSLayoutConstraint!
    var rateCount = 0
    
    var animted = false
    var tip = 0
    var isTip = false
    let locationarray = NSMutableArray()
    
    @IBOutlet weak var becomeADriverBtn: UIButton!
    @IBOutlet weak var locationBtn: UIButton!
    @IBOutlet weak var mainNameLbl: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingTitle: UILabel!
    @IBOutlet weak var star1: UIButton!
    @IBOutlet weak var star2: UIButton!
    @IBOutlet weak var star3: UIButton!
    @IBOutlet weak var star4: UIButton!
    @IBOutlet weak var star5: UIButton!
    @IBOutlet weak var ratingText: CommentTxtView!
    
    var DriverEta: String?
    var TripRiderResult: Rider_trip_model!
    var tripDriverReuslt: Driver_trip_model!
    var trip_key: String?
    var trip_key_created = ""
    var navigationCoordinate: CLLocationCoordinate2D!
    
    var rate_driver_uid: String?
    var recent_reject_uid: String?
    
    
    var IsSendMess = false
    var IsDeliverMess = false
    
    
    @IBOutlet weak var mapViewTopConstraint: NSLayoutConstraint!
    
    var onDemandDriverID: String?
    
    
    @IBOutlet weak var requestDriverImg: borderAvatarView!
    @IBOutlet weak var RequestDriverName: UILabel!
    @IBOutlet weak var RequestDriverCarRegistraton: UILabel!
    @IBOutlet weak var requestDriverCarModel: UILabel!
    
    
    
    @IBOutlet weak var userImageView: UIImageView!
    
    
    var driverLocation = CLLocationCoordinate2D()
    var driverMarker = GMSMarker()
    var progress: KDCircularProgress!
    
    var current_request_trip_key = ""
    var current_request_trip_uid = ""
    
    
    
    var authorize = false
    var capturedKey = ""
    
    
    var Rider_handle: UInt?
    var Driver_handle: UInt?
    var rider_trip_coordinator_handle: UInt?
    var completed_trip_handle: UInt?
    
    
    
    
    
    var isConnected = false
    
    @IBOutlet weak var carPrice: UILabel!
    @IBOutlet weak var last4CC: UILabel!
    @IBOutlet weak var cardImg: UIImageView!
    
    @IBOutlet weak var alertLbl: UILabel!
    var listCampus = [String]()
    var listDriver = [String]()
    var listRecentDriver = [String]()
    
    
    @IBOutlet weak var alertView: UIView!
    
    var eta = ""
    @IBOutlet weak var riderView: UIView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var proportionOfPeople: UILabel!
    
    
    @IBOutlet weak var codeLbl: UITextField!
    
    @IBOutlet weak var carChosenImg: UIImageView!
    
    
    
  
    @IBOutlet weak var TotalriderView: UIView!
    
    
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var bookCarView: bookCarView!
    @IBOutlet weak var destinationBtn: fancyBtn!
    
    @IBOutlet weak var mapViewBottomConstraint: NSLayoutConstraint!
    
    var polyline = GMSPolyline()
    var animationPolyline = GMSPolyline()
    var path = GMSPath()
    
    @IBOutlet weak var closeRequestBtn2: UIButton!
    @IBOutlet weak var closeRequestBtn1: UIButton!
    
    var placesClient = GMSPlacesClient()
    var panHandle = false
    @IBOutlet weak var closeProfileBtn2: UIButton!
    @IBOutlet weak var animated2Btn: UIButton!
    @IBOutlet weak var helpBtn: UIButton!
    @IBOutlet weak var reportBtn: UIButton!
    @IBOutlet weak var aboutUsBtn: UIButton!
    @IBOutlet weak var historyBtn: UIButton!
    @IBOutlet weak var paymentBtn: UIButton!
    @IBOutlet weak var promoteCodeTxtField: UITextField!
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var closeProfileBtn: UIButton!
    @IBOutlet weak var animatedBtn: UIButton!
    @IBOutlet weak var signOutBtn: UIButton!
    @IBOutlet weak var trailingWheel: NSLayoutConstraint!
    
    
    var isFirst = false
    
    // drag View
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var avatarView: UIView!
    
    private var dragViewAnimatedTopMargin:CGFloat = 0.0 // View fully visible (upper spacing)
    private var viewDefaultHeight:CGFloat = 50.0// View height when appear
    private var gestureRecognizer = UIPanGestureRecognizer()
    private var dragViewDefaultTopMargin:CGFloat!
    private var viewLastYPosition = 0.0
    
    
    var movingKey = ""
    var movingUID = ""
    
    
    @IBOutlet weak var menuView: UIView!
    var marker = GMSMarker()
    var circle = GMSCircle()
    
    
    let pulsator = Pulsator()
    
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    var localLocation: CLLocation!
    
    
    
    var visibleRegion = GMSVisibleRegion()
    var bounds = GMSCoordinateBounds()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard Auth.auth().currentUser != nil else {
            
            //DataService.instance.mainDataBaseRef.removeAllObservers()
            
            return
            
        }
        
        if (try? InformationStorage?.object(ofType: String.self, forKey: "phone")) == nil{
            
            
            return
            
        }
        
        if let emails = try? InformationStorage?.object(ofType: String.self, forKey: "email") {
            
            if emails != Auth.auth().currentUser?.email {
                
                Auth.auth().currentUser?.updateEmail(to: emails!, completion: { (err) in
                    
                    if err != nil {
                        
                        
                        self.performSegue(withIdentifier: "GoBackToSignIn", sender: nil)
                        
                    }
                    
                    return
                    
                })
                
                
            }
            
            
        }
        
        tapGesture = UITapGestureRecognizer(target: self, action:#selector(MapView.closeKeyboard))
        LocalNotification.registerForLocalNotification(on: UIApplication.shared)
        ratingText.delegate = self
        
        // profile
        
        let screenSize: CGRect = UIScreen.main.bounds
        dragViewDefaultTopMargin = screenSize.height - viewDefaultHeight
        
        mapView.delegate = self
        
        userType = ""
        
        // Do any additional setup after loading the view.
        
        
        locationManager.delegate = self
        
        
        styleMap()
        configureLocationServices()
        check_server_maintenance()
        
        //setupDefaultMap()
        
        
        gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.menuView.addGestureRecognizer(gestureRecognizer)
        
        
        trailingWheel.constant = self.view.frame.width * (56/375)
        //restaurantTrailing.constant = self.view.frame.width * (30/320)
        
        // align btn text
        setAlignmentForBnt()
        //checkConnection()
        
        promoteCodeTxtField.layer.borderColor = UIColor.black.cgColor
        promoteCodeTxtField.layer.borderWidth = 2.0
        promoteCodeTxtField.layer.cornerRadius = 2.0
        
        
        pulsator.radius = 25
        pulsator.backgroundColor = UIColor(red: 0, green: 0.455, blue: 0.756, alpha: 1).cgColor
        
        
        self.menuView.translatesAutoresizingMaskIntoConstraints = true
        
        userUID = (Auth.auth().currentUser?.uid)!
        
        checkIfAccountRemove()
        
        if let cus_id = try? InformationStorage?.object(ofType: String.self, forKey: "stripe_cus") {
            
            if cus_id != "nil" {
                
                
                stripeID = cus_id!
                
                self.retrieveDefaultCard(cus_id: cus_id!)
                
                
                
            }
            
            
        }
        
        checkCampusDistance()
        checkIfRiderIsInProgress()
        
        //checkDriverApplication()
        
        Messaging.messaging().subscribe(toTopic: "Campus Connect") { error in
            
            if error != nil {
                print(error.debugDescription)
            } else {
                print("Subscribed to cc topic")
            }
            
        }
        
    }
    
    
    
    func check_if_notice_needed() {
        
        
        DataService.instance.mainDataBaseRef.child("Request_driver").observeSingleEvent(of: .value, with: { (RateData) in
            
            if RateData.exists() {
                
                
                if let dict = RateData.value as? Dictionary<String, Any> {
                    
                    
                    if let RateGet = dict["TimeStamp"] as? Double {
                        
                        let timestamps = Double(NSDate().timeIntervalSince1970 * 1000)
                        let change = timestamps - RateGet
                        
                       
                        
                        if let Count = dict["Time"] as? Int {
                            
                            if Count == 9, change < 3600 {
                                
                                
                                
                                DataService.instance.mainDataBaseRef.child("Request_driver").setValue(["Time": 1, "TimeStamp": ServerValue.timestamp()])
                                
                                self.send_driver_online()
                                
                            } else {
                                
                                let count = Count + 1
                                
                                
                                DataService.instance.mainDataBaseRef.child("Request_driver").setValue(["Time": count, "TimeStamp": ServerValue.timestamp()])
                                
                                
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
                
                
            } else {
                
                
                DataService.instance.mainDataBaseRef.child("Request_driver").setValue(["Time": 1, "TimeStamp": ServerValue.timestamp()])
                
                
            }
            
        })
        
        
        
        
    }

    func send_driver_online() {
        
        Database.database().reference().child("Campus-Connect").child("Request_noti").removeValue()
        
    Database.database().reference().child("Campus-Connect").child("Request_noti").child("sdkjhf7823642").setValue(["sdkjhf7823642":"sdkjhf7823642"])
        
        
    }
    
    func loadMyRate() {
        
        
        DataService.instance.mainDataBaseRef.child("Average_Rate").child("Rider").child(userUID).observeSingleEvent(of: .value, with: { (RateData) in
            
            if RateData.exists() {
                
                
                if let dict = RateData.value as? Dictionary<String, Any> {
                    
                    
                    if let RateGet = dict["Rate"] as? Float {
                        
                        
                        
                        self.rateProfile.text = String(format:"%.1f", RateGet)
                        
                    }
                    
                    
                }
                
                
            } else {
                
                self.rateProfile.text = ""
                
                
            }
            
            
        })
        
        
    }
    
    
    @objc func closeKeyboard() {
        
        self.view.removeGestureRecognizer(tapGesture)
        
        self.view.endEditing(true)
        
    }
    
    func checkDriverApplication() {
        
        
        //becomeADriverBtn
        
        
        DataService.instance.mainDataBaseRef.child("Application_Request").child("New").child(userUID).observeSingleEvent(of: .value, with: { (new) in
            
            
            if new.exists() {
                
                self.becomeADriverBtn.setTitle("Being processed", for: .normal)
                self.DriverMessage.text = "You driver's application is being processed"
                
                
            } else {
                
                DataService.instance.mainDataBaseRef.child("Application_Request").child("Accepted").child(userUID).observeSingleEvent(of: .value, with: { (Accepted) in
                    
                    
                    if Accepted.exists() {
                        
                        
                        self.becomeADriverBtn.setTitle("Go to driver app", for: .normal)
                        self.DriverMessage.text = "Welcome to CC-Driver"
                        
                        
                    } else {
                        
                        
                        self.becomeADriverBtn.setTitle("Become a driver", for: .normal)
                        self.DriverMessage.text = "Want to make up to $20 an hour?"
                        
                        
                    }
                    
                    
                })
                
                
                
                
            }
            
            
            
        })
        
        
        
        
    }
    
    
    
    // check signal and send local notification
    func observeSingalCheck(driverUID: String, key: String) {
        
        DataService.instance.mainDataBaseRef.child("Ride_Signal_Check").child(key).child(userUID).child("Request").observe(.value, with: { (request) in
            
            if request.exists() {
                
                DataService.instance.mainDataBaseRef.child("Ride_Signal_Check").child(key).child(userUID).child("Request").removeAllObservers()
                DataService.instance.mainDataBaseRef.child("Ride_Signal_Check").child(key).child(userUID).child("Request").removeValue()
                
                
                DataService.instance.mainDataBaseRef.child("Ride_Signal_Check").child(key).child(userUID).child("Response").setValue(["Response": 1])
                
                
                self.loadLocalNotification(driverUID: driverUID, key: key)
                
            }
            
            
            
        })
        
        
    }
    
    
    func loadLocalNotification(driverUID: String, key: String) {
        
        
        
        DataService.instance.mainDataBaseRef.child("On_Trip_Driver_coordinator").child(driverUID).child(key).observeSingleEvent(of: .value, with: { (DriverCoor ) in
            
            if let coor = DriverCoor.value as? Dictionary<String, Any> {
                
                let des = CLLocation(latitude: coor["Lat"] as! CLLocationDegrees, longitude: coor["Lon"] as! CLLocationDegrees)
                
                let coors = CLLocation(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
                
                
                
                
                let distance = self.calculateDistanceBetweenTwoCoordinator(baseLocation: coors, destinationLocation: des)
                
                
                if distance < 1.0 {
                    
                    if self.IsSendMess == false {
                        
                        let sms = "You driver is about \(round(distance * 100) / 100) miles away, please prepare soon"
                        
                        LocalNotification.dispatchlocalNotification(with: "Notice!", body: sms)
                        self.IsSendMess = true
                        
                    } else {
                        
                        if distance < 0.2 {
                            
                            if self.IsDeliverMess == false {
                                
                                let sms = "You driver is here !!!"
                                
                                LocalNotification.dispatchlocalNotification(with: "Notice!", body: sms)
                                
                                self.IsDeliverMess = true
                                
                            }
                            
                            
                        }
                        
                        
                    }
                }
                
                
            }
            
        })
        
        
        
        
        
    }
    
    func checkIfRiderStilOnTrip() {
        
        
        
        DataService.instance.mainDataBaseRef.child("On_Trip_arrived").child("Rider").child(userUID).observeSingleEvent(of: .value, with: { (Rate) in
            
            
            if Rate.exists() {
                
                
                self.centerMapDuringTrip()
                self.destinationBtn.isHidden = true
                
            } else {
                
                self.destinationBtn.isHidden = false
                self.centerMapOnUserLocation()
                
                
            }
            
            
            
        })
        
        
        
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
                        
                    }
                    
                    
                    
                    
                case .failure( _):
                    
                    
                    
                    self.showErrorAlert("Oops !!!", msg: "Due to some unknown errors, we can't completely process your transaction. Please contact us to solve the issue")
                    
                }
                
                
        }
        
        
    }
    
    
    
    
    func checkIfRiderRateForRide() {
        
        
        
        DataService.instance.mainDataBaseRef.child("Missing_Rate").child("Rider").child(userUID).observeSingleEvent(of: .value, with: { (Rate) in
            
            
            if Rate.exists() {
                
                
                if let dict = Rate.value as? Dictionary<String, Any> {
                    
                    
                    if let Trip_key = dict["Trip_key"] as? String {
                        
                        
                        if let Driver_UID = dict["Driver_UID"] as? String {
                            
                            if let Driver_Name = dict["Driver_Name"] as? String {
                                
                                self.trip_key = Trip_key
                                self.rate_driver_uid = Driver_UID
                                self.LeaveTipLbl.text = "Leave tip for \(Driver_Name)"
                                self.Driver_Tip_name = Driver_Name
                                self.updateUIForRating()
                                
                            }
                            
                            
                            
                            
                        }
                        
                        
                    }
                    
                    
                    
                }
                
                
            } else {
                
                
                //print("Rated all already")
                
                
            }
            
            
            
        })
        
        
        
    }
    
    
    
    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    
        
        if (try? InformationStorage?.object(ofType: String.self, forKey: "phone")) == nil{
            
            self.performSegue(withIdentifier: "GoBackToSignIn", sender: nil)
            return
            
        }
        
        
        if marker.iconView != nil  {
            
            pulsator.start()
            
        }
        
        if isFirst == false {
            
            self.menuView.layer.cornerRadius = 60.0
            self.menuView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 50.0, width:  UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            
            
            isFirst = true
            
            
        }
        
        
        if let name = try? InformationStorage?.object(ofType: String.self, forKey: "user_name") {
            
            mainNameLbl.text = name
            
            
        }
        
        if let CacheavatarImg = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: "avatarImg").image {
            
            userImageView.isHidden = false
            userImageView.image = CacheavatarImg
            
        }
        
        
        checkConnection()
        checkDriverApplication()
        checkIfRiderRateForRide()
        loadMyRate()
        
        
        delay(1.0) { () -> () in
            
            
            
            self.introView.isHidden = true
            
        }
        
        

        
        
    }
    
    
    @IBAction func DashboardBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        pulsator.stop()
        
    }
    
    
    

    
    
    
    
    func checkConnection() {
        
        DataService.instance.connectedRef.observe(.value, with: { snapShot in
            if let connected = snapShot.value as? Bool, connected {
                
                self.alertView.isHidden = true
                
                self.isConnected = true
                
                if self.bookCarView.isHidden != true || self.riderView.isHidden != true {
                    
                    self.destinationBtn.isHidden = true
                    
                } else {
                    
                    self.destinationBtn.isHidden = false
                    
                }
                
                if self.bookCarView.isHidden != true {
                    
                    
                    if self.statusLbl.text != "Out of range" {
                        
                        self.checkForDriverAround()
                        
                    }
                    
                    
                    
                }
                
                
                
            } else {
                
                self.alertView.backgroundColor = UIColor.red
                self.alertLbl.text = "No connection"
                self.alertLbl.textColor = UIColor.white
                self.alertView.isHidden = false
                self.destinationBtn.isHidden = true
                self.isConnected = false
                
                if self.bookCarView.isHidden != true {
                    
                    self.bookStack.isHidden = true
                    self.statusLbl.isHidden = false
                    self.statusLbl.text = "NO CONNECTION"
                    
                    
                }
                
                
            }
            
        })
        
    }
    
    func checkIfRiderIsInProgress() {
        
        DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Rider").child(userUID).observeSingleEvent(of: .value, with: { (Data) in
            
            
            if Data.exists() {
                
                if let dict = Data.value as? Dictionary<String, Any> {
                    
                    
                    if let key = dict["Trip_key"] as? String {
                        
                        if let Driver_UID = dict["Driver_UID"] as? String {
                            
                            
                            DataService.instance.mainDataBaseRef.child("Trip_request").child(userUID).child(key).observeSingleEvent(of: .value, with: { (TripData) in
                                
                                
                                if TripData.exists() {
                                    
                                    if let tripDict = TripData.value as? Dictionary<String, AnyObject> {
                                        
                                        self.destinationBtn.isHidden = true
                                        
                                        let TripDataResult = Rider_trip_model(postKey: TripData.key, Rider_trip_model: tripDict)
                                        
                                        self.TripRiderResult = TripDataResult
                                        
                                        pickUpLocation = CLLocationCoordinate2D(latitude: self.TripRiderResult.PickUp_Lat, longitude: self.TripRiderResult.PickUp_Lon)
                                        DestinationLocation = CLLocationCoordinate2D(latitude: self.TripRiderResult.Destination_Lat, longitude: self.TripRiderResult.Destination_Lon)
                                        
                                        
                                        DataService.instance.mainDataBaseRef.child("Driver_Info").child(Driver_UID).observeSingleEvent(of: .value, with: { (DriverData) in
                                            
                                            
                                            if let DriverDict = DriverData.value as? Dictionary<String, Any> {
                                                
                                                let TripDataResult = Driver_trip_model(postKey: DriverData.key, Driver_trip_model: DriverDict)
                                                
                                                self.tripDriverReuslt = TripDataResult
                                                self.trip_key = key
                                                
                                                
                                                DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Rider").child(userUID).setValue(["Timestamp": ServerValue.timestamp(), "Trip_key": self.trip_key!, "Driver_UID": self.tripDriverReuslt.UID, "Rider_UID": userUID])
                                                
                                                DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Driver").child(self.tripDriverReuslt.UID).setValue(["Timestamp": ServerValue.timestamp(), "Trip_key": self.trip_key!, "Driver_UID": self.tripDriverReuslt.UID, "Rider_UID": userUID])
                                                
                                                DataService.instance.mainDataBaseRef.child("Trip_request").child(userUID).child(key).observeSingleEvent(of: .value, with: { (TripHistory) in
                                                    
                                                    
                                                    if let TripDict = TripHistory.value as? Dictionary<String, Any> {
                                                        
                                                        
                                                        
                                                        DataService.instance.mainDataBaseRef.child("Trip_History").child("Rider").child(userUID).child(key).setValue(TripDict)
                                                        DataService.instance.mainDataBaseRef.child("Trip_History").child("Rider").child(userUID).child(key).updateChildValues(["Progess": "On progress"])
                                                        
                                                        DataService.instance.mainDataBaseRef.child("Trip_History").child("Rider").child(userUID).child(key).updateChildValues(DriverDict)
                                                        
                                                        
                                                        
                                                        DataService.instance.mainDataBaseRef.child("Trip_History").child("Driver").child(Driver_UID).child(key).setValue(TripDict)
                                                        DataService.instance.mainDataBaseRef.child("Trip_History").child("Driver").child(Driver_UID).child(key).updateChildValues(["Progess": "On progress"])
                                                        
                                                        DataService.instance.mainDataBaseRef.child("Trip_History").child("Driver").child(Driver_UID).child(key).updateChildValues(DriverDict)
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                })
                                                
                                                
                                                
                                                
                                                
                                                
                                                self.assignDriver(DriverData: TripDataResult, key: key)
                                                
                                                
                                            }
                                            
                                            
                                        })
                                        
                                        
                                    }
                                    
                                }
                                
                            })
                            
                            
                            
                        }
                        
                    }
                    
                    
                }
                
                
            } else {
                
                
                DataService.instance.mainDataBaseRef.child("On_Trip_arrived").child("Rider").child(userUID).observeSingleEvent(of: .value, with: { (arrived) in
                    
                    
                    
                    if arrived.exists() {
                        
                        
                        if let dict = arrived.value as? Dictionary<String, Any> {
                            
                            if let key = dict["Trip_key"] as? String {
                                
                                if let Driver_UID = dict["Driver_UID"] as? String {
                                    
                                    DataService.instance.mainDataBaseRef.child("Trip_request").child(userUID).child(key).observeSingleEvent(of: .value, with: { (TripData) in
                                        
                                        
                                        if TripData.exists() {
                                            
                                            
                                            self.destinationBtn.isHidden = true
                                            
                                            if let tripDict = TripData.value as? Dictionary<String, AnyObject> {
                                                
                                                
                                                let TripDataResult = Rider_trip_model(postKey: TripData.key, Rider_trip_model: tripDict)
                                                
                                                self.TripRiderResult = TripDataResult
                                                
                                                pickUpLocation = CLLocationCoordinate2D(latitude: self.TripRiderResult.PickUp_Lat, longitude: self.TripRiderResult.PickUp_Lon)
                                                DestinationLocation = CLLocationCoordinate2D(latitude: self.TripRiderResult.Destination_Lat, longitude: self.TripRiderResult.Destination_Lon)
                                                
                                                
                                                DataService.instance.mainDataBaseRef.child("Driver_Info").child(Driver_UID).observeSingleEvent(of: .value, with: { (DriverData) in
                                                    
                                                    
                                                    if let DriverDict = DriverData.value as? Dictionary<String, Any> {
                                                        
                                                        let TripDataResult = Driver_trip_model(postKey: DriverData.key, Driver_trip_model: DriverDict)
                                                        
                                                        self.tripDriverReuslt = TripDataResult
                                                        self.trip_key = key
                                                        
                                                        
                                                        self.riderView.isHidden = true
 
                                                        DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Rider").child(userUID).removeValue()
                                                        DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Driver").child(self.tripDriverReuslt.UID).removeValue()
                                                        
                                                        
                                                        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                                                            
                                                            
                                                            self.mapViewBottomConstraint.constant = 0.0
                                                            self.riderView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: self.bookCarView.frame.width, height: self.bookCarView.frame.height)
                                                            
                                                            
                                                            
                                                        }), completion:  { (finished: Bool) in
                                                            
                                                            
                                                            
                                                            
                                                        })
                                                        
                                                        
                                                        //DataService.instance.mainDataBaseRef.child("On_Trip_Driver_coordinator").child(UID).child(key).removeObserver(withHandle: self.rider_trip_coordinator_handle!)
                                                        //DataService.instance.mainDataBaseRef.child("trip_progressed").child(userUID).child(key).removeObserver(withHandle: self.completed_trip_handle!)
                                                        
                                                        
                                                        let Mylocation =  CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
                                                        
                                                        self.locationManager.startUpdatingLocation()
                                                        
                                                        self.driverMarker.map = nil
                                                        self.drawDirection(pickup: Mylocation, destination: DestinationLocation) {
                                                            
                                                            self.locationManager.startUpdatingLocation()
                                                            self.fitAllMarkers(_path: self.path)
                                                            
                                                        }
                                                        
                                                        
                                                        
                                                        
                                                    }
                                                    
                                                    
                                                })
                                                
                                                
                                            }
                                            
                                        }
                                        
                                    })
                                    
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                        }
                        
                        
                        
                        
                    } else {
                        
                        //print("Not in any progress")
                        
                    }
                    
                    
                })
                
            }
            
            
            
        })
        
        
        
    }
    
    
    func retrieveDefaultCard(cus_id: String) {
        
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("default_card")
        
        Alamofire.request(urls!, method: .post, parameters: [
            
            "cus_id": cus_id
            
            ])
            
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                
                switch responseJSON.result {
                    
                case .success(let json):
                    
                    if let dict = json as? [String: AnyObject] {
                        
                        if let defaults = dict["default_source"] as? String {
                            
                            defaultCardID = defaults
                            chargedCardID = defaultCardID
                            
                        }
                        
                        
                        if let sources = dict["sources"] as? Dictionary<String, AnyObject> {
                            
                            if let cardArr = sources["data"] as? [Dictionary<String, AnyObject>] {
                                
                                
                                if cardArr.isEmpty != true {
                                    
                                    
                                    if let last4 = cardArr[0]["last4"] as? String {
                                        
                                        defaultcardLast4Digits = last4
                                        chargedlast4Digit = defaultcardLast4Digits
                                        
                                        
                                    }
                                    
                                    if let brand = cardArr[0]["brand"] as? String {
                                        
                                        defaultBrand = brand
                                        chargedCardBrand = defaultBrand
                                        
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
    
    @IBAction func infoBtnPressed(_ sender: Any) {
        
        if InfoViewLbl.isHidden == true {
            InfoViewLbl.isHidden = false
        }
        
    }
    
    
    @IBAction func DoneInfoBtnPressed(_ sender: Any) {
        
        if InfoViewLbl.isHidden == false {
            InfoViewLbl.isHidden = true
        }
        
        
    }
    @IBAction func openSearchController(_ sender: Any) {
        
        
        checkCampusAgainWhenSearch()
        
    }
    
    
    @objc func getDirection() {
        
        
        acceptBookCar = false
        self.bookStack.isHidden = true
        self.statusLbl.isHidden = true
        
        
        NotificationCenter.default.removeObserver(self, name: (NSNotification.Name(rawValue: "GetRide")), object: nil)
        
        closeRequestBtn2.isHidden = false
        closeRequestBtn1.isHidden = false
        InfoViewLbl.isHidden = true
        bookCarView.isHidden = false
        destinationBtn.isHidden = true
        
        
        
        last4CC.text = defaultcardLast4Digits
        cardImg.image = UIImage(named: defaultBrand)
        
        
        
        let drag = 350
        
        
        let pickUp = CLLocation(latitude: pickUpLocation.latitude, longitude: pickUpLocation.longitude)
        let des = CLLocation(latitude: DestinationLocation.latitude, longitude: DestinationLocation.longitude)
        
        let distance = calculateDistanceBetweenTwoCoordinator(baseLocation: pickUp, destinationLocation: des)
        
        if distance > 10 {
            
            acceptBookCar = false
            
        } else {
            
            
            acceptBookCar = true
            
            
        }
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            
            self.mapViewBottomConstraint.constant = CGFloat(drag)
            self.bookCarView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 370, width: self.bookCarView.frame.width, height: self.bookCarView.frame.height)
            
        }), completion:  { (finished: Bool) in
            
            self.drawDirection(pickup: pickUpLocation, destination: DestinationLocation) {
                
                self.fitAllMarkers(_path: self.path)
                
            }
            
        })
        
        
    }
    
    
    func closeRideMode() {
        
        
        
        closeRequestBtn2.isHidden = true
        closeRequestBtn1.isHidden = true
        self.bookCarView.isHidden = true
        self.destinationBtn.isHidden = false
        
        self.pulsator.stop()
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            
            self.mapViewBottomConstraint.constant = 0.0
            self.bookCarView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: self.bookCarView.frame.width, height: self.bookCarView.frame.height)
            
            
        }), completion:  { (finished: Bool) in
            
            
            self.centerMapOnUserLocation()
            
            
        })
        
        
        
    }
    
    
    
    func drawDirection(pickup: CLLocationCoordinate2D, destination: CLLocationCoordinate2D, completed: @escaping DownloadComplete) {
        
        let origin = "\(pickup.latitude),\(pickup.longitude)"
        let destinations = "\(destination.latitude),\(destination.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destinations)&mode=driving&sensor=true&key=\(googleMap_Key)"
        
        
        self.polyline.map = nil
        
        
        Alamofire.request(url).responseJSON { response in
            
            let json = try! JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            
            if let dict = response.value as? Dictionary<String, AnyObject> {
                
                if let result = dict["routes"] as? [Dictionary<String, AnyObject>] {
                    
                    for i in result {
                        
                        if let x = i["legs"] as? [Dictionary<String, AnyObject>] {
                            
                            for y in x {
                                
                                if let z = y["duration"] as? Dictionary<String, AnyObject> {
                                    
                                    self.eta = (z["text"] as? String)!
                                    
                                }
                                
                                if let d = y["distance"] as? Dictionary<String, AnyObject> {
                                    
                                    let val = (d["text"] as? String)!
                                    
                                    
                                    var isDistance = false
                                    var FinalDistance = [String]()
                                    let testDistancelArr = Array(val)
                                    
                                    for i in testDistancelArr  {
                                        
                                        if isDistance == false {
                                            if i == " "{
                                                
                                                isDistance = true
                                                
                                            } else {
                                                
                                                let num = String(i)
                                                FinalDistance.append(num)
                                                
                                            }
                                        }
                                        
                                    }
                                    
                                    let distance = String(FinalDistance.joined())
                                    finalDistance = distance
                                    if let result = Float(distance) {
                                        
                                        
                                        if result > 10 {
                                            
                                          self.carPrice.text = "$0.00"
                                            self.OnCampusFareLbl.text = ". . . . . . . . . . . . . . . $0.00"
                                            self.bookStack.isHidden = true
                                            self.statusLbl.isHidden = false
                                            self.statusLbl.text = "Out of range"
                                            
                                        } else {
                                            
                                            self.checkForDriverAround()
                                            
                                            if result <= Float(5.0) {
      
                                                finalPrice = basePrice
                                                let price = Double(finalPrice)
                                                
                                                
                                                self.carPrice.text = "$\(String(format:"%.2f", price!))"
                                                self.OnCampusFareLbl.text = ". . . . . . . . . . . . . $\(finalPrice)"
                                                self.OffCampusFareLbl.text = ". . . . . . . . . . . . . $0.00"
                                                
                                                
                                            } else {
                                                
                                                let base = Float(basePrice)
                                                self.OnCampusFareLbl.text = ". . . . . . . . . . . . . $\(String(format:"%.2f", base!))"
                                                self.OffCampusFareLbl.text = ". . . . . . . . . . . . . $\(0.25)"
                                                
                                                let change = (result - 5.0) * 0.25
                                                var final = base! + change
                                                final = round(100*final)/100
                                                
                                                finalPrice = String(final)
                
                                                self.carPrice.text = "$\(String(format:"%.2f", final))"
                                                
                                                
                                            }
                                            
                                            
                                            
                                        }
                                        
                                        
                                        
                                        
                                    }
                                    
                                    
                                    
                                    
                                    
                                }
                                
                            }
                        }
                        
                    }
                }
                
            }
            
            // print route using Polyline
            for route in routes
            {
                
                
                
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                self.path = GMSPath.init(fromEncodedPath: points!)!
                self.polyline = GMSPolyline.init(path: self.path)
                self.polyline.strokeWidth = 4
                self.polyline.strokeColor = UIColor.black
                self.polyline.map = self.mapView
                
                completed()
                
            }
            

            
            self.marker.position = pickup
            self.marker.icon = nil
            self.marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
            
            self.marker.map = self.mapView
            self.marker.isTappable = false

            
            self.marker.isTappable = false
            
            let myView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            myView.backgroundColor = UIColor.clear
            self.marker.iconView = myView
            
            
            
            
            self.pulsator.position =  (self.marker.iconView!.center)
            self.marker.iconView?.layer.addSublayer(self.pulsator)
            self.marker.iconView?.backgroundColor = UIColor.clear
            
            
            
            
            myView.backgroundColor = UIColor.clear
            let IconImage = resizeImage(image: UIImage(named: "my")!, targetSize: CGSize(width: 20.0, height: 20.0))
            let markerView = UIImageView(image: IconImage)
            markerView.center = myView.center
            
            self.marker.appearAnimation = .pop
            myView.addSubview(markerView)
            
            
            
            
            let IconImages = resizeImage(image: UIImage(named: "pin")!, targetSize: CGSize(width: 40.0, height: 40.0))
            let gameMarker = GMSMarker()
            gameMarker.position = destination
            gameMarker.icon = IconImages
            gameMarker.title = placeName
            gameMarker.snippet = self.eta
            gameMarker.tracksViewChanges = true
            gameMarker.tracksInfoWindowChanges = true
            
            
            gameMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.1)
            gameMarker.map = self.mapView
            self.mapView.selectedMarker = gameMarker
        }
        
        self.pulsator.start()
        
    }
    

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        manager.activityType = .automotiveNavigation
        manager.allowsBackgroundLocationUpdates = true
        
        if let coor =  locations.last?.coordinate {
            
            self.marker.position = coor
            self.marker.map = self.mapView
            let coors = locations.last
            
            let dest = CLLocation(latitude: DestinationLocation.latitude, longitude: DestinationLocation.longitude)
            
            let distance = calculateDistanceBetweenTwoCoordinator(baseLocation: coors!, destinationLocation: dest)
            
            
            self.marker.position = coor
            self.marker.tracksViewChanges = true
            self.marker.map = self.mapView
            
            
            
            if distance <= 0.5 {
                
                
                rate_driver_uid = tripDriverReuslt.UID
                locationManager.stopUpdatingLocation()
                updateUIForRating()
            
                DataService.instance.mainDataBaseRef.child("On_Trip_arrived").child("Rider").child(userUID).removeValue()
                
                centerMapOnUserLocation()
                
            }
            
            UpdateService.instance.updateUserLocation(withCoordinate: coor)
            
        }
        
    }
    
    func calculateDistanceBetweenTwoCoordinator(baseLocation: CLLocation, destinationLocation: CLLocation) -> Double {
        
        let coordinate₀ = baseLocation
        let coordinate₁ = destinationLocation
        
        let distanceInMeters = coordinate₀.distance(from: coordinate₁) // result is in meters
        
        let distanceInMiles = Double(distanceInMeters) * 0.000621371192
        
        return distanceInMiles
        
    }
    
    func fitAllMarkers(_path: GMSPath) {
        
        var bounds = GMSCoordinateBounds()
        for index in 1..._path.count() {
            bounds = bounds.includingCoordinate(_path.coordinate(at: index))
        }
        
        mapView.animate(with: GMSCameraUpdate.fit(bounds, withPadding: 110.0))
        
    }
    
    
    func returnLocation(coor: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        
        return coor
        
    }
    
    func setAlignmentForBnt() {
        
        
        helpBtn.contentHorizontalAlignment = .left
        reportBtn.contentHorizontalAlignment = .left
        aboutUsBtn.contentHorizontalAlignment = .left
        historyBtn.contentHorizontalAlignment = .left
        paymentBtn.contentHorizontalAlignment = .left
        signOutBtn.contentHorizontalAlignment = .left
        
        
    }
    @IBAction func closeRequestBtnPressed2(_ sender: Any) {
        
        closeRideMode()
        
        
    }
    
    @IBAction func closeRequestBtnPressed(_ sender: Any) {
        
        closeRideMode()
        
        
    }
    
    func checkCampusAgainWhenSearch() {
        
        
        self.listCampus.removeAll()
        guard let coordinate = locationManager.location?.coordinate else {
            
            
            self.showErrorAlert("Oops !!!", msg: "Cannot track your location, please turn it on and try again")
            
            return
            
            
        }
        
        
        let url =  Database.database().reference().child("Campus-Connect").child("Campus_Coordinate")
        let geofireRef = url
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        
     
        let query = geoFire.query(at: loc, withRadius: 10)
        checkPriceAgainWhenSearch(query: query)
        
        
        
        
    }
    
    func checkPriceAgainWhenSearch(query: GFCircleQuery) {
        
        
        query.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            
            if let key = key {
                
                self.listCampus.append(key)
                
            }
            
            
        })
        
        query.observeReady {
            
            query.removeAllObservers()
            
            if self.listCampus.isEmpty == true {
                
                self.alertLbl.text = "You aren't near any of our campus"
                self.alertLbl.textColor = UIColor.white
                self.alertView.isHidden = false
                self.destinationBtn.isHidden = true
                
                
            } else {
                
                
                let key = self.listCampus[0]
                DataService.instance.mainDataBaseRef.child("Available_Campus").child(key).observeSingleEvent(of: .value, with: { (schoolData) in
                    
                    
                    if let dict = schoolData.value as? Dictionary<String, Any> {
                        
                        
                        if let price = dict["Price"] as? Float {
                            
                            self.centerMapOnUserLocation()
                            basePrice = String(price)
                            
                            NotificationCenter.default.addObserver(self, selector: #selector(MapView.getDirection), name: (NSNotification.Name(rawValue: "GetRide")), object: nil)
                            
                            
                            self.performSegue(withIdentifier: "openSearchVC", sender: nil)
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                })
                
                
                self.alertView.isHidden = true
                self.destinationBtn.isHidden = false
                
            }
            
            
        }
        
        
        
    }
    
    func checkCampusDistance() {
        
        
        self.listCampus.removeAll()
        guard let coordinate = locationManager.location?.coordinate else {
            
            
            self.showErrorAlert("Oops !!!", msg: "Cannot track your location, please turn it on and try again")
            
            return
            
            
        }
        //let url = DataService.instance.mainDataBaseRef.child("Campus_Coordinate")
        let url =  Database.database().reference().child("Campus-Connect").child("Campus_Coordinate")
        let geofireRef = url
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        
        
        let query = geoFire.query(at: loc, withRadius: 10)
        checkCampusRadius(query: query)
    }
    
    func checkCampusRadius(query: GFCircleQuery) {
        
        query.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            
            if let key = key {
                
                self.listCampus.append(key)
                
            }
            
            
        })
        
        query.observeReady {
            
            query.removeAllObservers()
            
            if self.listCampus.isEmpty == true {
                
                self.alertLbl.text = "You aren't near any of our campus"
                self.alertLbl.textColor = UIColor.white
                self.alertView.isHidden = false
                self.destinationBtn.isHidden = true
                
                
            } else {
                
                
                let key = self.listCampus[0]
                DataService.instance.mainDataBaseRef.child("Available_Campus").child(key).observeSingleEvent(of: .value, with: { (schoolData) in
                    
                    
                    if let dict = schoolData.value as? Dictionary<String, Any> {
                        
                        
                        if let price = dict["Price"] as? Float {
                            
                            
                            basePrice = String(price)
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                })
                
                
                self.alertView.isHidden = true
                self.destinationBtn.isHidden = false
                
            }
            
            
        }
    }
    
    func centerMapDuringTrip() {
        
        
        guard let coordinate = locationManager.location?.coordinate else { return }
        let cordinated = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 13)
        self.marker.position = cordinated
        self.marker.map = mapView
        self.mapView.camera = camera
        self.mapView.animate(to: camera)
        self.fitAllMarkers(_path: path)
        
    }
    
    
    
    
    
    func centerMapOnUserLocation() {
        
        self.mapView.clear()
        
        
        //adddrivermarker();
        
        
        self.locationManager.stopUpdatingLocation()
        
        guard let coordinate = locationManager.location?.coordinate else { return }
        
        
        localLocation = CLLocation(latitude: coordinate.latitude, longitude:coordinate.longitude)
        
        let cordinated = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        // get MapView
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude, longitude: coordinate.longitude, zoom: 13)
        
        
        let cams = GMSCameraUpdate.setCamera(camera)
        
        
        self.marker.iconView = nil
        
        
        //mapV
        
        
        self.marker.position = cordinated
        self.marker.map = mapView
        
        
        //self.mapView.camera = camera
        self.mapView.moveCamera(cams)
        
        
        self.marker.isTappable = false
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        myView.backgroundColor = UIColor.clear
        self.marker.iconView = myView
        
        visibleRegion = mapView.projection.visibleRegion()
        bounds = GMSCoordinateBounds(coordinate: visibleRegion.nearLeft, coordinate: visibleRegion.farRight)
        
        
        pulsator.position =  (marker.iconView!.center)
        self.marker.iconView?.layer.addSublayer(pulsator)
        self.marker.iconView?.backgroundColor = UIColor.clear
        
        
        
        
        myView.backgroundColor = UIColor.clear
        let IconImage = resizeImage(image: UIImage(named: "my")!, targetSize: CGSize(width: 20.0, height: 20.0))
        let markerView = UIImageView(image: IconImage)
        markerView.center = myView.center
        
        self.marker.appearAnimation = .pop
        myView.addSubview(markerView)
        
        
        pulsator.start()
        
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "openSearchVC"{
            if let destination = segue.destination as? searchController
            {
                destination.bounds = self.bounds
                
            }
        }
        
        
    }
    
    
    func configureLocationService() {
        
        
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            centerMapOnUserLocation()
            
        }
        
        
    }
    
    func styleMap() {
        
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "customizedMap", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        
        
    }
    @IBAction func closeBtn2Pressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            self.menuView.frame = CGRect(x: 0, y:self.dragViewDefaultTopMargin , width: UIScreen.main.bounds.width, height: self.menuView.frame.size.height)
            self.menuView.layer.cornerRadius = 60.0
            self.animatedBtn.isHidden = false
            self.animated2Btn.isHidden = false
            self.userImgView.isHidden = true
            self.closeProfileBtn.isHidden = true
            self.closeProfileBtn2.isHidden = true
            
        }), completion: nil)
        
    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            self.menuView.frame = CGRect(x: 0, y:self.dragViewDefaultTopMargin , width: UIScreen.main.bounds.width, height: self.menuView.frame.size.height)
            self.menuView.layer.cornerRadius = 60.0
            self.animatedBtn.isHidden = false
            self.animated2Btn.isHidden = false
            self.userImgView.isHidden = true
            self.closeProfileBtn.isHidden = true
            self.closeProfileBtn2.isHidden = true
            
        }), completion: nil)
        
    }
    @IBAction func animatedProfileViewBtn2Pressed(_ sender: Any) {
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            self.menuView.frame = CGRect(x:0, y:self.dragViewAnimatedTopMargin , width: UIScreen.main.bounds.width, height: self.menuView.frame.size.height)
            self.menuView.layer.cornerRadius = 0.0
            self.animatedBtn.isHidden = true
            self.animated2Btn.isHidden = true
            self.closeProfileBtn.isHidden = false
            self.userImgView.isHidden = false
            self.closeProfileBtn2.isHidden = false
            let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
            self.scrollView.setContentOffset(desiredOffset, animated: true)
            
        }), completion: nil)
        
        
    }
    
    @IBAction func animateProfileViewBtnPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            self.menuView.frame = CGRect(x:0, y:self.dragViewAnimatedTopMargin , width: UIScreen.main.bounds.width, height: self.menuView.frame.size.height)
            self.menuView.layer.cornerRadius = 0.0
            self.animatedBtn.isHidden = true
            self.animated2Btn.isHidden = true
            self.closeProfileBtn.isHidden = false
            self.userImgView.isHidden = false
            self.closeProfileBtn2.isHidden = false
            let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
            self.scrollView.setContentOffset(desiredOffset, animated: true)
            
        }), completion: nil)
        
        
    }
    
    @IBAction func centerMyLocationBtnPressed(_ sender: Any) {
        
        if riderView.isHidden == false {
            
            centerMapDuringTrip()
            
            
        } else {
            pulsator.stop()
            checkIfRiderStilOnTrip()
            
        }
        
        
        
        
    }
    // handle drag view
    
    @IBAction func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            
            var newTranslation = CGPoint()
            var oldTranslation = CGPoint()
            newTranslation = gestureRecognizer.translation(in: self.view)
            
            if(!(newTranslation.y < 0 && self.menuView.frame.origin.y + newTranslation.y <= dragViewAnimatedTopMargin))
            {
                self.menuView.translatesAutoresizingMaskIntoConstraints = true
                self.menuView.center = CGPoint(x: self.menuView.center.x, y: self.menuView.center.y + newTranslation.y)
                
                if (newTranslation.y < 0)
                {
                    
                    
                    if("\(self.menuView.frame.size.width)" != "\(String(describing: self.view.frame.size.width))")
                    {
                        if self.menuView.frame.size.width >= (self.view.frame.size.width)
                        {
                            self.menuView.frame = CGRect(x: self.menuView.frame.origin.x, y:self.menuView.frame.origin.y , width: self.menuView.frame.size.width, height: self.menuView.frame.size.height)
                            
                            
                        }
                        else{
                            self.menuView.frame = CGRect(x: self.menuView.frame.origin.x - 2, y:self.menuView.frame.origin.y , width: self.menuView.frame.size.width + 4, height: self.menuView.frame.size.height)
                            
                            
                        }
                        
                    }
                }
                else
                {
                    
                    if("\(self.menuView.frame.size.width)" != "\((self.view.frame.size.width) - 20)")
                    {
                        self.menuView.frame = CGRect(x: 0, y:self.menuView.frame.origin.y , width: self.menuView.frame.size.width , height: self.menuView.frame.size.height)
                    }
                }
                
                
                gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
                
                oldTranslation.y = newTranslation.y
            }
            else
            {
                self.menuView.frame.origin.y = dragViewAnimatedTopMargin
                self.menuView.isUserInteractionEnabled = false
            }
            
        }
        else if (gestureRecognizer.state == .ended)
        {
            
            
            self.menuView.isUserInteractionEnabled = true
            let vel = gestureRecognizer.velocity(in: self.view)
            
            
            let finalY: CGFloat = 50.0
            let curY: CGFloat = self.menuView.frame.origin.y
            let distance: CGFloat = curY - finalY
            
            
            let springVelocity: CGFloat = 1.0 * vel.y / distance
            
            
            if(springVelocity > 0 && self.menuView.frame.origin.y <= dragViewAnimatedTopMargin)
            {
                self.menuView.frame = CGRect(x: 0, y:self.menuView.frame.origin.y , width: (self.view.frame.size.width), height: self.menuView.frame.size.height)
                
            }
            else if (springVelocity > 0)
            {
                
                if (self.menuView.frame.origin.y < (self.view.frame.size.height)/3 && springVelocity < 7)
                {
                    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                        if("\(self.menuView.frame.size.width)" != "\(String(describing: self.view.frame.size.width))")
                        {
                            self.menuView.frame = CGRect(x: 0, y:self.menuView.frame.origin.y , width: (self.view.frame.size.width), height: self.menuView.frame.size.height)
                            
                            self.menuView.layer.cornerRadius = 0.0
                            self.animatedBtn.isHidden = true
                            self.animated2Btn.isHidden = true
                            self.closeProfileBtn.isHidden = false
                            self.closeProfileBtn2.isHidden = false
                            self.userImgView.isHidden = false
                            let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
                            self.scrollView.setContentOffset(desiredOffset, animated: true)
                        }
                        
                        self.menuView.frame.origin.y = self.dragViewAnimatedTopMargin
                    }), completion:  { (finished: Bool) in
                        
                        
                        
                        
                    })
                }
                else
                {
                    UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                        
                        if(self.menuView.frame.size.width != (self.view.frame.size.width) - 20)
                        {
                            self.menuView.frame = CGRect(x: 0, y:self.menuView.frame.origin.y , width: (self.view.frame.size.width), height: self.menuView.frame.size.height)
                            
                            self.menuView.layer.cornerRadius = 60.0
                            self.animatedBtn.isHidden = false
                            self.animated2Btn.isHidden = false
                            self.closeProfileBtn.isHidden = true
                            self.userImgView.isHidden = true
                            self.closeProfileBtn2.isHidden = true
                            
                        }
                        
                        self.menuView.frame.origin.y = self.dragViewDefaultTopMargin
                        
                        
                    }), completion:  { (finished: Bool) in
                        
                        
                        
                        
                        
                    })
                }
            }
            else if (springVelocity == 0)// If Velocity zero remain at same position
            {
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                    
                    self.menuView.frame.origin.y = CGFloat(self.viewLastYPosition)
                    
                    if(self.menuView.frame.origin.y == self.dragViewDefaultTopMargin)
                    {
                        if("\(self.menuView.frame.size.width)" == "\(String(describing: self.view.frame.size.width))")
                        {
                            self.menuView.frame = CGRect(x: 0, y:self.menuView.frame.origin.y , width: self.menuView.frame.size.width, height: self.menuView.frame.size.height)
                            
                            self.menuView.layer.cornerRadius = 60.0
                            self.animatedBtn.isHidden = false
                            self.animated2Btn.isHidden = false
                            self.closeProfileBtn.isHidden = true
                            self.userImgView.isHidden = true
                            self.closeProfileBtn2.isHidden = true
                        }
                    }
                    else{
                        if("\(self.menuView.frame.size.width)" != "\(String(describing: self.view.frame.size.width))")
                        {
                            self.menuView.frame = CGRect(x: 0, y:self.menuView.frame.origin.y , width: (self.view.frame.size.width), height: self.menuView.frame.size.height)
                            self.menuView.layer.cornerRadius = 0.0
                            self.animatedBtn.isHidden = true
                            self.animated2Btn.isHidden = true
                            self.closeProfileBtn.isHidden = false
                            self.closeProfileBtn2.isHidden = false
                            self.userImgView.isHidden = false
                            let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
                            self.scrollView.setContentOffset(desiredOffset, animated: true)
                            
                            
                            
                        }
                    }
                    
                }), completion:  { (finished: Bool) in
                    
                    
                    
                    
                })
            }
            else
            {
                if("\(self.menuView.frame.size.width)" != "\(String(describing: self.view.frame.size.width))")
                {
                    self.menuView.frame = CGRect(x: 0, y:self.menuView.frame.origin.y , width: (self.view.frame.size.width), height: self.menuView.frame.size.height)
                    
                }
                
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                    
                    self.menuView.frame.origin.y = self.dragViewAnimatedTopMargin
                    self.menuView.layer.cornerRadius = 0.0
                    self.animatedBtn.isHidden = true
                    self.animated2Btn.isHidden = true
                    self.closeProfileBtn.isHidden = false
                    self.closeProfileBtn2.isHidden = false
                    self.userImgView.isHidden = false
                    let desiredOffset = CGPoint(x: 0, y: -self.scrollView.contentInset.top)
                    self.scrollView.setContentOffset(desiredOffset, animated: true)
                    
                }), completion:  { (finished: Bool) in
                    
                    
                    
                    
                })
                
                
                
                
            }
            viewLastYPosition = Double(self.menuView.frame.origin.y)
            
            self.menuView.addGestureRecognizer(gestureRecognizer)
        }
        
    }
    @IBAction func reportBtnPressed(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "moveToReportVC", sender: nil)
        
    }
    
    @IBAction func bookCarBtnPressed(_ sender: Any) {
        //REQUEST CC
        
        
        self.recent_reject_uid = nil
        self.isTip = false
        self.movingKey = ""
        self.movingUID = ""
        if BookCarBtn.titleLabel?.text == "Confirm" {
            
            if acceptBookCar == true {
                
                
                if (try? InformationStorage?.object(ofType: String.self, forKey: "phone")) != nil {
                    
                    if (try? InformationStorage?.object(ofType: String.self, forKey: "user_name")) != nil {
                        
                        if (try? InformationStorage?.object(ofType: String.self, forKey: "email")) != nil {
                            
                            
                            swiftLoader()
                            
                            
                            NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "enableCancel")), object: nil)
                            NotificationCenter.default.addObserver(self, selector: #selector(MapView.cancelRide), name: (NSNotification.Name(rawValue: "cancelRide")), object: nil)
                            
                            delay(5.0) { () -> () in
                                
                                if isCancelShow == true {
                                    
                                    NotificationCenter.default.post(name: (NSNotification.Name(rawValue: "DisableCancel")), object: nil)
                                    
                                    self.queryForDriver() {
                                        
                                        let currentDateTime = Date()
                                        
                                        // initialize the date formatter and set the style
                                        let formatter = DateFormatter()
                                        formatter.timeStyle = .medium
                                        formatter.dateStyle = .long
                                        
                                        // get the date time String from the date object
                                        let result = formatter.string(from: currentDateTime)
                                        let description = "Authorize payment for request ride from Campus Connect at \(result)"
                                        
                                        if chargedCardBrand == "Apple_pay" {
                                            
                                            
                                            self.makeApple_pay(text: description)
                                            
                                            
                                        } else {
                                            
                                            
                                            let price = Double(finalPrice)
                                            
                                            var roundedPrice = price?.roundTo(places: 2)
                                            
                                            roundedPrice = roundedPrice! * 100
                                            
                                            
                                            self.makePayment(captured: false, price: roundedPrice!, text: description) {
                                                
                                                
                                                self.process_trip_request()
                                                
                                            }
                                            
                                            
                                        }
                                        
                                    }
                                    
                                    
                                    
                                    
                                }
                                
                                
                            }
                            
                            
                            
                            
                            
                        } else {
                            
                            self.showErrorAlert("Oops !!!", msg: "Something wrong, please try again")
                            
                        }
                        
                        
                        
                    } else {
                        
                        self.showErrorAlert("Oops !!!", msg: "Something wrong, please try again")
                        
                        
                    }
                    
                    
                    
                } else {
                    
                    self.showErrorAlert("Oops !!!", msg: "Something wrong, please try again")
                    
                }
                
                
            } else {
                
                
                self.showErrorAlert("Oops !!!", msg: "Can't perform the action due to out of range, the limit between ride is 10 miles")
                
            }
            
        }
        
        
        
        
        
        
        
    }
    
    
    func process_trip_request() {
        
        let key = self.listDriver[0]
        recent_reject_uid = key
        
        self.request_ride(driverUID: key) {
            
            self.Rider_observeTrip(recentDriverUID: key, key: trip_key_request)
            
        }
        
        
        if self.bookCarView.isHidden != true {
            
            delay(20.0) { () -> () in
                
                if self.bookCarView.isHidden != true {
                    
                    
                    self.queryForDriver() {
                        
                        
                        self.process_trip_request()
                        
                    }
                    
                    
                }
                
                
                
            }
            
        }
        
        
        
        
    }
    
    func request_ride(driverUID: String, completed: @escaping DownloadComplete) {
        
        if let phone = try? InformationStorage?.object(ofType: String.self, forKey: "phone") {
            
            if let name = try? InformationStorage?.object(ofType: String.self, forKey: "user_name") {
                
                if let email = try? InformationStorage?.object(ofType: String.self, forKey: "email") {
                    
                    let ref = DataService.instance.mainDataBaseRef.child("Trip_request").child(userUID).childByAutoId()
                    
                    DataService.instance.mainDataBaseRef.child("Trip_request_Count").childByAutoId().setValue(["Timestamp": ServerValue.timestamp()])
                    
                    
                    let key = ref.key
                    
                    let request_trip = makeRequestTripDict(pickUpAddress: pickUpAddress, destinationAddress: destinationAddress, pickUpLocation: pickUpLocation, DestinationLocation: DestinationLocation, phone: phone!, price: Float(finalPrice)!, pickUpName: name!, pickUpEmail: email!, Trip_key: key!, capturedKey: capturedKey, distance: finalDistance, rider_UID: userUID)
                    
                    
                    let match_trip: Dictionary<String, AnyObject> = ["UID": userUID as AnyObject, "key": key as AnyObject, "Timestamp": ServerValue.timestamp() as AnyObject]
                    
                    
                    
                    UpdateService.instance.createTrip(dict: request_trip, key: key!)
                    UpdateService.instance.matchToDriver(dict: match_trip, driverUID: driverUID, key: key!)
                    
                    trip_key_request = key!
                    
                    completed()
                    
                    
                    
                }
                
            }
            
        }
    }
    
    func Rider_observeTrip(recentDriverUID: String, key: String) {
        
        DataService.instance.mainDataBaseRef.child("Rider_Observe_Trip").child(userUID).removeValue()
        
        Rider_handle = DataService.instance.mainDataBaseRef.child("Rider_Observe_Trip").child(userUID).child(key).observe(.value, with: { (tripData) in
            
            
            if tripData.exists() {
                
                DataService.instance.mainDataBaseRef.child("Rider_Observe_Trip").child(userUID).child(key).removeObserver(withHandle: self.Rider_handle!)
                
                DataService.instance.mainDataBaseRef.child("Rider_Observe_Trip").child(userUID).child(key).child("Status").observeSingleEvent(of: .value, with: { (snap) in
                    
                    
                    if let value = snap.value as? Int, value == 0 {
                        //accepted
                        
                        //self.process_trip_request()
                        //self.listRecentDriver.append(recentDriverUID)
                        
                        print("Cancel")
                        
                        self.queryForDriver() {
                            
                            self.process_trip_request()
                            
                        }
                        
                        
                        
                        
                    } else {
                        if let value = snap.value as? String {
                            
                            DataService.instance.mainDataBaseRef.child("Driver_Info").child(value).observeSingleEvent(of: .value, with: { (DriverData) in
                                
                                
                                if let DriverDict = DriverData.value as? Dictionary<String, Any> {
                                    
                                    let TripDataResult = Driver_trip_model(postKey: DriverData.key, Driver_trip_model: DriverDict)
                                    self.tripDriverReuslt = TripDataResult
                                    self.trip_key = key
                                    
                                    
                                    DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Rider").child(userUID).setValue(["Timestamp": ServerValue.timestamp(), "Trip_key": self.trip_key!, "Driver_UID": self.tripDriverReuslt.UID, "Rider_UID": userUID])
                                    
                                    DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Driver").child(self.tripDriverReuslt.UID).setValue(["Timestamp": ServerValue.timestamp(), "Trip_key": self.trip_key!, "Driver_UID": self.tripDriverReuslt.UID, "Rider_UID": userUID])
                                    
                                    DataService.instance.mainDataBaseRef.child("Trip_request").child(userUID).child(key).observeSingleEvent(of: .value, with: { (TripHistory) in
                                        
                                        
                                        if let TripDict = TripHistory.value as? Dictionary<String, Any> {
                                            
                                            
                                            DataService.instance.mainDataBaseRef.child("Trip_History").child("Rider").child(userUID).child(key).setValue(TripDict)
                                            DataService.instance.mainDataBaseRef.child("Trip_History").child("Rider").child(userUID).child(key).updateChildValues(["Progess": "On progress"])
                                            
                                            DataService.instance.mainDataBaseRef.child("Trip_History").child("Rider").child(userUID).child(key).updateChildValues(DriverDict)
                                            
                                            
                                            
                                            DataService.instance.mainDataBaseRef.child("Trip_History").child("Driver").child(value).child(key).setValue(TripDict)
                                            DataService.instance.mainDataBaseRef.child("Trip_History").child("Driver").child(value).child(key).updateChildValues(["Progess": "On progress"])
                                            
                                            DataService.instance.mainDataBaseRef.child("Trip_History").child("Driver").child(value).child(key).updateChildValues(DriverDict)
                                            
                                            
                                            
                                            
                                            
                                            
                                        }
                                        
                                        
                                    })
                                    
                                    
                                    
                                    
                                    
                                    
                                    self.assignDriver(DriverData: TripDataResult, key: key)
                                    
                                    
                                }
                                
                                
                            })
                            
                        }
                        
                        
                    }
                    
                })
                
                
            }
            
            
            
        })
        
        
    }
    
    
    func assignDriver(DriverData: Driver_trip_model, key: String) {
        
        
        
        let fullNameArr = DriverData.user_name.components(separatedBy: " ")
        RequestDriverName.text = fullNameArr[0].firstUppercased
        RequestDriverCarRegistraton.text = DriverData.Car_registration
        requestDriverCarModel.text = DriverData.Car_model
        
        
        
        if let CacheDriverImg = try? InformationStorage?.object(ofType: ImageWrapper.self, forKey: DriverData.Face_ID).image {
            
            requestDriverImg.image = CacheDriverImg
            
        } else {
            
            Alamofire.request(DriverData.Face_ID).responseImage { response in
                
                if let image = response.result.value {
                    
                    let wrapper = ImageWrapper(image: image)
                    self.requestDriverImg.image = image
                    try? InformationStorage?.setObject(wrapper, forKey: DriverData.Face_ID)
                    
                    
                }
                
                
            }
            
            
            
        }
        
        
        DataService.instance.mainDataBaseRef.child("Average_Rate").child("Driver").child(DriverData.UID).observeSingleEvent(of: .value, with: { (RateData) in
            
            if RateData.exists() {
                
                
                if let dict = RateData.value as? Dictionary<String, Any> {
                    
                    
                    if let RateGet = dict["Rate"] as? Float {
                        
                        
                        
                        self.driverRateCount.text = String(format:"%.1f", RateGet)
                        
                    }
                    
                    
                }
                
                
            } else {
                
                self.driverRateCount.text = ""
                
                
            }
            
            
        })
        
        SwiftLoader.hide()
        animatedBookCar()
        observeSingalCheck(driverUID: DriverData.UID,key: key)
        
        observeCurrentDriverCoordinate(UID: DriverData.UID, key: key) {
            
            
            self.drawRouteForRider(origins: self.driverLocation, destinationed: pickUpLocation) {
                
                
                
                self.movingKey = DriverData.UID
                self.movingUID = key
                self.animted = false
                
                self.fitAllMarkers(_path: self.path)
                self.onDemandDriverID = DriverData.UID
                self.observeMovingDriverCoordinate(UID: DriverData.UID, key: key)
                self.observeCompletedTrip(UID: DriverData.UID, key: key)
                self.observeCancelFromDriver(key: key)
                
                
                
            }
            
            
        }
        
        
        
        
    }
    
    
    @IBAction func contactBtnPressed(_ sender: Any) {
        
        makeAPhoneCall()
        
    }
    
    func makeAPhoneCall()  {
        
        let phone = self.tripDriverReuslt.phone.dropFirst().dropFirst()
        
        
        if let url = URL(string: "tel://\(phone)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        } else {
            
            print("Cannot Call")
            
        }
        
        
    }
    
    func check_server_maintenance() {
        
        
        DataService.instance.mainDataBaseRef.child("server_maintenance").observe( .value, with: { (maintenance) in
            
            if maintenance.exists() {
                
                
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                    kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                    kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                    showCloseButton: false,
                    dynamicAnimatorActive: true,
                    buttonsLayout: .horizontal
                )
                
                let alert = SCLAlertView(appearance: appearance)
                
                _ = alert.addButton("Got it") {
                    
                    try! Auth.auth().signOut()
                    try? InformationStorage?.removeAll()
                    DataService.instance.mainDataBaseRef.removeAllObservers()
                    self.performSegue(withIdentifier: "GoBackToSignIn", sender: nil)
                    
                    
                }
                
                let icon = UIImage(named:"lg1")
                
                _ = alert.showCustom("Sorry !!!", subTitle: "The app is under maintenance. Please comeback later ", color: UIColor.black, icon: icon!)
                
                
            }
            
            
        })
        
        
    }
    
    func checkIfAccountRemove() {
        
        DataService.instance.mainDataBaseRef.child("User").child(userUID).observe( .value, with: { (maintenance) in
            
            if maintenance.exists() {
                
                
            } else {
                
                let appearance = SCLAlertView.SCLAppearance(
                    kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                    kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                    kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                    showCloseButton: false,
                    dynamicAnimatorActive: true,
                    buttonsLayout: .horizontal
                )
                
                let alert = SCLAlertView(appearance: appearance)
                
                _ = alert.addButton("Got it") {
                    
                    try! Auth.auth().signOut()
                    try? InformationStorage?.removeAll()
                    DataService.instance.mainDataBaseRef.removeAllObservers()
                    self.performSegue(withIdentifier: "GoBackToSignIn", sender: nil)
                    
                    
                }
                
                let icon = UIImage(named:"lg1")
                
                _ = alert.showCustom("Sorry !!!", subTitle: "Your account has been removed for some reasons, please contact us for more information through support@campusconnectonline.com ", color: UIColor.black, icon: icon!)
                
            }
            
            
        })
    }
    
    func observeCurrentDriverCoordinate(UID: String,key: String, completed: @escaping DownloadComplete) {
        
        DataService.instance.mainDataBaseRef.child("On_Trip_Driver_coordinator").child(UID).child(key).observeSingleEvent(of: .value, with: { (DriverCoor ) in
            
            if let coor = DriverCoor.value as? Dictionary<String, Any> {
                
                let location = CLLocationCoordinate2D(latitude: coor["Lat"] as! CLLocationDegrees, longitude: coor["Lon"] as! CLLocationDegrees)
                
                self.locationarray.add(location);
                
                self.driverLocation = location
                
                completed()
                
            }
            
        })
        
    }
    
    
    
    func observeMovingDriverCoordinate(UID: String, key: String) {
        
        rider_trip_coordinator_handle = DataService.instance.mainDataBaseRef.child("On_Trip_Driver_coordinator").child(UID).child(key).observe(.value, with: { (DriverCoor ) in
            
            if let coor = DriverCoor.value as? Dictionary<String, Any> {
                
                let location = CLLocationCoordinate2D(latitude: coor["Lat"] as! CLLocationDegrees, longitude: coor["Lon"] as! CLLocationDegrees)
                self.driverMarker.position = location
                self.driverMarker.tracksViewChanges = true
                self.driverMarker.map = self.mapView
                
                
                
            }
            
        })
        
    }
    
    func observeCompletedTrip(UID: String, key: String) {
        
        completed_trip_handle = DataService.instance.mainDataBaseRef.child("trip_progressed").child(userUID).child(key).observe(.value, with: { (tripStatus) in
            
            if tripStatus.exists() {
                
                if let tripDictStatus = tripStatus.value as? Dictionary<String, Any> {
                    
                    if let Status = tripDictStatus["Status"] as? String {
                        
                        if Status == "Picked up" {
                            
                            self.riderView.isHidden = true
                            
                            
                            self.movingKey = ""
                            self.movingUID = ""
                            
                            DataService.instance.mainDataBaseRef.child("Cancel_request").child(userUID).removeAllObservers()
                            DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Rider").child(userUID).removeValue()
                            
                            DataService.instance.mainDataBaseRef.child("Ride_Signal_Check").child(key).child(userUID).child("Request").removeAllObservers()
                            DataService.instance.mainDataBaseRef.child("On_Trip_Pick_Up").child("Driver").child(self.tripDriverReuslt.UID).removeValue()
                            
                            
                            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                                
                                
                                self.mapViewBottomConstraint.constant = 0.0
                                self.riderView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: self.bookCarView.frame.width, height: self.bookCarView.frame.height)
                                
                                
                                
                            }), completion:  { (finished: Bool) in
                                
                                
                                
                                
                            })
                            
                            
                            DataService.instance.mainDataBaseRef.child("On_Trip_Driver_coordinator").child(UID).child(key).removeObserver(withHandle: self.rider_trip_coordinator_handle!)
                            DataService.instance.mainDataBaseRef.child("trip_progressed").child(userUID).child(key).removeObserver(withHandle: self.completed_trip_handle!)
                            
                            
                            let Mylocation =  CLLocationCoordinate2D(latitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!)
                            
                            self.locationManager.startUpdatingLocation()
                            
                            
                            
                            
                            self.drawDirection(pickup: Mylocation, destination: DestinationLocation) {
                                
                                self.locationManager.startUpdatingLocation()
                                self.fitAllMarkers(_path: self.path)
                                
                            }
                            
                        }
                        
                        
                        
                    }
                    
                }
                
                
                
            }
            
        })
        
        
    }
    
    func drawRouteForRider(origins: CLLocationCoordinate2D, destinationed: CLLocationCoordinate2D, completed: @escaping DownloadComplete) {
        
        
        mapView.clear()
        let origin = "\(origins.latitude),\(origins.longitude)"
        let destination = "\(destinationed.latitude),\(destinationed.longitude)"
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&sensor=true&key=\(googleMap_Key)"
        
        
        self.polyline.map = nil
        
        
        Alamofire.request(url).responseJSON { response in
            
            let json = try! JSON(data: response.data!)
            let routes = json["routes"].arrayValue
            
            
            if let dict = response.value as? Dictionary<String, AnyObject> {
                
                if let result = dict["routes"] as? [Dictionary<String, AnyObject>] {
                    
                    for i in result {
                        
                        if let x = i["legs"] as? [Dictionary<String, AnyObject>] {
                            
                            for y in x {
                                
                                if let z = y["duration"] as? Dictionary<String, AnyObject> {
                                    
                                    self.eta = (z["text"] as? String)!
                                    
                                }
                                
                            }
                        }
                        
                    }
                }
                
            }
            
            // print route using Polyline
            for route in routes
            {
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                self.path = GMSPath.init(fromEncodedPath: points!)!
                self.polyline = GMSPolyline.init(path: self.path)
                self.polyline.strokeWidth = 4
                self.polyline.strokeColor = UIColor.black
                self.polyline.map = self.mapView
                
                completed()
                
            }
            
            
            self.marker.position = destinationed
            
            self.marker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.5)
            self.marker.map = self.mapView
            self.marker.isTappable = false
            
            let myView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            myView.backgroundColor = UIColor.clear
            self.marker.iconView = myView
            
            
            
            
            self.pulsator.position =  (self.marker.iconView!.center)
            self.marker.iconView?.layer.addSublayer(self.pulsator)
            self.marker.iconView?.backgroundColor = UIColor.clear
            
            
            
            
            myView.backgroundColor = UIColor.clear
            let IconImage = resizeImage(image: UIImage(named: "my")!, targetSize: CGSize(width: 20.0, height: 20.0))
            let markerView = UIImageView(image: IconImage)
            markerView.center = myView.center
            
            self.marker.appearAnimation = .pop
            myView.addSubview(markerView)
            
            var IconImages: UIImage!
            
            if let img = self.requestDriverImg.image {
                
   
                IconImages = resizeImage(image: img, targetSize: CGSize(width: 50.0, height: 50.0))
                //self.driverMarker.layer.cornerRadius = self.driverMarker.layer.frame.height / 2
               // self.driverMarker.layer.masksToBounds = true
               // self.driverMarker.layer.borderWidth = 5
               // self.driverMarker.layer.borderColor = UIColor.yellow.cgColor
                
            } else {
                
                IconImages = resizeImage(image: UIImage(named: "black")!, targetSize: CGSize(width: 50.0, height: 50.0))
            }
            
            self.driverMarker.position = origins
            self.driverMarker.icon = IconImages
            self.driverMarker.snippet = self.eta
            self.driverMarker.tracksViewChanges = true
            
            
            //gameMarker.infoWindowAnchor = CGPoint(x: 0.5, y: 0.1)
            self.driverMarker.map = self.mapView
            self.mapView.selectedMarker = self.driverMarker
            
            
          
            
            
        }
        
        
        
        
        
        
        
        
    }
    
    func make_refund() {
        
        
        if self.capturedKey != "" {
            
            
            let currentDateTime = Date()
            
            // initialize the date formatter and set the style
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            
            // get the date time String from the date object
            let result = formatter.string(from: currentDateTime)
            let description = "Release from pre-authorize for taking a ride from Campus Connect at \(result)"
            
            let url = MainAPIClient.shared.baseURLString
            let urls = URL(string: url!)?.appendingPathComponent("refund")
            
            Alamofire.request(urls!, method: .post, parameters: [
                
                "refund_key": self.capturedKey,
                "reason": description
                
                ])
                
                .validate(statusCode: 200..<500)
                .responseJSON { responseJSON in
                    
                    switch responseJSON.result {
                        
                    case .success(let json):
                        
                        
                        if json is [String: AnyObject] {
                            
                            
                            //print(dict)
                            
                        }
                        
                    case .failure( _):
                        
                        self.showErrorAlert("Oops !!!", msg: "There is a problem while returning your money, please contact us for manual refund.")
                        
                    }
                    
                    
            }
            
            
            
            
            
        }
        
        
        
        
        
    }
    
    
    func makeDictForApplePay(json: Any, completed: @escaping DownloadComplete) {
        
        
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
    
    
    
    
    
    
    @objc func cancelRide() {
        
        NotificationCenter.default.removeObserver(self, name: (NSNotification.Name(rawValue: "cancelRide")), object: nil)
        SwiftLoader.hide()
        
        
        
        
        
    }
    
    func checkForDriverAround() {
        
        self.listDriver.removeAll()
        let url = DataService.instance.mainDataBaseRef.child("Driver_coordinator")
        let geofireRef = url
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let loc = CLLocation(latitude: pickUpLocation.latitude, longitude: pickUpLocation.longitude)
        let query = geoFire.query(at: loc, withRadius: 10)
        
        
        query.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            
            if let key = key, key != userUID {
                
                self.listDriver.append(key)
                
                
            }
            
            
        })
        
        query.observeReady {
            
            query.removeAllObservers()
            
            if self.listDriver.isEmpty == true {
                
                self.bookStack.isHidden = true
                self.statusLbl.isHidden = false
                self.statusLbl.text = "No car available"
                
            } else {
                
            

                self.BookCarBtn.setTitle("Confirm", for: .normal)
                self.BookCarBtn.backgroundColor = UIColor.black
                self.BookCarBtn.setTitleColor(UIColor.white, for: .normal)
                
                self.bookStack.isHidden = false
                self.statusLbl.isHidden = true
                
                
            }
            
            
            
            
        }
        
        
    }
    
    
    
    func queryForDriver(completed: @escaping DownloadComplete) {
        
        guard (locationManager.location?.coordinate) != nil else {
            
            
            self.showErrorAlert("Oops !!!", msg: "Cannot track your location, please turn it on and try again")
            
            return
            
            
        }
        
        self.listDriver.removeAll()
        let url = DataService.instance.mainDataBaseRef.child("Driver_coordinator")
        let geofireRef = url
        let geoFire = GeoFire(firebaseRef: geofireRef)
        let loc = CLLocation(latitude: pickUpLocation.latitude, longitude: pickUpLocation.longitude)
        let query = geoFire.query(at: loc, withRadius: 10)
        
        
        query.observe(.keyEntered, with: { (key: String!, location: CLLocation!) in
            
            if let key = key, key != userUID {
                
                self.listDriver.append(key)
                
                
            }
            
            
        })
        
        query.observeReady {
            
            query.removeAllObservers()
            
            if self.listDriver.isEmpty != true {
                
                
                if self.recent_reject_uid != nil {
                    
                    if self.listDriver.contains(self.recent_reject_uid!) {
                        
                        var count = 0
                        for key in self.listDriver {
                            
                            if key == self.recent_reject_uid {
                                
                                self.listDriver.remove(at: count)
                                
                            }
                            count += 1
                            
                            
                            
                        }
                        
                    }
                }
                
                if self.listDriver.isEmpty != true {
                    
                    
                    
                    if chargedCardBrand != "Apple_pay" {
                        
                        if chargedCardID == "" {
                            
                            SwiftLoader.hide()
                            isSelected = true
                            NotificationCenter.default.addObserver(self, selector: #selector(MapView.setPayment), name: (NSNotification.Name(rawValue: "setPayment")), object: nil)
                            self.performSegue(withIdentifier: "moveToPaymentVC", sender: nil)
                            
                            return
                            
                        }
                        
                    } else {
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    completed()
                    
                } else {
                    
                    
                    SwiftLoader.hide()
                    
                    if self.capturedKey != "" {
                        
                        
                        self.make_refund()
                        
                        DataService.instance.mainDataBaseRef.child("Fail_check").child(userUID).child(self.capturedKey).setValue(["Failed": 1])
                        
                        self.capturedKey = ""
                        
                        
                        
                    }
                    
                    
                    if self.Rider_handle != nil {
                        
                        DataService.instance.mainDataBaseRef.child("Rider_Observe_Trip").child(userUID).removeObserver(withHandle: self.Rider_handle!)
                        
                    }
                    
                    self.showErrorAlert("Oops!", msg: "All drivers are busy with other riders right now, please try again")
                    
                }
                
                
                
            } else {
                
                
                
                SwiftLoader.hide()
                
                if self.capturedKey != "" {
                    
                    
                    self.make_refund()
                    
                    DataService.instance.mainDataBaseRef.child("Fail_check").child(userUID).child(self.capturedKey).setValue(["Failed": 1])
                    
                    self.capturedKey = ""
                    
                    
                    
                }
                
                
                if self.Rider_handle != nil {
                    
                    DataService.instance.mainDataBaseRef.child("Rider_Observe_Trip").child(userUID).removeObserver(withHandle: self.Rider_handle!)
                    
                }
                
                self.showErrorAlert("Oops!", msg: "All drivers are busy with other riders right now, please try again")
                
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
            
            //print("Nil")
            
        }
        
        
        
        
    }
    
    func calculateSummaryItemsFromSwag(text: String) -> [PKPaymentSummaryItem] {
        var summaryItems = [PKPaymentSummaryItem]()
        let price = NSDecimalNumber(string: finalPrice)
        
        summaryItems.append(PKPaymentSummaryItem(label: text, amount: price))
        return summaryItems
    }
    
    
    func makeRequestTripDict(pickUpAddress: String, destinationAddress: String, pickUpLocation: CLLocationCoordinate2D, DestinationLocation: CLLocationCoordinate2D, phone: String, price: Float, pickUpName: String, pickUpEmail: String, Trip_key: String, capturedKey: String, distance: String, rider_UID: String) -> Dictionary<String, AnyObject> {
        
        
        let requestTrip: Dictionary<String, AnyObject> = ["Timestamp": ServerValue.timestamp() as AnyObject, "PickUp_Lat": pickUpLocation.latitude as AnyObject, "PickUp_Lon": pickUpLocation.longitude as AnyObject, "Destination_Lat": DestinationLocation.latitude as AnyObject, "Destination_Lon": DestinationLocation.longitude as AnyObject, "PickUp_Phone": phone as AnyObject, "price": price as AnyObject, "pickUp_name": pickUpName as AnyObject, "pickUpEmail": pickUpEmail as AnyObject, "Trip_key": Trip_key as AnyObject, "pickUpAddress": pickUpAddress as AnyObject, "destinationAddress": destinationAddress as AnyObject, "chargedCardID": chargedCardID as AnyObject, "capturedKey": capturedKey as AnyObject, "distance": distance as AnyObject, "rider_UID": rider_UID as AnyObject, "ChargeStatus": "Authenticated" as AnyObject, "DestinationName": placeName as AnyObject, "pickUpName": pickUp_add_Name as AnyObject, "chargedlast4Digit": chargedlast4Digit as AnyObject, "chargedCardBrand": chargedCardBrand as AnyObject]
        
        
        return requestTrip
        
    }
    
    func animatedBookCar() {
        
        
        self.bookCarView.isHidden = true
        self.riderView.isHidden = false
        self.closeRequestBtn1.isHidden = true
        self.closeRequestBtn2.isHidden = true
        let drag = 110
        
        
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            
            self.mapViewBottomConstraint.constant = CGFloat(drag)
            self.bookCarView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: self.bookCarView.frame.width, height: self.bookCarView.frame.height)
            self.riderView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 110, width: self.bookCarView.frame.width, height: self.bookCarView.frame.height)
            
            
            
        }), completion:  nil)
        
        
    }
    
    
    
    @IBAction func changeCarBtnPressed(_ sender: Any) {
        
        /*
         blurView.isHidden = false
         chooseCarView.isHidden = false
         */
        
    }
    
    
    @IBAction func changeCardBtnPressed(_ sender: Any) {
        
        
        
    }
    
    @IBAction func signOutBtnPressed(_ sender: Any) {
        
        try! Auth.auth().signOut()
        
        
        try? InformationStorage?.removeAll()
        DataService.instance.mainDataBaseRef.removeAllObservers()
        self.performSegue(withIdentifier: "GoBackToSignIn", sender: nil)
        
        
        
    }
    
    @IBAction func historyBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "TripHistoryVC", sender: nil)
        
    }
    
    
    @IBAction func paymentBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToPaymentVC", sender: nil)
        
        
    }
    
    // car animation
    

    @IBAction func cancelRideBtnPressed(_ sender: Any) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            dynamicAnimatorActive: true,
            buttonsLayout: .horizontal
        )
        
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("Dismiss") {
            
        }
        _ = alert.addButton("Cancel trip") {
            
            
            DataService.instance.mainDataBaseRef.child("Cancel_request").child(self.tripDriverReuslt.UID).child(self.trip_key!).setValue(["Canceled": 1])
            
            DataService.instance.mainDataBaseRef.removeAllObservers()
            self.locationManager.stopUpdatingLocation()
            
            
            
            self.riderView.isHidden = true
            self.destinationBtn.isHidden = false
            self.pulsator.stop()
            
            let alert = JDropDownAlert()
            let color = UIColor(red: 255/255, green: 102/255, blue: 102/255, alpha: 0.9)
            alert.alertWith("Successfully canceled",
                            topLabelColor: UIColor.white,
                            messageLabelColor: UIColor.white,
                            backgroundColor: color)
            
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                
                
                self.mapViewBottomConstraint.constant = 0.0
                self.riderView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: self.bookCarView.frame.width, height: self.bookCarView.frame.height)
                
                
                
            }), completion:  { (finished: Bool) in
                
                self.centerMapOnUserLocation()
                
                
            })
            
            
        }
        
        let icon = UIImage(named:"lg1")
        
        _ = alert.showCustom("Attention!", subTitle: "If you cancel this ride, you will be charged a cancel fee. Did you still want to cancel?", color: UIColor.black, icon: icon!)
        
        
    }
    
    
    func observeCancelFromDriver(key: String) {
        
        handelCancelFromDriver = DataService.instance.mainDataBaseRef.child("Cancel_request").child(userUID).child(key).observe(.value, with: { (cancelData) in
            
            if cancelData.exists() {
                DataService.instance.mainDataBaseRef.child("Cancel_request").child(userUID).child(key).removeObserver(withHandle: self.handelCancelFromDriver!)
                DataService.instance.mainDataBaseRef.removeAllObservers()
                self.locationManager.stopUpdatingLocation()
                
                
                self.showErrorAlert("Oops !!!", msg: "You driver has canceled this ride.")
                
                self.riderView.isHidden = true
                self.destinationBtn.isHidden = false
                self.pulsator.stop()
                
                
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                    
                    
                    self.mapViewBottomConstraint.constant = 0.0
                    self.riderView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: self.bookCarView.frame.width, height: self.bookCarView.frame.height)
                    
                    
                    
                }), completion:  { (finished: Bool) in
                    
                    self.centerMapOnUserLocation()
                    
                    
                })
                
                
            }
            
            
        })
        
    }
    
    
    
    
    @IBAction func becomeADriverBtnPressed(_ sender: Any) {
        
        
        if self.becomeADriverBtn.titleLabel?.text == "Become a driver" {
            
            self.performSegue(withIdentifier: "moveToBecomeADriverVC", sender: nil)
            
        } else if self.becomeADriverBtn.titleLabel?.text == "Go to driver app" {
            
            
            //Progess
            let url = "https://itunes.apple.com/us/app/cc-driver/id1435010718"
            
            
            guard let urls = URL(string: url) else {
                return //be safe
            }
            
            if #available(iOS 10.0, *) {
                
                UIApplication.shared.open(urls)
                
            } else {
                
                UIApplication.shared.openURL(urls)
                
            }
            
            
        }
        
        
        
    }
    
    @IBAction func share2BtnPressed(_ sender: Any) {
        
        
        shareFreeCode()
        
        
    }
    @IBAction func shareBtnPressed(_ sender: Any) {
        
        
        
        shareFreeCode()
        
        
    }
    
    
    func shareFreeCode() {
        
        if let name = try? InformationStorage?.object(ofType: String.self, forKey: "user_name") {
            
            let fullNameArr = name?.components(separatedBy: " ")
            let first = fullNameArr![0].firstUppercased
            
            if let code = codeLbl.text {
                
                let text =  "You got a free ride from \(first) in Campus-Connect and you can use it now. Your code is here: \(code)"
                
                let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
                
                activityVC.popoverPresentationController?.sourceView = self.view
                
                self.present(activityVC, animated: true, completion: nil)
                
            }
            
            
        }
        
        
    }
    
    
    
    
    
    @IBAction func helpBtnPressed(_ sender: Any) {
        
        guard let url = URL(string: "http://campusconnectonline.com") else {
            return //be safe
        }
        
        
        let vc = SFSafariViewController(url: url)
        
        
        present(vc, animated: true, completion: nil)
        
        
    }
    @IBAction func aboutUsBtnPressed(_ sender: Any) {
        
        guard let url = URL(string: "http://campusconnectonline.com") else {
            return //be safe
        }
        
        let vc = SFSafariViewController(url: url)
        
        
        present(vc, animated: true, completion: nil)
        
        
    }
    
    @IBAction func choosePaymentForRide(_ sender: Any) {
        
        
        isSelected = true
        NotificationCenter.default.addObserver(self, selector: #selector(MapView.setPayment), name: (NSNotification.Name(rawValue: "setPayment")), object: nil)
        self.performSegue(withIdentifier: "moveToPaymentVC", sender: nil)
        
        
    }
    
    // set payment
    
    @objc func setPayment() {
        
        
        NotificationCenter.default.removeObserver(self, name: (NSNotification.Name(rawValue: "setPayment")), object: nil)
        
        
        
        if cardBrand == "Promote_code" {
            
            last4CC.text = "2305"
            let icon = UIImage(named: "lg")
            cardImg.image = icon
            
            
        } else if cardBrand == "Apple_pay" {
            
            last4CC.text = "1603"
            let icon = UIImage(named: "Apple pay")
            cardImg.image = icon
            
            
        } else {
            
            let icon = UIImage(named: cardBrand)
            cardImg.image = icon
            last4CC.text = cardLast4Digits
            //cardID = card.Id
            
            
            
        }
        
        
        
        
        
    }
    
    @IBAction func editProfileBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToProfileVC", sender: nil)
        
    }
    
    @IBAction func starBtnPressed(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "moveToRatingVC", sender: nil)
        
    }
    
    
    
    func UpdateObserveForRider() {
        
        
        DataService.instance.mainDataBaseRef.child("trip_progressed").child(self.TripRiderResult.rider_UID).child(self.TripRiderResult.Trip_key).setValue(["Status": "Picked up", "Timestamp": ServerValue.timestamp()])
        
    }
    
    
    func updateUIForRating() {
        
        rateCount = 0
        tip = 0
        isTip = false
        self.blurView.isHidden = false
        self.ratingView.isHidden = false
        star1.setImage(UIImage(named: "starnofill"), for: .normal)
        star2.setImage(UIImage(named: "starnofill"), for: .normal)
        star3.setImage(UIImage(named: "starnofill"), for: .normal)
        star4.setImage(UIImage(named: "starnofill"), for: .normal)
        star5.setImage(UIImage(named: "starnofill"), for: .normal)
        
        
        // tip
        OneDollarTip.backgroundColor = UIColor.clear
        TwoDollarTip.backgroundColor = UIColor.clear
        FiveDollarTip.backgroundColor = UIColor.clear
        NoneDollarTip.backgroundColor = UIColor.clear
        self.ratingText.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
            
            
            
            
            self.ratingView.frame = CGRect(x: (UIScreen.main.bounds.width - 288) / 2, y: (UIScreen.main.bounds.height - 280) / 2, width: self.ratingView.frame.width, height: self.ratingView.frame.height)
            
            
            
            
            
        }), completion:  { (finished: Bool) in
            
            
            self.ratingTitle.text = "How was your driver?"
            
            
            
        })
        
        
        
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == ratingText {
            
            self.view.addGestureRecognizer(tapGesture)
            moveTextField(textField, moveDistance: -150, up: true)
            
        }
        
    }
    
    // Finish Editing The Text Field
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == ratingText {
            
            moveTextField(textField, moveDistance: -150, up: false)
            
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let _ = marker.title {
            
            
            marker.tracksInfoWindowChanges = true
            marker.tracksViewChanges = true
            checkCampusAgainWhenSearch()
            //closeRideMode()
            
            return false
        }
        
        
        return false
        
        
        
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        if let _ = marker.title {
            
            checkCampusAgainWhenSearch()
            //closeRideMode()
            
            
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    @IBAction func star1BtnPressed(_ sender: Any) {
        
        
        star1.setImage(UIImage(named: "star"), for: .normal)
        
        
        // unstar
        
        
        star2.setImage(UIImage(named: "starnofill"), for: .normal)
        star3.setImage(UIImage(named: "starnofill"), for: .normal)
        star4.setImage(UIImage(named: "starnofill"), for: .normal)
        star5.setImage(UIImage(named: "starnofill"), for: .normal)
        
        
        rateCount = 1
    }
    
    
    @IBAction func star2BtnPressed(_ sender: Any) {
        
        star1.setImage(UIImage(named: "star"), for: .normal)
        star2.setImage(UIImage(named: "star"), for: .normal)
        
        // unstar
        
        
        
        star3.setImage(UIImage(named: "starnofill"), for: .normal)
        star4.setImage(UIImage(named: "starnofill"), for: .normal)
        star5.setImage(UIImage(named: "starnofill"), for: .normal)
        
        
        rateCount = 2
    }
    
    @IBAction func star3BtnPressed(_ sender: Any) {
        
        star1.setImage(UIImage(named: "star"), for: .normal)
        star2.setImage(UIImage(named: "star"), for: .normal)
        star3.setImage(UIImage(named: "star"), for: .normal)
        // unstar
        
        
        
        star4.setImage(UIImage(named: "starnofill"), for: .normal)
        star5.setImage(UIImage(named: "starnofill"), for: .normal)
        
        
        rateCount = 3
        
    }
    
    @IBAction func star4BtnPressed(_ sender: Any) {
        
        star1.setImage(UIImage(named: "star"), for: .normal)
        star2.setImage(UIImage(named: "star"), for: .normal)
        star3.setImage(UIImage(named: "star"), for: .normal)
        star4.setImage(UIImage(named: "star"), for: .normal)
        // unstar
        
        
        
        star5.setImage(UIImage(named: "starnofill"), for: .normal)
        
        
        rateCount = 4
        
    }
    
    @IBAction func star5BtnPressed(_ sender: Any) {
        
        star1.setImage(UIImage(named: "star"), for: .normal)
        star2.setImage(UIImage(named: "star"), for: .normal)
        star3.setImage(UIImage(named: "star"), for: .normal)
        star4.setImage(UIImage(named: "star"), for: .normal)
        star5.setImage(UIImage(named: "star"), for: .normal)
        
        
        rateCount = 5
        
    }
    
    // Move the text field in a pretty animation!
    func moveTextField(_ textField: UITextField, moveDistance: Int, up: Bool) {
        let moveDuration = 0.3
        let movement: CGFloat = CGFloat(up ? moveDistance : -moveDistance)
        
        UIView.beginAnimations("animateTextField", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(moveDuration)
        self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
        UIView.commitAnimations()
        
    }
    
    func loadAverageRate(Rates: Float) {
        
        
        DataService.instance.mainDataBaseRef.child("Average_Rate").child("Driver").child(self.rate_driver_uid!).observeSingleEvent(of: .value, with: { (RateData) in
            
            if RateData.exists() {
                
                
                if let dict = RateData.value as? Dictionary<String, Any> {
                    
                    
                    if let RateGet = dict["Rate"] as? Float {
                        
                        
                        
                        let final = (RateGet + Rates) / 2
                        DataService.instance.mainDataBaseRef.child("Average_Rate").child("Driver").child(self.rate_driver_uid!).setValue(["Rate": final, "Timestamp": ServerValue.timestamp()])
                        
                    }
                    
                    
                }
                
                
            } else {
                
                
                DataService.instance.mainDataBaseRef.child("Average_Rate").child("Driver").child(self.rate_driver_uid!).setValue(["Rate": Rates, "Timestamp": ServerValue.timestamp()])
                
            }
            
            
        })
        
        
    }
    
    @IBAction func SubmitRatingBtnPressed(_ sender: Any) {
        
        if rateCount != 0, self.rate_driver_uid != nil  {
            
            
            if tip != 0 {
                
                
                
                let price = Double(self.tip)
                var roundedPrice = price.roundTo(places: 2)
                
                roundedPrice = roundedPrice * 100
                
                
                self.chargeForTip(charged: roundedPrice, name: self.Driver_Tip_name!, DriverUID: self.rate_driver_uid!)
                
                
                
            }
            
            self.pulsator.stop()
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 6, initialSpringVelocity: 1, options: UIViewAnimationOptions.curveEaseOut, animations: ({
                
                self.ratingView.frame = CGRect(x: UIScreen.main.bounds.width, y: UIScreen.main.bounds.height, width: self.ratingView.frame.width, height: self.ratingView.frame.height)
                
                
            }), completion:  { (finished: Bool) in
                
                self.ratingView.isHidden = true
                self.blurView.isHidden = true
                self.view.endEditing(true)
                
                if self.ratingText.text == "" || self.ratingText.text == "Comment" {
                    
                    self.ratingText.text = "nil"
                    
                }
                
                
                if self.rateCount == 5 {
                    
                    
                    DataService.instance.mainDataBaseRef.child("Rating").child("Driver").child(self.rate_driver_uid!).child("Five_star").child(self.trip_key!).setValue(["Rate": self.rateCount, "Text": self.ratingText.text, "Key": self.trip_key!, "Timestamp": ServerValue.timestamp()])
                    
                    
                }
                DataService.instance.mainDataBaseRef.child("Rating").child("Driver").child(self.rate_driver_uid!).child(self.trip_key!).setValue(["Rate": self.rateCount, "Text": self.ratingText.text, "Key": self.trip_key!, "Timestamp": ServerValue.timestamp()])
                
                
                DataService.instance.mainDataBaseRef.child("Missing_Rate").child("Rider").child(userUID).removeValue()
                
                self.loadAverageRate(Rates: Float(self.rateCount))
                
                
                self.ratingText.text = "Comment"
                
            })
            
        } else {
            
            
            self.showErrorAlert("Oops !!!", msg: "Please rate and comment your experience with the trip")
            
            
        }
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if ratingText.text == "Comment" {
            
            ratingText.text = ""
            
            
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        
        if ratingText.text == "Comment" ||  ratingText.text == ""{
            
            ratingText.text = "Comment"
            
            
            
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        if ratingView.isHidden != true {
            
            self.view.endEditing(true)
            
        }
        
    }
    
    // tip options
    
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
    
    // make charge for tip
    
    
    func chargeForTip(charged: Double, name: String, DriverUID: String) {
        
        
        self.isTip = true
        
        
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
        
        config.backgroundColor = UIColor.white
        config.spinnerColor = UIColor.black
        config.titleTextColor = UIColor.darkGray
        
        config.spinnerLineWidth = 5.0
        config.foregroundColor = UIColor.black
        config.foregroundAlpha = 0.7
        config.speed = 6
        
        
        SwiftLoader.setConfig(config: config)
        
        
        SwiftLoader.show(title: "Finding driver", animated: true)
        
    }
    
    
    
    
    func sendSmsNoti(Phone: String, text: String) {
        
        let url = MainAPIClient.shared.baseURLString
        let urls = URL(string: url!)?.appendingPathComponent("sms_noti")
        
        Alamofire.request(urls!, method: .post, parameters: [
            
            "phone": Phone,
            "body": text
            
            
            ])
            
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                
                switch responseJSON.result {
                    
                    
                case .success(let json):
                    
                    print( json)
                    
                case .failure(let err):
                    
                    print(err)
                }
                
        }
        
    }
    
    
    
    
    
    
}

extension MapView: CLLocationManagerDelegate {
    
    // check if auth is not nil then request auth
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // get my location with zoom 30
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            
            
            centerMapOnUserLocation()
            
        }
        
    }
    
    
}

extension UITableView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        
    }
}

extension MapView: PKPaymentAuthorizationViewControllerDelegate {
    
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
            
            
            if self.isTip == false {
                
                let price = Double(finalPrice)
                roundedPrice = price?.roundTo(places: 2)
                
                roundedPrice = roundedPrice! * 100
                
                description = "Authorize payment for request ride from Campus Connect at \(result)"
                
            } else {
                
                if self.tip != 0 {
                    
                    
                    
                    let price = Double(self.tip)
                    roundedPrice = price.roundTo(places: 2)
                    
                    roundedPrice = roundedPrice! * 100
                    
                    
                    if let name = self.Driver_Tip_name {
                        
                        description = "Tip to \(name) from Campus Connect at \(result)"
                    } else {
                        
                        description = "Tip to driver from Campus Connect at \(result)"
                        
                    }
                    
                    
                    
                    
                }
                
            }
            
            
            self.capturedKey = ""
            
            
            if let email = try? InformationStorage?.object(ofType: String.self, forKey: "email") {
                
                
                Alamofire.request(urls!, method: .post, parameters: [
                    
                    
                    
                    "cus_id": stripeID,
                    "amount": roundedPrice!,
                    "token": token!,
                    "captured": self.isTip,
                    "description": description,
                    "receipt_email": email!,
                    
                    
                    ])
                    
                    .validate(statusCode: 200..<500)
                    .responseJSON { responseJSON in
                        
                        switch responseJSON.result {
                            
                        case .success(let json):
                            
                            completion(PKPaymentAuthorizationStatus.success)
                            
                            if self.isTip == false {
                                
                                self.swiftLoader()
                                
                                self.makeDictForApplePay(json: json) {
                                    
                                    self.process_trip_request()
                                    
                                    ()
                                    
                                }
                                
                            } else {
                                
                                self.prepare_payDriver(price: roundedPrice!, DriverUID: self.rate_driver_uid!)
                                
                            }
                            
                            
                            
                            
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





extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}
extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}
extension Date {
    func addedBy(minutes:Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
}


