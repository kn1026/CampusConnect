//
//  becomeADriverVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/28/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import Firebase
import Cache
import SCLAlertView
import ZSWTappableLabel
import ZSWTaggedString
import SafariServices

class becomeADriverVC: UIViewController, ZSWTappableLabelTapDelegate {

    @IBOutlet weak var faceIdBtn: UIButton!
    @IBOutlet weak var socialBtn: UIButton!
    @IBOutlet weak var driverLicsBtn: UIButton!
    @IBOutlet weak var LicPlateBtn: UIButton!
    @IBOutlet weak var pictureOfCarBtn: UIButton!
    @IBOutlet weak var shippingBtn: UIButton!
    @IBOutlet weak var carRegistration: UIButton!
    
    
    @IBOutlet weak var submittedBtn: UIButton!
    @IBOutlet weak var socialTick: UIImageView!
    @IBOutlet weak var DriverLicsTick: UIImageView!
    @IBOutlet weak var LicsPlateTick: UIImageView!
    @IBOutlet weak var pictureOfCarTick: UIImageView!
    @IBOutlet weak var faceTick: UIImageView!
    
    @IBOutlet weak var carRegistrationTick: UIImageView!
    
    @IBOutlet weak var shippingAddressTick: UIImageView!

    var SSdownloadUrl: String?
    var DriverLicdownloadUrl: String?
    var LicPlatedownloadUrl: String?
    var CarRegistdownloadUrl: String?
    var Car1downloadUrl: String?
    var Car2downloadUrl: String?
    var faceIDPhotoUrl: String?
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var termView: UIView!
    
    @IBOutlet weak var termLbl: ZSWTappableLabel!
    
    
    static let URLAttributeName = NSAttributedStringKey(rawValue: "URL")
    
    enum LinkType: String {
        case Privacy = "Privacy"
        case TermsOfUse = "TOU"
        case CodeOfProduct = "COP"
        case IndependentContractorAgreement = "ICA"
        
        var URL: Foundation.URL {
            switch self {
            case .Privacy:
                return Foundation.URL(string: "http://campusconnectonline.com/wp-content/uploads/2017/07/Web-Privacy-Policy.pdf")!
            case .TermsOfUse:
                return Foundation.URL(string: "http://campusconnectonline.com/wp-content/uploads/2017/07/Website-Terms-of-Use.pdf")!
            case .CodeOfProduct:
                return Foundation.URL(string: "http://campusconnectonline.com/wp-content/uploads/2017/07/Driver-Code-of-Conduct-.pdf")!
            case .IndependentContractorAgreement:
                return Foundation.URL(string: "http://campusconnectonline.com/wp-content/uploads/2017/07/Independent-Contractor-Agreement.pdf")!
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setAlignmentForBnt()
        
        
        isShippingDone = false
        isCarRegistrationDone = false
        DriverLicsCheck = false
        LicsPlate = false
        photoOfCar = false
        socialSecurity = false
        faceID = false
        
        
        
        LicPlateImg = nil
        DriverLicImg = nil
        CarRegistImg = nil
        Car1Photo = nil
        Car2Photo = nil
        faceIDPhoto = nil
        
        
        Selectedadd1Txt = ""
        Selectedadd2Txt = ""
        SelectedCityTxt = ""
        SelectedStateTxt = ""
        SelectedzipcodeTxt = ""
        socialSecurityNum = ""
        DriverLicsFinal = ""
        StateLicsFinal = ""
        
        
        termLbl.tapDelegate = self
        
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
                .foregroundColor: UIColor.black,
                .underlineStyle: NSUnderlineStyle.styleSingle.rawValue,
                paymentVC.URLAttributeName: type.URL
                
            ]
        })
        
        //let string = NSLocalizedString("By clicking Sign Up or Skip, you agree to our <link type='TOU'>Terms of use</link>, <link type='Privacy'>Privacy Policy</link> and <link type='COP'>User Code of Conduct</link>.", comment: "")
        let string = NSLocalizedString("By clicking “Submit”, you agree to our <link type='TOU'>Terms of use</link>, <link type='Privacy'>Privacy Policy</link>, <link type='COP'>Driver Code of Conduct</link>, and <link type='ICA'>Independent Contractor Agreement</link>. Also, by clicking Submit, you agree and consent to a full personal background check and driving record check.", comment: "")
        
        termLbl.attributedText = try? ZSWTaggedString(string: string).attributedString(with: options)
        
    }
    
    func tappableLabel(_ tappableLabel: ZSWTappableLabel, tappedAt idx: Int, withAttributes attributes: [NSAttributedStringKey : Any] = [:]) {
        guard let URL = attributes[becomeADriverVC.URLAttributeName] as? URL else {
            return
        }
        
        if #available(iOS 9, *) {
            show(SFSafariViewController(url: URL), sender: self)
        } else {
            UIApplication.shared.openURL(URL)
        }
    }
    
    func uploadFaceImg(image: UIImage?, completed: @escaping DownloadComplete) {
        
        let metaData = StorageMetadata()
        let imageUID = UUID().uuidString
        metaData.contentType = "image/jpeg"
        var imgData = Data()
        imgData = UIImageJPEGRepresentation(image!, 1.0)!
        
        
        
        DataService.instance.FacetorageRef.child(imageUID).putData(imgData, metadata: metaData) { (meta, err) in
            
            if err != nil {
                
                SwiftLoader.hide()
                self.showErrorAlert("Oopss !!!", msg: "Error while saving your image, please try again")
                print(err?.localizedDescription as Any)
                
            } else {
                DataService.instance.FacetorageRef.child(imageUID).downloadURL(completion: { (url, err) in
                    guard let Url = url?.absoluteString else { return }
                    
                    let downUrl = Url as String
                    let downloadUrl = downUrl as NSString
                    let downloadedUrl = downloadUrl as String
                    
                    
                    self.faceIDPhotoUrl = downloadedUrl
                    
                    
                    completed()
                    
                })
                
            }
            
            
        }
        
    }
    
    func uploadLicPlateImg(image: UIImage?, completed: @escaping DownloadComplete) {
        
        
        let metaData = StorageMetadata()
        let imageUID = UUID().uuidString
        metaData.contentType = "image/jpeg"
        var imgData = Data()
        imgData = UIImageJPEGRepresentation(image!, 1.0)!
        
        
        
        DataService.instance.LicsPlateStorageRef.child(imageUID).putData(imgData, metadata: metaData) { (meta, err) in
            
            if err != nil {
                
                SwiftLoader.hide()
                self.showErrorAlert("Oopss !!!", msg: "Error while saving your image, please try again")
                print(err?.localizedDescription as Any)
                
            } else {
                
                DataService.instance.LicsPlateStorageRef.child(imageUID).downloadURL(completion: { (url, err) in
                    guard let Url = url?.absoluteString else { return }
                    
                    let downUrl = Url as String
                    let downloadUrl = downUrl as NSString
                    let downloadedUrl = downloadUrl as String
                    
                    
                    self.LicPlatedownloadUrl = downloadedUrl
                    
                    
                    completed()
                })
                
                
                
                
            }
            
            
        }
    }
    
    func uploadDriverLicImg(image: UIImage?, completed: @escaping DownloadComplete) {
        
        let metaData = StorageMetadata()
        let imageUID = UUID().uuidString
        metaData.contentType = "image/jpeg"
        var imgData = Data()
        imgData = UIImageJPEGRepresentation(image!, 1.0)!
        
        
        
        DataService.instance.DriverLicsStorageRef.child(imageUID).putData(imgData, metadata: metaData) { (meta, err) in
            
            if err != nil {
                
                SwiftLoader.hide()
                self.showErrorAlert("Oopss !!!", msg: "Error while saving your image, please try again")
                print(err?.localizedDescription as Any)
                
            } else {
                
                DataService.instance.DriverLicsStorageRef.child(imageUID).downloadURL(completion: { (url, err) in
                    guard let Url = url?.absoluteString else { return }
    
                    let downUrl = Url as String
                    let downloadUrl = downUrl as NSString
                    let downloadedUrl = downloadUrl as String
                    
                    self.DriverLicdownloadUrl = downloadedUrl
                    
                    
                    completed()
                })
                
                
            }
            
            
        }
        
    }
    
    func uploadCarRegistImg(image: UIImage?, completed: @escaping DownloadComplete) {
        
        
        let metaData = StorageMetadata()
        let imageUID = UUID().uuidString
        metaData.contentType = "image/jpeg"
        var imgData = Data()
        imgData = UIImageJPEGRepresentation(image!, 1.0)!
        
        
        
        DataService.instance.CarRegistStorageRef.child(imageUID).putData(imgData, metadata: metaData) { (meta, err) in
            
            if err != nil {
                
                SwiftLoader.hide()
                self.showErrorAlert("Oopss !!!", msg: "Error while saving your image, please try again")
                print(err?.localizedDescription as Any)
                
            } else {
                DataService.instance.CarRegistStorageRef.child(imageUID).downloadURL(completion: { (url, err) in
                    guard let Url = url?.absoluteString else { return }
                    
                    let downUrl = Url as String
                    let downloadUrl = downUrl as NSString
                    let downloadedUrl = downloadUrl as String
                    
                    
                    self.CarRegistdownloadUrl = downloadedUrl
                    
                    
                    completed()
                })
                
                
                
                
            }
            
            
        }
    }
    
    func uploadCarPhotoImg(image1: UIImage?, image2: UIImage?, completed: @escaping DownloadComplete) {
        
        let metaData = StorageMetadata()
        let imageUID = UUID().uuidString
        metaData.contentType = "image/jpeg"
        var imgData = Data()
        imgData = UIImageJPEGRepresentation(image1!, 1.0)!
        
        
        
        DataService.instance.PhotoOfCarStorageRef.child(imageUID).putData(imgData, metadata: metaData) { (meta, err) in
            
            if err != nil {
                
                SwiftLoader.hide()
                self.showErrorAlert("Oopss !!!", msg: "Error while saving your image, please try again")
                print(err?.localizedDescription as Any)
                
            } else {
                
                
                DataService.instance.PhotoOfCarStorageRef.child(imageUID).downloadURL(completion: { (url, err) in
                    guard let Url = url?.absoluteString else { return }
                    
                    let downUrl = Url as String
                    let downloadUrl = downUrl as NSString
                    let downloadedUrl = downloadUrl as String
                    self.Car1downloadUrl = downloadedUrl
                    
                    
                    let imageUIDs = UUID().uuidString
                    imgData = UIImageJPEGRepresentation(image2!, 1.0)!
                    DataService.instance.CarRegistStorageRef.child(imageUIDs).putData(imgData, metadata: metaData) { (meta, err) in
                        
                        if err != nil {
                            
                            SwiftLoader.hide()
                            self.showErrorAlert("Oopss !!!", msg: "Error while saving your image, please try again")
                            print(err?.localizedDescription as Any)
                            
                        } else {
                            
                            
                            DataService.instance.CarRegistStorageRef.child(imageUIDs).downloadURL(completion: { (url, err) in
                                guard let Url = url?.absoluteString else { return }
                                
                                let downUrl = Url as String
                                let downloadUrl = downUrl as NSString
                                let downloadedUrl = downloadUrl as String
                                self.Car2downloadUrl = downloadedUrl
                                completed()
                            })
                            
                            
                            
                            
                        }
                        
                        
                    }
                })
                
                
                
                
            }
            
            
        }
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if isShippingDone != false {
            
            shippingAddressTick.isHidden = false
            
        }
        if isCarRegistrationDone != false {
            
            carRegistrationTick.isHidden = false
            
        }
        if DriverLicsCheck != false {
            
            DriverLicsTick.isHidden = false
            
        }
        if LicsPlate != false {
            
            LicsPlateTick.isHidden = false
            
        }
        if photoOfCar != false {
            
            pictureOfCarTick.isHidden = false
            
        }
        if socialSecurity != false {
            
            socialTick.isHidden = false
            
        }
        
        if faceID != false {
            
            faceTick.isHidden = false
            
        }
        
        if isShippingDone != false, isCarRegistrationDone != false, DriverLicsCheck != false, LicsPlate != false, photoOfCar != false, socialSecurity != false, faceID != false {
            
            
            submittedBtn.setTitleColor(UIColor.black, for: .normal)
            
            
            
        } else {
            
            
            submittedBtn.setTitleColor(UIColor.groupTableViewBackground, for: .normal)
            
            
        }
        
        
        
    }
    
    func setAlignmentForBnt() {
        
        
        socialBtn.contentHorizontalAlignment = .left
        driverLicsBtn.contentHorizontalAlignment = .left
        LicPlateBtn.contentHorizontalAlignment = .left
        pictureOfCarBtn.contentHorizontalAlignment = .left
        shippingBtn.contentHorizontalAlignment = .left
        carRegistration.contentHorizontalAlignment = .left
        
        faceIdBtn.contentHorizontalAlignment = .left
        
    }
    

    @IBAction func backBtn1Pressed(_ sender: Any) {
        
       
        let sheet = UIAlertController(title: "Are you sure to go back? ", message: "f you go back, all of your information will be cleared and you will need to upload all of the forms again.", preferredStyle: .alert)
        
        
        let oke = UIAlertAction(title: "Ok", style: .default) { (alert) in
            
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alert) in
            
            
           
            
        }
        
        
        
        sheet.addAction(oke)
        sheet.addAction(cancel)
        present(sheet, animated: true, completion: nil)
        
    }
    
    @IBAction func backBtn2Pressed(_ sender: Any) {
        
        
        
        let sheet = UIAlertController(title: "Are you sure?", message: "If you go back, all your information will be cleared and you need to fill out all the forms again", preferredStyle: .alert)
        
        
        let oke = UIAlertAction(title: "Ok", style: .default) { (alert) in
            
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alert) in
            
            
            
            
        }
        
        
        
        sheet.addAction(oke)
        sheet.addAction(cancel)
        present(sheet, animated: true, completion: nil)
        
    }
    
    @IBAction func faceIDBtnPressed(_ sender: Any) {
        
        
        self.performSegue(withIdentifier: "moveToFaceIDVC", sender: nil)
        
    }
    @IBAction func moveToDriverLicsBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToDriverLicVC", sender: nil)
        
        
    }
    
    @IBAction func moveToSocialBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToSocialVC", sender: nil)
        
    }
    
    @IBAction func moveToLicPlateBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToLicPlateVC", sender: nil)
        
    }
    
    @IBAction func moveToPictureOfCarBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToPhotoOfCarVC", sender: nil)
        
    }
    
    @IBAction func moveToCarRegistrationBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToCarRegistrationVC", sender: nil)
        
    }
    
    @IBAction func moveToShippingAddressBtnPressed(_ sender: Any) {
        
        self.performSegue(withIdentifier: "moveToShippingVC", sender: nil)
        
    }
    
    @IBAction func submitBtnPressed(_ sender: Any) {
        
        
        if isShippingDone != false, isCarRegistrationDone != false, DriverLicsCheck != false, LicsPlate != false, photoOfCar != false, socialSecurity != false, faceID != false {
            
            
            submittedBtn.isHidden = true
            blurView.isHidden = false
            termView.isHidden = false
            
        } else {
            
            
            
            showErrorAlert("Oops!", msg: "Please finish uploading all your information to continue")
            
        }
        
    }
    
    func uploadData() {
        
        swiftLoader()
        
        self.uploadLicPlateImg(image: LicPlateImg) {
            
            
            self.uploadCarRegistImg(image: CarRegistImg) {
                
                
                    self.uploadCarPhotoImg(image1: Car1Photo, image2: Car2Photo) {
                        
                        
                        self.uploadFaceImg(image: faceIDPhoto) {
                            
                            
                            if let birthday = try? InformationStorage?.object(ofType: String.self, forKey: "birthday") {
                                
                                if let phone = try? InformationStorage?.object(ofType: String.self, forKey: "phone") {
                                    
                                    if let name = try? InformationStorage?.object(ofType: String.self, forKey: "user_name") {
                                        
                                        if let email = try? InformationStorage?.object(ofType: String.self, forKey: "email") {
                                            
                                            if let campus = try? InformationStorage?.object(ofType: String.self, forKey: "campus") {
                                                
                                                if Selectedadd2Txt != "" {
                                                    
                                                    
                                                    let Application: Dictionary<String, AnyObject> = ["SSNum": socialSecurityNum as AnyObject, "DriverLicdownloadUrl": self.DriverLicdownloadUrl as AnyObject, "DriverFaceIDdownloadUrl": self.faceIDPhotoUrl as AnyObject, "LicPlatedownloadUrl": self.LicPlatedownloadUrl as AnyObject, "CarRegistdownloadUrl": self.CarRegistdownloadUrl as AnyObject,"Timestamp": ServerValue.timestamp() as AnyObject, "userUID": userUID as AnyObject, "Car1downloadUrl": self.Car1downloadUrl as AnyObject, "Car2downloadUrl": self.Car2downloadUrl as AnyObject, "campus": campus as AnyObject, "email": email as AnyObject, "user_name": name as AnyObject, "phone": phone as AnyObject,"Selectedadd1Txt": Selectedadd1Txt as AnyObject, "Selectedadd2Txt": Selectedadd2Txt as AnyObject, "SelectedCityTxt": SelectedCityTxt as AnyObject, "SelectedStateTxt": SelectedStateTxt as AnyObject, "SelectedzipcodeTxt": SelectedzipcodeTxt as AnyObject, "DriverLics": DriverLicsFinal as AnyObject,"StateLics": StateLicsFinal as AnyObject, "Birthday": birthday as AnyObject]
                                                    DataService.instance.mainDataBaseRef.child("Application_Request").child("New").child(userUID).setValue(Application)
                                                    DataService.instance.mainDataBaseRef.child("Application_Request").child("Total").child(userUID).setValue(Application)
                                                    
                                                    
                                                } else {
                                                    
                                                    
                                                    let Application: Dictionary<String, AnyObject> = ["SSNum": socialSecurityNum as AnyObject, "DriverFaceIDdownloadUrl": self.faceIDPhotoUrl as AnyObject, "DriverLicdownloadUrl": self.DriverLicdownloadUrl as AnyObject, "LicPlatedownloadUrl": self.LicPlatedownloadUrl as AnyObject, "CarRegistdownloadUrl": self.CarRegistdownloadUrl as AnyObject,"Timestamp": ServerValue.timestamp() as AnyObject, "userUID": userUID as AnyObject, "Car1downloadUrl": self.Car1downloadUrl as AnyObject, "Car2downloadUrl": self.Car2downloadUrl as AnyObject, "campus": campus as AnyObject, "email": email as AnyObject, "user_name": name as AnyObject, "phone": phone as AnyObject,"Selectedadd1Txt": Selectedadd1Txt as AnyObject, "Selectedadd2Txt": "nil" as AnyObject, "SelectedCityTxt": SelectedCityTxt as AnyObject, "SelectedStateTxt": SelectedStateTxt as AnyObject, "SelectedzipcodeTxt": SelectedzipcodeTxt as AnyObject, "DriverLics": DriverLicsFinal as AnyObject,"StateLics": StateLicsFinal as AnyObject, "Birthday": birthday as AnyObject]
                                                    
                                                    
                                                    DataService.instance.mainDataBaseRef.child("Application_Request").child("New").child(userUID).setValue(Application)
                                                    DataService.instance.mainDataBaseRef.child("Application_Request").child("Total").child(userUID).setValue(Application)
                                                    
                                                }
                                                
                                                
                                                SwiftLoader.hide()
                                                
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
                                                    
                                                    
                                                    self.dismiss(animated: true, completion: nil)
                                                    
                                                    
                                                }
                                                
                                                let icon = UIImage(named:"lg1")
                                                
                                                _ = alert.showCustom("Congratulations!", subTitle: "You successfully submitted the application to become a driver for Campus Connect, we will process your application soon and reach back out to you by phone and email", color: UIColor.black, icon: icon!)
                                                
                                                
                                            }
                                            
                                        }
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                            
      
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        
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
    
    @IBAction func acceptTermBtnPressed(_ sender: Any) {
        
        blurView.isHidden = true
        termView.isHidden = true
        uploadData()
        
    }
    
    @IBAction func declineTermBtnPressed(_ sender: Any) {
        
        blurView.isHidden = true
        termView.isHidden = true
        submittedBtn.isHidden = false
        
    }
    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
}
