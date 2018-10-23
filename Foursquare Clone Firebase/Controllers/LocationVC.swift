//
//  LocationVC.swift
//  Foursquare Clone Firebase
//
//  Created by Alper on 20.10.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth



var allLocUuid = [String]()

class LocationVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {


    @IBOutlet weak var mapView: MKMapView!
    var manager = CLLocationManager()
    var savedLongitude = ""
    var savedLatitude = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        Show random place
//        let latitude: CLLocationDegrees = 38.453369
//        let longitude: CLLocationDegrees = 27.097099
//
//        let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//
//        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//
//        let region: MKCoordinateRegion = MKCoordinateRegion(center: location, span: span)
//
//        mapView.setRegion(region, animated: true)
      
        mapView.delegate = self
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
       
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(pressGesture(gestureRecognizer: )))
        recognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(recognizer)
       
        
        
    }
    
   
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated:true, completion: nil)
    }
    @IBAction func saveBtnTapped(_ sender: Any) {
        storeImage()
        print("Save Button was tapped.")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromLocationtoPlaceVC"{
            let placeVC = segue.destination  as! PlacesVC
            placeVC.placeLatitudeArray.append(self.savedLatitude)
            placeVC.placeLongitudeArray.append(self.savedLongitude)
        }
    }
    
    func storeImage() {
        let image = Storage.storage().reference().child("media")
        if let data = globalImage.jpegData(compressionQuality: 0.5){
            let uuid = NSUUID().uuidString
            let imageRef = image.child("\(uuid).jpeg")
            imageRef.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
                    alert.addAction(okBtn)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    imageRef.downloadURL(completion: { (url, error) in
                        if error == nil {
                            let imageURL = url?.absoluteString
                           let locuuid = NSUUID().uuidString
                            let currentUser = Auth.auth().currentUser?.email!
                            let location = ["image": imageURL!,"locationname": globalName,"locationtype": globalType, "locationatmosphere": globalAtmosphere,"locuuid":locuuid,"email": currentUser!,"latitude": self.savedLatitude, "longitude": self.savedLongitude]
                           allLocUuid.append(locuuid)
                           
                            let locData = Database.database().reference().child("locations").child(locuuid)
                      
                            locData.setValue(location)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newLocation"), object: nil)
                            self.performSegue(withIdentifier: "fromLocationtoPlacesVC", sender: nil)
                            
                        }
                    })
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        let currentLocation = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        
        savedLatitude = String(currentLocation.latitude)
        savedLongitude = String(currentLocation.longitude)
        manager.stopUpdatingLocation()
        
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: currentLocation, span: span)
        mapView.setRegion(region, animated: true)
        
    }
    
    @objc func pressGesture(gestureRecognizer: UIGestureRecognizer){
        
        
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinates
            annotation.title = globalName
            annotation.subtitle = globalType
            
            self.mapView.addAnnotation(annotation)
            
            
        }
    }
    
    
    
    
    
    
}
