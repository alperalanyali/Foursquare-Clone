//
//  AttributesVC.swift
//  Foursquare Clone Firebase
//
//  Created by Alper on 20.10.2018.
//  Copyright © 2018 Alper. All rights reserved.
//

import UIKit

    var globalName = ""
    var globalType = ""
    var globalAtmosphere = ""
    var globalImage = UIImage()


class AttributesVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var typeText: UITextField!
    @IBOutlet weak var atmosphereText: UITextField!
    @IBOutlet weak var placeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        placeImage.addGestureRecognizer(gestureRecognizer)
        
        let hideKeyboardGR = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        self.view.addGestureRecognizer(hideKeyboardGR)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        globalName = ""
        globalType = ""
        globalAtmosphere = ""
        globalImage = UIImage()
    }
  
    @IBAction func nextBtnTapped(_ sender: Any) {
        if nameText.text != "" && typeText.text != "" && atmosphereText.text != "", let pickedImage = placeImage.image{
            globalName = nameText.text!
            globalType = typeText.text!
            globalAtmosphere = atmosphereText.text!
            globalImage = pickedImage
        }
        self.performSegue(withIdentifier: "fromAttributestoLocationVC", sender: nil)
        
        nameText.text = ""
        typeText.text = ""
        atmosphereText.text = ""
        placeImage.image = UIImage(named: "Tapme")
    
    }
    
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    @objc func selectImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        self.present(picker, animated: true, completion: nil)
        
    }

  @objc  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
}
