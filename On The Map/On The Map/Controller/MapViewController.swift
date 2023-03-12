//
//  MapViewController.swift
//  On The Map
//
//  Created by Can Yıldırım on 23.02.2023.
//

import MapKit
import UIKit

class MapViewController : UIViewController {
    

    @IBOutlet weak var mapView: MKMapView!
    
    var locations = [StudentInformation]()
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OTMClient.getStudentLocation(completion: handleGetStudentLocation(studentLocations:error:))
        
    }
    
    
    @IBAction func refreshButton(_ sender: UIBarButtonItem) {
        
        OTMClient.getStudentLocation(completion: handleGetStudentLocation(studentLocations:error:))
        
    }
    
    func handleGetStudentLocation(studentLocations: [StudentInformation], error: Error?) {
     
        locations = studentLocations
        self.mapView.removeAnnotations(self.annotations)
        self.annotations.removeAll()
        
        for dictionary in locations {

            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)

            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL

            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL

            annotations.append(annotation)
        }

        self.mapView.addAnnotations(annotations)
     
    }

    
}

extension MapViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView
        
        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.tintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            pinView!.rightCalloutAccessoryView?.tintColor = .systemBlue
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        if control == view.rightCalloutAccessoryView {
                       
            if let toOpen = view.annotation?.subtitle! {
                
                guard let url = URL(string: toOpen), UIApplication.shared.canOpenURL(url) else {
                    showAlert(message: "Cannot open link.", title: "Invalid Link")
                    return
                }
                UIApplication.shared.open(url, options: [:])
           }
    
       }
        
  }
    
     }

