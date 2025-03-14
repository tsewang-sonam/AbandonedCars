//
//  AdvancedSearchViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 3/12/25.
//

import UIKit

class AdvancedSearchViewController: UIViewController {
    
    
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var zipInput: UITextField!
    @IBOutlet weak var licenseInput: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var zip = UserDefaults.standard.string(forKey: "zipcode")
        var license = UserDefaults.standard.string(forKey: "license")
        
        if let checkMark = UserDefaults.standard.string(forKey: "CheckMark"){
            
            if checkMark == "true"{
                checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                checkButton.tintColor = .systemGreen
                
                
                zipInput.placeholder = zip
                licenseInput.placeholder = license
                
            }else {
                
                checkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                checkButton.tintColor = .gray
            }
        } else {
            // If no saved state, set to unchecked by default
            checkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
            checkButton.tintColor = .gray
        }
        
       
       
        
        
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        
        UserDefaults.standard.set( zipInput.text, forKey: "zipcode")
        UserDefaults.standard.set(licenseInput.text, forKey: "license")
                
        if let navController = navigationController {
                    var viewControllers = navController.viewControllers
                    
                    // removes the last view. so that we dont end up in a loop of <back navigation button
                    viewControllers.removeLast()
                    navController.setViewControllers(viewControllers, animated: true)
                }
        
    }
    
    
    @IBAction func checkBtn(_ sender: UIButton) {
        
    
        if sender.image(for: .normal) == UIImage(systemName: "checkmark.circle.fill") {
                // Switch to normal state
                sender.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
                sender.tintColor = .gray
                UserDefaults.standard.set("false", forKey: "CheckMark")
            } else {
                sender.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
                sender.tintColor = .systemGreen
                
                UserDefaults.standard.set("true", forKey: "CheckMark")
            }
    }
    
    
}
