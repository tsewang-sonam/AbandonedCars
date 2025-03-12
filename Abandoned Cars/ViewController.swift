//
//  ViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 4/12/24.
//
import FirebaseFirestore
import UIKit
import FLAnimatedImage

class ViewController: UIViewController, UITextFieldDelegate {
    
    let database = Firestore.firestore()
    
    @IBOutlet weak var fLanimation: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        userName.delegate = self
        zipcode.delegate = self
        email.delegate = self
        
        
        //Beautify TextField
        userName.layer.cornerRadius = 10
        userName.layer.masksToBounds = true
        userName.clearButtonMode = .whileEditing
        
        //Beautify TextField
        zipcode.layer.cornerRadius = 10
        zipcode.layer.masksToBounds = true
        zipcode.clearButtonMode = .whileEditing
        
    }
        
        //        let imgGIF = FLAnimatedImageView()
        //        imgGIF.contentMode = .scaleAspectFit
        //        imgGIF.translatesAutoresizingMaskIntoConstraints = false
        
        //    fLanimation.addSubview(imgGIF)
        //
        //        NSLayoutConstraint.activate([
        //            imgGIF.topAnchor.constraint(equalTo: fLanimation.topAnchor),
        //            imgGIF.bottomAnchor.constraint(equalTo: fLanimation.bottomAnchor),
        //            imgGIF.rightAnchor.constraint(equalTo: fLanimation.rightAnchor),
        //            imgGIF.leftAnchor.constraint(equalTo: fLanimation.leftAnchor)
        //        ])
        
        //        if let animationPath = Bundle.main.path(forResource: "welcome", ofType: "gif"),
        //           let gifData = try?Data(contentsOf: URL(fileURLWithPath: animationPath)){
        //
        //            let AnimatedImage = FLAnimatedImage(animatedGIFData: gifData)
        //            imgGIF.animatedImage = AnimatedImage
        //        }
        //
        
        
        @IBOutlet weak var userName: UITextField!
        @IBOutlet weak var zipcode: UITextField!
        @IBOutlet weak var email: UITextField!
        
    @IBAction func clickBtn(_ sender: UIButton) {
        
        let zipCodeLabel = UILabel()
        let emailLabel = UILabel()
        let nameLabel = UILabel()
        
        if (userName.text == "" || zipcode.text == "" || email.text == ""){
            
            let displayMessage = UILabel()
            displayMessage.text = "Must have user name and zipcode entered"
            displayMessage.textColor = .red
            displayMessage.textAlignment = .center
            displayMessage.frame = CGRect(x: 30, y: 80, width: 350, height: 30)
            
            if(userName.text == "" ){
                userName.layer.borderColor = UIColor.red.cgColor
                userName.layer.borderWidth = 1
            }
            if(zipcode.text == ""){
                zipcode.layer.borderColor = UIColor.red.cgColor
                zipcode.layer.borderWidth = 1
            }
            if(email.text == ""){
                email.layer.borderColor = UIColor.red.cgColor
                email.layer.borderWidth = 1
            }
            view.addSubview(displayMessage)
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3){
                displayMessage.isHidden = true
            }
            
            return
        }
        
        let inputUsername = userName.text ?? ""
        
        if isValidEmail(email.text ?? ""){
            print("is correct format for zipcode")
        }else{
            
           
            emailLabel.text = "Enter correct email"
            emailLabel.textColor = .systemRed
            emailLabel.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(emailLabel)
            
            NSLayoutConstraint.activate([
                emailLabel.leadingAnchor.constraint(equalTo: self.email.leadingAnchor),
                emailLabel.bottomAnchor.constraint(equalTo: self.email.topAnchor, constant: -5)
            ])
            
            DispatchQueue.main.asyncAfter(deadline: .now()+5){
                emailLabel.isHidden = true
            }
            
            print("wrong email")
            return
        }
        
        if isValidZipCode(zipcode.text ?? ""){
            print("is correct format for email")
        }else{
            
            zipCodeLabel.text = "Enter correct zipCode"
            zipCodeLabel.textColor = .systemRed
            zipCodeLabel.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(zipCodeLabel)
            
            NSLayoutConstraint.activate([
                zipCodeLabel.leadingAnchor.constraint(equalTo: self.zipcode.leadingAnchor),
                zipCodeLabel.bottomAnchor.constraint(equalTo: self.zipcode.topAnchor, constant: -5)
            ])
            
            DispatchQueue.main.asyncAfter(deadline: .now()+5){
                zipCodeLabel.isHidden = true
            }
            
            return
        }
        
        checkUserExist(username: inputUsername ){ isTaken in
            if isTaken {
                print("Please choose a different username.")
                
                
                nameLabel.text = "Username is taken.Try new one"
                nameLabel.textColor = .systemRed
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                
                self.view.addSubview(nameLabel)
                
                NSLayoutConstraint.activate([
                    nameLabel.leadingAnchor.constraint(equalTo: self.userName.leadingAnchor),
                    nameLabel.bottomAnchor.constraint(equalTo: self.userName.topAnchor, constant: -5)
                ])
                
                DispatchQueue.main.asyncAfter(deadline: .now()+5){
                    nameLabel.isHidden = true
                }
                
                return // Exit function if username is taken
            }
            
            DispatchQueue.main.async {
                        self.createUserAccount()
                
                let zipSaved = self.zipcode.text ?? ""
                let userNameSaved = self.userName.text ?? ""
                let emailSaved = self.email.text ?? ""
                
                UserDefaults.standard.set(zipSaved, forKey: "zipSaved")
                UserDefaults.standard.set(userNameSaved, forKey: "userNameSaved")
                UserDefaults.standard.set(emailSaved, forKey: "emailSaved")
             
                if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as? MainMenuViewController {
                    print("clicked")
                    UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    print("NavigationController is nil")
                }
            }
        }
            
            
            // carReference.setData(["user_id" : uuid ])
            
       
        
        }

            
            
            func textFieldShouldReturn(_ textField: UITextField) -> Bool {
                // Hide the keyboard when return key is pressed
                userName.resignFirstResponder()
                zipcode.resignFirstResponder()
                email.resignFirstResponder()
                return true
            
            }
    
func checkUserExist(username: String, completion: @escaping (Bool) -> Void) {
    let usersCollection = database.collection("users")
    
    usersCollection.whereField("user_name", isEqualTo: username.lowercased()).getDocuments { (snapshot, error) in
        if let error = error {
            print("Error checking username: \(error.localizedDescription)")
            completion(true) // Assume taken if there's an error
            return
        }
        
        if let snapshot = snapshot, !snapshot.documents.isEmpty {
            print("Username is already taken!")
            completion(true) // Username exists
        } else {
            print("Username is available!")
            completion(false) // Username is unique
        }
    }
}

        
        func createUserAccount(){
            
            let usersCollection = database.collection("users")
            let uuid = UUID().uuidString
            let documentReference = usersCollection.document(uuid)
            
            documentReference.setData([
                "zipcode" : zipcode.text ?? 99,
                "user_name" : userName.text?.lowercased() ?? "error",
                "email" : email.text ?? "a@gmail.com"
            ])
            
            
            let carCollection = database.collection("cars")
            let carReference = carCollection.document()}
        
    }

func isValidEmail(_ email: String) -> Bool {
    let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
    return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
}

func isValidZipCode(_ zipCode: String) -> Bool {
    let zipCodeRegex = #"^\d{5}(-\d{4})?$"#
    return NSPredicate(format: "SELF MATCHES %@", zipCodeRegex).evaluate(with: zipCode)
}


