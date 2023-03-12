//
//  SubmitViewController.swift
//  On The Map
//
//  Created by Can Yıldırım on 23.02.2023.
//

import Foundation
import UIKit
import MapKit

class SubmitViewController : UIViewController {
    
    @IBOutlet weak var mapView : MKMapView!
    
    
    var studentInformation : StudentInformation?
    
    override func viewDidLoad() {
                
        super.viewDidLoad()
 
        if let studentLocation = studentInformation {
            
            let studentLocation = UserLocationRequest(
                
                uniqueKey: studentLocation.uniqueKey,
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mapString: studentLocation.mapString ?? "",
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: studentLocation.createdAt,
                updatedAt: studentLocation.updatedAt,
                objectId: studentLocation.objectId
            )
            showLocations(location: studentLocation)
        }
    
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        
        self.dismiss(animated: true)
        
    }
    
    @IBAction func submit(_ sender: Any) {
        
        if let studentLocation = studentInformation {
            
            if OTMClient.Auth.objectId == "" {
                
                OTMClient.postUserLocation(info: studentLocation) { success, error in
                    
                    if success {
                        
                        self.dismiss(animated: true)
                        
                    } else {
                        
                        self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                        
                    }
                    
                }
                
            } else {
                
       let alert = UIAlertController(title: "" , message: "You Have Already Posted a Student Location. Would You Like to Overwrite Your Current Location?", preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
       OTMClient.updateUserLocation(info: studentLocation) { success, error in
                        
           if success {
                            
              self.dismiss(animated: true)
             
                            
             } else {
                        
               self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
      
                        }
                    }
                    
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                    alert.dismiss(animated: true)
                }))
                
                self.present(alert, animated: true)
            }

        }
       
    }
    
    private func showLocations(location: UserLocationRequest) {
         mapView.removeAnnotations(mapView.annotations)
         if let coordinate = extractCoordinate(location: location) {
             let annotation = MKPointAnnotation()
             annotation.title = "\(location.firstName) \(location.lastName)"
             annotation.subtitle = location.mediaURL
             annotation.coordinate = coordinate
             mapView.addAnnotation(annotation)
             mapView.showAnnotations(mapView.annotations, animated: true)
         }
     }
     
     private func extractCoordinate(location: UserLocationRequest) -> CLLocationCoordinate2D? {
         if let lat = location.latitude, let lon = location.longitude {
             return CLLocationCoordinate2DMake(lat, lon)
         }
         return nil
     }
    
}
