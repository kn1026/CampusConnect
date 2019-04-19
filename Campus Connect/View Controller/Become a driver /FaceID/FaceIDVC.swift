//
//  FaceIDVC.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 9/2/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit
import AVFoundation
import Firebase
import FirebaseAuth
import Alamofire
import Cache
import SwiftOCR
import CoreImage

class FaceIDVC: UIViewController, UINavigationControllerDelegate {

    let swiftOCRInstance = SwiftOCR()
    
    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet weak var faceImg: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if faceIDPhoto != nil {
            
            previewView.isHidden = false
            faceImg.image = faceIDPhoto
            
        }
        
        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backBtn1Pressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cameraBtnPressed(_ sender: Any) {
        
        let sheet = UIAlertController(title: "Upload our face ID", message: "", preferredStyle: .actionSheet)
        
        
        let camera = UIAlertAction(title: "Take a new photo", style: .default) { (alert) in
            
            self.camera()
            
        }
        
        let album = UIAlertAction(title: "Upload from album", style: .default) { (alert) in
            
            self.album()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            
        }
        
        
        sheet.addAction(camera)
        sheet.addAction(album)
        sheet.addAction(cancel)
        self.present(sheet, animated: true, completion: nil)
        
        
    }
    
    func album() {
        
        self.getMediaFrom(kUTTypeImage as String)
        
        
    }
    
    func camera() {
        
        
        
        self.getMediaCamera(kUTTypeImage as String)
        
    }
    
    // get media
    
    func getMediaFrom(_ type: String) {
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.allowsEditing = true
        mediaPicker.mediaTypes = [type as String]
        self.present(mediaPicker, animated: true, completion: nil)
    }
    
    func getMediaCamera(_ type: String) {
        
        
        let mediaPicker = UIImagePickerController()
        mediaPicker.delegate = self
        mediaPicker.allowsEditing = true
        mediaPicker.mediaTypes = [type as String] //UIImagePickerController.availableMediaTypes(for: .camera)!
        mediaPicker.sourceType = .camera
        self.present(mediaPicker, animated: true, completion: nil)
        
    }
    
    func getImage(image: UIImage) {
        
        
        faceImg.image = image
        previewView.isHidden = false
        
        let img = swiftOCRInstance.preprocessImageForOCR(image)
        
        swiftOCRInstance.recognize(img) { recognizedString in
            print(recognizedString)
        }
        
        
        
        // done
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        
        previewView.isHidden = true
        faceImg.image = nil
        
    }
    
    @IBAction func cancel1BtnPressed(_ sender: Any) {
        
        previewView.isHidden = true
        faceImg.image = nil
        
    }
    
    @IBAction func retakeBtnPressed(_ sender: Any) {
        
        let sheet = UIAlertController(title: "Upload your face ID", message: "", preferredStyle: .actionSheet)
        
        
        let camera = UIAlertAction(title: "Take a new photo", style: .default) { (alert) in
            
            self.camera()
            
        }
        
        let album = UIAlertAction(title: "Upload from album", style: .default) { (alert) in
            
            self.album()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            
        }
        
        
        sheet.addAction(camera)
        sheet.addAction(album)
        sheet.addAction(cancel)
        self.present(sheet, animated: true, completion: nil)
        
    }
    @IBAction func DoneBtnPressed(_ sender: Any) {
        
        
        if detect(FaceID: faceImg) ==  true {
            
            faceID = true
            faceIDPhoto = faceImg.image
            self.dismiss(animated: true, completion: nil)
            
        } else {
            
            self.showErrorAlert("Oops!", msg: "Can't recognize your face or your eyes are closed, please upload or take a clear photo of your face again")
        }
        
        
        
        
    }
    
    
    func detect(FaceID: UIImageView) -> Bool {
        
        guard let personciImage = CIImage(image: FaceID.image!) else {
            return false
        }
        
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy)
        let faces = faceDetector?.features(in: personciImage)
        
        // Convert Core Image Coordinate to UIView Coordinate
        let ciImageSize = personciImage.extent.size
        var transform = CGAffineTransform(scaleX: 1, y: -1)
        transform = transform.translatedBy(x: 0, y: -ciImageSize.height)
        
        for face in faces as! [CIFaceFeature] {
            
  
            if face.hasLeftEyePosition && face.hasRightEyePosition && face.hasMouthPosition && face.rightEyeClosed == false && face.leftEyeClosed == false {
                return true
            } else {
                return false
            }
            
            
        }
        
        return false
    }


    // func show error alert
    
    func showErrorAlert(_ title: String, msg: String) {
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }

}



extension FaceIDVC: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            getImage(image: editedImage)
        } else if let originalImage =
            info["UIImagePickerControllerOriginalImage"] as? UIImage {
            getImage(image: originalImage)
        }
        
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
        
    }
}
