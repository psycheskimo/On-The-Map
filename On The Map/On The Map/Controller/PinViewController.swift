//
//  PinViewController.swift
//  On The Map
//
//  Created by Can Yıldırım on 23.02.2023.
//

import UIKit
import MapKit

class PinViewController : UIViewController {
    
    
    @IBOutlet weak var enterLocationTextfield : UITextField!
    @IBOutlet weak var shareLinkTextField : UITextField!
    
    
    var objectId : String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        changePlaceHolderColor(textfield: enterLocationTextfield, text: "Enter Your Location Here")
        changePlaceHolderColor(textfield: shareLinkTextField, text: "Enter a Link To Share Here")

    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    
    @IBAction func findOnTheMap(_ sender: UIButton) {
        
        let newLocation = enterLocationTextfield.text
        forwardGeocoding(newLocation: newLocation ?? "")
     
    }

    func forwardGeocoding(newLocation: String) {
            
        CLGeocoder().geocodeAddressString(newLocation) { newMarker, error in
                
                if let error = error {
                    
                    self.showAlert(message: error.localizedDescription, title: "Location Not Found")

                } else {
                    
                    var location: CLLocation?
                    
                    if let marker = newMarker, marker.count > 0 {
                        location = marker.first?.location
                    }
                    
                    if let location = location {

                        self.loadNewLocation(location.coordinate)
                        
                    } else {
                        
                        self.showAlert(message: "Please try again later.", title: "Error")

                    }
                }
            }
        }
    
    private func loadNewLocation(_ coordinate: CLLocationCoordinate2D) {
        
        let controller = storyboard?.instantiateViewController(withIdentifier: "SubmitViewController") as! SubmitViewController
        
        controller.studentInformation = buildStudentInfo(coordinate)
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: true)
        
    }
    
    private func buildStudentInfo(_ coordinate: CLLocationCoordinate2D) -> StudentInformation {
            
            var studentInfo = [
                "uniqueKey": OTMClient.Auth.key,
                "firstName": OTMClient.Auth.firstName,
                "lastName": OTMClient.Auth.lastName,
                "mapString": enterLocationTextfield.text!,
                "mediaURL" : shareLinkTextField.text!,
                "latitude": coordinate.latitude,
                "longitude": coordinate.longitude,
                ] as [String: AnyObject]
            
            if let objectId = objectId {
                studentInfo["objectId"] = objectId as AnyObject
                print(objectId)
            }

        return StudentInformation(studentInfo)

        }
        
    func changePlaceHolderColor(textfield: UITextField , text: String) {
       
        let emailPlaceHolder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        
        textfield.attributedPlaceholder = emailPlaceHolder
    
    }
    
}
