//
//  LocationViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 4/16/24.
//

import UIKit
import FirebaseFirestore
import CoreLocation

class LocationViewController: UIViewController, UITextFieldDelegate {
    
    var fowardedString : String?
    
    let defaults = UserDefaults.standard
    
    let database = Firestore.firestore()
    
    @IBAction func continueBtn(_ sender: Any) {
        
        addressToPin( )
            if let VC = self.storyboard?.instantiateViewController(withIdentifier: "CarDetailsViewController") as? CarDetailsViewController {
              self.navigationController?.pushViewController(VC, animated: true)
            }
    }
    
    @IBAction func locationBtn(_ sender: Any) {
       
        getDocumentName()
        if let VC = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    
    @IBOutlet weak var streetName: UITextField!
    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var stateName: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        streetName.delegate = self
        cityName.delegate = self
        stateName.delegate = self
        zipcode.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            streetName.resignFirstResponder()
            cityName.resignFirstResponder()
            stateName.resignFirstResponder()
            zipcode.resignFirstResponder()
            return true
        }
    
    func addressToPin( ){
        
        getDocumentName()
        
        let geocoder = CLGeocoder()
        
        let street = streetName.text ?? ""
        let city = cityName.text ?? ""
        let state = stateName.text ?? ""
        let zipcode = zipcode.text ?? ""
        
        let location = "\(street) , \(city) , \(state) , \(zipcode)"
        
        geocoder.geocodeAddressString(location) {(placemarks, error) in
            
            if let error = error {
                
                print ("Geo location failed ")
                return
            }
            if let placemark = placemarks?.first {
                let cooridinate = placemark.location?.coordinate
                print("latitude: \(String(describing: cooridinate?.latitude))   &&  longitude: \(String(describing: cooridinate?.longitude))")
                
                let newData = [
                    "latitude": cooridinate?.latitude,
                    "longitude": cooridinate?.longitude
                ]
                let id = self.defaults.string(forKey: "docId") ?? ""
                
                print("&&&&&&&&&&&&&&&&&&&&")
                print(id)
                self.database.collection("cars").document(id).updateData(newData as [AnyHashable : Any])
                { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Document successfully updated")
                    }
                }
                
            } else {
                print("No placemark found for the provided address.")
            }
            
        }
    }
    
    func getDocumentName(){
        
        let carCollection = database.collection("cars")
        let carReference = carCollection.document()
        guard let forwardedWord = fowardedString else { return }
        print(forwardedWord)
        
        carCollection.whereField("group_id", isEqualTo: forwardedWord)
                     .order(by: "timestamp", descending: true)
                     .limit(to: 1).getDocuments{ (querySnapshot, error) in
                         
                         if let error = error {
                             print("Error getting documents: \(error)")
                         } else {
                             // Check if there are any documents returned
                             guard let document = querySnapshot?.documents.first else {
                                 print("No documents found")
                                 return
                             }
                             
                             // Access the document ID
                             let documentID = document.documentID
                             self.defaults.set(documentID, forKey: "docId")
                             
                         }
                     }
    }
}
