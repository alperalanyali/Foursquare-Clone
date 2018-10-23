//
//  PlacesVC.swift
//  Foursquare Clone Firebase
//
//  Created by Alper on 19.10.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import UIKit
import  FirebaseAuth
import FirebaseDatabase


class PlacesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var placeNameArray = [String]()
    var placeLatitudeArray = [String]()
    var placeLongitudeArray = [String]()
    
    
    var tappedPlace = ""
    var tappedLatitude = ""
    var tappedLongitude  = ""
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        getDataFromServer()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(getDataFromServer), name: NSNotification.Name(rawValue: "newLocation"), object: nil)
    }
    
    @IBAction func logOutBtnTapped(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "userLoggedIn")
        UserDefaults.standard.synchronize()
        let signIn = self.storyboard?.instantiateViewController(withIdentifier: "SignInVC")
        let delegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window?.rootViewController = signIn
        delegate.rememberLogIn()
        
    }
    
    @objc  func getDataFromServer() {
        
        Database.database().reference(withPath: "locations").observe(.childAdded) { (snapshot) in
            if let locDic = snapshot.value as? NSDictionary {
                self.placeNameArray.append(locDic["locationname"] as! String)
                self.placeLatitudeArray.append(locDic["latitude"] as! String)
                self.placeLongitudeArray.append(locDic["longitude"] as! String)
                self.tableView.reloadData()
            }
        }
    }
    
     
    @IBAction func addBtnTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "fromPlacestoAttributesVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromPlacestoDetailsVC" {
            let destinationVC = segue.destination as! DetailsVC
            destinationVC.chosenPlace = self.tappedPlace
            destinationVC.chosenLatitude = self.tappedLatitude
            destinationVC.chosenLongitude = self.tappedLongitude
           
        }
    }
    // Functions for tableView
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tappedPlace = placeNameArray[indexPath.row]
        self.tappedLatitude = placeLatitudeArray[indexPath.row]
        self.tappedLongitude = placeLongitudeArray[indexPath.row]
        
        
        performSegue(withIdentifier: "fromPlacestoDetailsVC", sender: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(self.placeNameArray[indexPath.row])"
        return cell
    }
    

}
