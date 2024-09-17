//
//  CarDetailsViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 4/16/24.
//

import UIKit
import FirebaseFirestore

class CarDetailsViewController: UIViewController, UITextFieldDelegate {
   
    
    let database = Firestore.firestore()
    
    let defaults = UserDefaults.standard
    
    @IBOutlet weak var makeInput: UITextField!
    
    @IBOutlet weak var modelInput: UITextField!
    
    @IBOutlet weak var colorInput: UITextField!
    
    @IBOutlet weak var licenseInput: UITextField!
    
    @IBOutlet weak var vinInput: UITextField!
    
    @IBOutlet weak var numberOfDays: UILabel!
    
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func durationInput(_ sender: Any) {
        numberOfDays.text = String(Int(slider.value))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeInput.delegate = self
        modelInput.delegate = self
        colorInput.delegate = self
        licenseInput.delegate = self
//        vinInput.delegate = self
       
        
        numberOfDays.text = String(Int(slider.value))
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard when return key is pressed
        makeInput.resignFirstResponder()
        modelInput.resignFirstResponder()
        colorInput.resignFirstResponder()
        licenseInput.resignFirstResponder()
    //    vinInput.resignFirstResponder()
        return true
    }
    
    
    @IBAction func submitBtn(_ sender: Any) {
        
        let make = makeInput.text ?? "" 
        let models = modelInput.text ?? ""
        let color = colorInput.text ?? ""
        let license  = licenseInput.text ?? ""
//        let vinNum = vinInput.text ?? ""
        let duration = numberOfDays.text ?? ""
        
        var newData = [
            "make" : make ,
            "models" : models,
            "color" : color,
            "license_number" : license,
    //        "vin_number" : vinNum,
            "duration" : duration
            ]
        
        let id = self.defaults.string(forKey: "docId") ?? ""
        
        database.collection("cars").document(id).updateData(newData as [AnyHashable : Any])
        {
            error in
            if let error = error{
                print("Error updating car details data")
            }else {
                print("Car details successfully updated")
            }
            
            
            if let VC = self.storyboard?.instantiateViewController(withIdentifier: "ReportEndViewController" )as?  ReportEndViewController
            {
                self.navigationController?.pushViewController(VC, animated: true)
            }
            
        }
    }
    

}
