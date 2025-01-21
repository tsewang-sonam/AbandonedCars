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
//        UserDefaults.standard.set(true, forKey: "HasCompletedFirstView")
//        
//        let mainViewController = MainMenuViewController() // Replace with your main VC
//        let navigationController = UINavigationController(rootViewController: mainViewController)
//        
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let keyWindow = windowScene.windows.first(where: { $0.isKeyWindow }) {
//            keyWindow.rootViewController = navigationController
//            UIView.transition(with: keyWindow, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
//        }
        
        if let navController = self.navigationController {
            print("NavigationController exists")
        } else {
            print("NavigationController is nil")
        }
    
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as? MainMenuViewController {
            print("clicked")
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            print("NavigationController is nil")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            // Hide the keyboard when return key is pressed
            userName.resignFirstResponder()
            zipcode.resignFirstResponder()
            return true
        }
    
   


}

