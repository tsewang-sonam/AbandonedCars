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
        
   
        //Beautify TextField
        userName.layer.cornerRadius = 10
        userName.layer.masksToBounds = true
        userName.clearButtonMode = .whileEditing
    
        //Beautify TextField
        zipcode.layer.cornerRadius = 10
        zipcode.layer.masksToBounds = true
        zipcode.clearButtonMode = .whileEditing
        
        
        let imgGIF = FLAnimatedImageView()
        imgGIF.contentMode = .scaleAspectFit
        imgGIF.translatesAutoresizingMaskIntoConstraints = false
        
        fLanimation.addSubview(imgGIF)
        
        NSLayoutConstraint.activate([
            imgGIF.topAnchor.constraint(equalTo: fLanimation.topAnchor),
            imgGIF.bottomAnchor.constraint(equalTo: fLanimation.bottomAnchor),
            imgGIF.rightAnchor.constraint(equalTo: fLanimation.rightAnchor),
            imgGIF.leftAnchor.constraint(equalTo: fLanimation.leftAnchor)
        ])
        
        if let animationPath = Bundle.main.path(forResource: "welcome", ofType: "gif"),
           let gifData = try?Data(contentsOf: URL(fileURLWithPath: animationPath)){
            
            let AnimatedImage = FLAnimatedImage(animatedGIFData: gifData)
            imgGIF.animatedImage = AnimatedImage
        }
        
        
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
        
      //  UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
    
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

