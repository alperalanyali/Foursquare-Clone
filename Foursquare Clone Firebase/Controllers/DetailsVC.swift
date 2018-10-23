//
//  DetailsVC.swift
//  Foursquare Clone Firebase
//
//  Created by Alper on 20.10.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class DetailsVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeNameLbl: UILabel!
    @IBOutlet weak var placeTypeLbl: UILabel!
    @IBOutlet weak var placeAtmosphereLbl: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var manager = CLLocationManager()
    var chosenPlace = ""
    var chosenType = ""
    var chosenLatitude = ""
    var chosenLongitude = ""
    var requestCLLocation = CLLocation()
    
    var longitude = ""
    var latitude = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        print(chosenPlace)
        findPlacefromServer()
     
    }

    }
    func findPlacefromServer() {
        DispatchQueue.main.async {
            Database.database().reference().child("locations").observe(.childAdded){ (snapshot) in
                
                let values = snapshot.value as! [String:String]
                for _ in values  {
                    if self.chosenPlace == values["locationname"]{
                        self.placeNameLbl.text = "Name: \(String(describing: values["locationname"]!))"
                        self.placeTypeLbl.text = "Type: \(String(describing: values["locationtype"]!))"
                        self.chosenType = String(values["locationtype"]!)
                        self.placeAtmosphereLbl.text = "Atmosphere: \(String(describing: values["locationatmosphere"]!))"
                        self.latitude = values["latitude"]!
                        self.longitude = values["longitude"]!
                     
                        let pathReference = Storage.storage().reference(forURL: values["image"]!)
                        pathReference.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
                            if error != nil {
                                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                                let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alert.addAction(okBtn)
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                let image = UIImage(data: data!)
                                self.placeImage.image = image
                            }
                        }
                    }
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        if chosenLatitude.isEmpty == false && chosenLongitude.isEmpty == false {
            let location = CLLocationCoordinate2D(latitude: Double(self.chosenLatitude)!, longitude: Double(self.chosenLongitude)!)
            let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            let region = MKCoordinateRegion(center: location, span: span)
            self.mapView.setRegion(region, animated: true)

            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "\(self.chosenPlace)"
            annotation.subtitle = "\(self.chosenType)"
            self.mapView.addAnnotation(annotation)

        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            print("Annotation is MKUserLocation")
            return nil
        }
        
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            let button = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else {
            pinView?.annotation = annotation
        }
        return pinView
        
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if self.chosenLatitude.isEmpty == false && self.chosenLongitude.isEmpty == false {
            
            self.requestCLLocation = CLLocation(latitude: Double(self.chosenLatitude)!, longitude: Double(self.chosenLongitude)!)
            
            CLGeocoder().reverseGeocodeLocation(self.requestCLLocation) { (placemarks, error) in
                if let placemark = placemarks {
                    if placemark.count > 0 {
                        let mkPlaceMark = MKPlacemark(placemark: placemark[0])
                        let mapItem = MKMapItem(placemark: mkPlaceMark)
                        mapItem.name = self.chosenPlace
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMaps(launchOptions: launchOptions)
                    }
                }
            }
        }
      
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    }




