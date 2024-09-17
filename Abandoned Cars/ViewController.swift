//
//  ViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 4/12/24.
//
import FirebaseFirestore
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    let database = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userName.delegate = self
        zipcode.delegate = self
    }
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var zipcode: UITextField!
    
    @IBAction func clickBtn(_ sender: UIButton) {
        
        let usersCollection = database.collection("users")
        let uuid = UUID().uuidString
        let documentReference = usersCollection.document(uuid)
        documentReference.setData([
            "zipcode" : zipcode.text ?? 99,
            "user_name" : userName.text ?? "error"
        ])
        
        
        let carCollection = database.collection("cars")
        let carReference = carCollection.document()
       // carReference.setData(["user_id" : uuid ])
        
        
        let zipSaved = zipcode.text ?? ""
        
        UserDefaults.standard.set(zipSaved, forKey: "zipSaved")
        
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as? MainMenuViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Hide the keyboard when return key is pressed
            userName.resignFirstResponder()
            zipcode.resignFirstResponder()
            return true
        }
    
   


}

