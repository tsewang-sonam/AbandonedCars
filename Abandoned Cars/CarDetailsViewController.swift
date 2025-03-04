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
    
    
    var myMake: [String] = ["Acura", "Alfa Romeo", "Audi", "BMW", "Buick", "Cadillac", "Chevrolet", "Dodge", "Ford", "GMC", "Honda", "Hyundai", "Infiniti", "Jeep", "Kia", "Land Rover", "Lexus", "Lincoln", "Mazda", "Mercedes", "Mini", "Mitsubishi", "Nissan", "Porsche", "Ram", "Subaru", "Tesla", "Toyota", "Volkswagen", "Volvo"]
    
    let myModel: [String] = [ "MDX", "TLX", "RDX", "ILX", "NSX", "Giulia", "Stelvio", "Spider", "4C", "Giulietta", "A3", "A4", "A6", "Q5", "Q7", "Q8", "A8", "TT", "R8", "X5", "M3", "M5", "X3", "i3", "i8", "X7", "Z4", "Enclave", "Encore", "LaCrosse", "Regal", "Cascada", "Escalade", "CTS", "XT5", "XTS", "CT6", "ATS", "Malibu", "Impala", "Traverse", "Equinox", "Tahoe", "Silverado", "Charger", "Challenger", "Durango", "Ram 1500", "Grand Caravan", "F150", "Mustang", "Escape", "Explorer", "Focus", "Edge", "Sierra", "Yukon", "Acadia", "Terrain", "Canyon", "Civic", "Accord", "CRV", "Pilot", "Odyssey", "HRV", "Sonata", "Elantra", "Tucson", "Kona", "Santa Fe", "Palisade", "Q50", "Q60", "QX50", "QX80", "QX60", "Q70", "Wrangler", "Cherokee", "Grand Cherokee", "Renegade", "Compass", "Sorento", "Sportage", "Telluride", "Forte", "Cadenza", "Outlander", "Lancer", "Eclipse Cross", "Mirage", "Pajero", "Altima", "Maxima", "Sentra", "370Z", "Rogue", "Murano", "911", "Cayenne", "Macan", "Taycan", "Panamera", "Ram 1500", "2500", "3500", "ProMaster City", "ProMaster", "Impreza", "Outback", "Forester", "Legacy", "Crosstrek", "S", "3", "X", "Y", "Cybertruck", "Camry", "Corolla", "RAV4", "Highlander", "Tacoma", "Tundra", "Avalon", "Golf", "Passat", "Jetta", "Atlas", "Tiguan", "Beetle", "XC90", "XC60", "S60", "V90", "V60" ]
    
    let myColor : [String] = ["Red", "Blue", "Black", "White", "Silver", "Gray", "Green", "Yellow", "Orange", "Brown", "Gold", "Beige", "Purple"]

    
    var dataFiltered: [String] = []
    
    var currentTextField: UITextField?
    
    @IBAction func durationInput(_ sender: Any) {
        numberOfDays.text = String(Int(slider.value))
    }
    
    let autocompleteButton: UIButton = {
          let button = UIButton(type: .system)
          button.setTitle("➜", for: .normal)
          button.setTitleColor(.blue, for: .normal)
          button.backgroundColor = .clear
          button.addTarget(self, action: #selector(applyAutocomplete), for: .touchUpInside)
          button.isHidden = true // Initially hidden
          return button
      }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAutocompleteButton()
        
        makeInput.delegate = self
        modelInput.delegate = self
        colorInput.delegate = self
        licenseInput.delegate = self
//      vinInput.delegate = self
        
        numberOfDays.text = String(Int(slider.value))
        numberOfDays.layer.cornerRadius = 12
        numberOfDays.layer.masksToBounds = true
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
    
    var currentSuggestion: String?
    var currentTag: Int?
    
    @IBOutlet weak var btnBottom: NSLayoutConstraint!
    
    @IBAction func submitBtn(_ sender: Any) {
        
        let screenHeight = UIScreen.main.bounds.height
        
        if screenHeight == 568 {
            btnBottom.constant = 20
                    }
        let make = makeInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let models = modelInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let color = colorInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let license  = licenseInput.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let duration = numberOfDays.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let newDate = Calendar.current.startOfDay(for: Date())
   
     // here we make sure that make and color are not empty. Must have data.
        if (make == "" || color == ""){
            
            let displayMessage = UILabel()
            displayMessage.text = "Must have car's make and color entered"
            displayMessage.textColor = .red
            displayMessage.textAlignment = .center
            displayMessage.frame = CGRect(x: 30, y: 120, width: 350, height: 30)
            
            if(make == ""){
                makeInput.layer.borderColor = UIColor.red.cgColor
                makeInput.layer.borderWidth = 1
            }
            if(color == ""){
                colorInput.layer.borderColor = UIColor.red.cgColor
                colorInput.layer.borderWidth = 1
            }
            view.addSubview(displayMessage)
           
            return
        }
        
        // formats the date to string so we can save and retrieve it from firestore easier
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let newDateString = formatter.string(from: newDate)
        
        
        let newData = [
            "make" : make,
            "models" : models,
            "color" : color,
            "license_number" : license,
            "duration" : duration,
            "upLoadDate" : newDateString
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
            
            print("\(make)\(models)\(color)\(license)\(duration)")
            if let VC = self.storyboard?.instantiateViewController(withIdentifier: "ReportEndViewController" )as?  ReportEndViewController
            {
                self.navigationController?.pushViewController(VC, animated: true)
            }
            
        }
    }
    
    
    
    
    func setupAutocompleteButton() {
        makeInput.rightView = autocompleteButton
        modelInput.rightView = autocompleteButton
        colorInput.rightView = autocompleteButton
        colorInput.rightViewMode = .never
        modelInput.rightViewMode = .never
        makeInput.rightViewMode = .never // Show only when needed
       }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
           currentTextField = textField
       }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //Auto fills the textfield when user jumps to the next text field.
        if(textField.tag == 99){
           print ("here")
        }else{
            applyAutocomplete()
        }
        
    }

    var temp = ""  // Stores the actual user input (without suggestions)
    var prevTag = 0

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == makeInput || textField == modelInput || textField == colorInput {
            
            guard let currentText = textField.text else { return true }
            
            print("Range: \(range)")
            print("Length: \(range.length)")
            
            if !(range.location == 0 && range.length == 0 && currentText.isEmpty) &&
                (range.location < 0 || range.location > temp.count || range.location + range.length > temp.count) {
                print("⚠️ Out-of-bounds range detected!" )
                temp = currentText
                //  return false  // Prevents crash
            }
            
            print(currentText.count)
            let textUpdated = (temp as NSString).replacingCharacters(in: range, with: string)
            
            temp = textUpdated
            //  guard let textRange = Range(range, in: currentText) else { return false }
            
            let isDeleting = string.isEmpty
            
            if isDeleting {
                //  temp = textUpdated
                textField.text = temp
                textField.rightViewMode = .never
                return false
            }
            
            
            
            // Filter suggestions based on `temp`
            
            switch textField.tag{
            case 1:
                
                // from make, model and color array we filter based on text then sort based on size and user input count
                
                let suggestionMake = myMake.filter { $0.lowercased().hasPrefix(temp.lowercased()) }
                    .sorted{ abs($0.count - temp.count) < abs($1.count - temp.count) }
                showInlineSuggestions(suggestionMake, for: temp, in: textField)
                
            case 2:
                let suggestionModel = myModel.filter { $0.lowercased().hasPrefix(temp.lowercased())}
                    .sorted{ abs($0.count - temp.count) < abs($1.count - temp.count) }
                showInlineSuggestions(suggestionModel, for: temp, in: textField)
                
            case 3:
                let suggestionColor = myColor.filter { $0.lowercased().hasPrefix(temp.lowercased())}
                    .sorted{ abs($0.count - temp.count) < abs($1.count - temp.count) }
                showInlineSuggestions(suggestionColor, for: temp, in: textField)
                
            default:
                print ("Error in suggestion array")
                
            }
            
            return false  // ❗ Prevent iOS from inserting any characters automatically
        }
        
        return true
    }

    func showInlineSuggestions(_ suggestions: [String], for text: String, in textField: UITextField) {
       
        guard let firstSuggestion = suggestions.first else {
            textField.text = text  // Ensure user input is displayed correctly
            autocompleteButton.isHidden = true
            textField.rightViewMode = .never
            return
        }

        currentSuggestion = firstSuggestion
        currentTag = textField.tag

        // Extract only the remaining part of the suggestion
        let remainingText = String(firstSuggestion.dropFirst(temp.count))

        // **Manually set the text field to user input before appending suggestion**
        textField.text = temp

        // Set the final text in the field (user input + remaining suggestion)
        let combinedText = temp + remainingText

        // Apply inline autocomplete formatting
        let attributedString = NSMutableAttributedString(string: combinedText)
        attributedString.addAttribute(.foregroundColor, value: UIColor.lightGray, range: NSRange(location: temp.count, length: remainingText.count))

        textField.attributedText = attributedString

        // Move cursor to the end of user input
        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: temp.count) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }

        // Show autocomplete button
        autocompleteButton.isHidden = false
        textField.rightViewMode = .always
    }


       @objc func applyAutocomplete() {
           if let suggestion = currentSuggestion, let textField = currentTextField {
               if(textField.tag == currentTag){
                   textField.text = suggestion
                   textField.rightViewMode = .never
                   temp = ""}
               else{
                   textField.text = ""
                   textField.rightViewMode = .never
                   temp = ""
               }
           }
       }

   
     
}
          
   
        
    
    


