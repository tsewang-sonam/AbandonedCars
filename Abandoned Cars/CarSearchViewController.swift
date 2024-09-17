//
//  CarSearchViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 5/30/24.
//

import UIKit

struct CarModel {
    let name : String
    let colors : [String]
}

struct CarMake {
    let name : String
    let models : [CarModel]
}

class CarSearchViewController: UIViewController,  UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate {

    var pickerView = UIPickerView()
    var carMakes: [CarMake] = []
    var pickerData: [String] = []
    
    @IBOutlet weak var makeTextField : UITextField!
    @IBOutlet weak var modelTextField : UITextField!
    @IBOutlet weak var yearTextFiekd : UITextField!
    
    @IBOutlet weak var licenseTextField : UITextField!
    @IBOutlet weak var zipArea : UITextField!
    
   
    @IBAction func submitBtn(_ sender: Any) {
        
        if let VC = self.storyboard?.instantiateViewController(withIdentifier: "TableViewController") as? TableViewController {
            VC.fowardedMake = makeTextField.text
            VC.fowardedModel = modelTextField.text
            print("]]]]]  \(modelTextField.text ?? "0")")
            VC.fowardedColor = yearTextFiekd.text
            VC.fowardedLicense = licenseTextField.text
            VC.fowardedZip = zipArea.text
        
            self.navigationController?.pushViewController(VC , animated: true)
        }
    }
    
    
    var activeTextField: UITextField?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        zipArea.delegate = self
        licenseTextField.delegate = self
        
        let acuraModels = [
            CarModel(name: "ILX", colors: ["White", "Black", "Silver", "Red", "Blue"]),
            CarModel(name: "MDX", colors: ["White", "Black", "Silver", "Red", "Blue", "Green"]),
            CarModel(name: "NSX", colors: ["Yellow", "Red", "Blue", "Black", "White"]),
            CarModel(name: "RDX", colors: ["White", "Black", "Silver", "Red", "Blue", "Green"]),
            CarModel(name: "TLX", colors: ["White", "Black", "Silver", "Red", "Blue"])
        ]

        let alfaRomeoModels = [
            CarModel(name: "Giulia", colors: ["Red", "Black", "White", "Blue"]),
            CarModel(name: "Stelvio", colors: ["Red", "Black", "White", "Blue", "Green"]),
            CarModel(name: "4C Spider", colors: ["Yellow", "Red", "Black", "White"])
        ]
        
        let audiModels = [
            CarModel(name: "A3", colors: ["White", "Black", "Silver", "Red", "Blue", "Grey"]),
            CarModel(name: "A4", colors: ["White", "Black", "Silver", "Red", "Blue", "Green", "Grey"]),
            CarModel(name: "A6", colors: ["White", "Black", "Silver", "Red", "Blue", "Green", "Grey", "Brown"]),
            CarModel(name: "Q5", colors: ["White", "Black", "Silver", "Red", "Blue", "Grey", "Green"]),
            CarModel(name: "Q7", colors: ["White", "Black", "Silver", "Red", "Blue", "Grey", "Green", "Brown"]),
            CarModel(name: "Q8", colors: ["White", "Black", "Silver", "Red", "Blue", "Grey", "Green", "Gold"])
        ]

        let bmwModels = [
            CarModel(name: "3 Series", colors: ["White", "Black", "Silver", "Red", "Blue", "Grey", "Green"]),
            CarModel(name: "5 Series", colors: ["White", "Black", "Silver", "Red", "Blue", "Grey", "Green", "Brown"]),
            CarModel(name: "7 Series", colors: ["White", "Black", "Silver", "Red", "Blue", "Grey", "Gold"]),
            CarModel(name: "X3", colors: ["White", "Black", "Silver", "Red", "Blue", "Grey"]),
            CarModel(name: "X5", colors: ["White", "Black", "Silver", "Red", "Blue", "Green", "Grey"])
        ]

        let buickModels = [
            CarModel(name: "Enclave", colors: ["White", "Black", "Silver", "Red", "Blue", "Grey", "Green"]),
            CarModel(name: "Encore", colors: ["White", "Black", "Silver", "Red", "Blue", "Grey"]),
            CarModel(name: "Envision", colors: ["White", "Black", "Silver", "Red", "Blue", "Grey", "Green"])
        ]

        let cadillacModels = [
        CarModel(name: "CT4", colors: ["White", "Black", "Silver", "Red", "Blue"]),
        CarModel(name: "CT5", colors: ["White", "Black", "Silver", "Red", "Blue"]),
        CarModel(name: "Escalade", colors: ["White", "Black", "Silver", "Red", "Blue", "Green", "Grey"]),
        CarModel(name: "XT4", colors: ["White", "Black", "Silver", "Red", "Blue"]),
        CarModel(name: "XT5", colors: ["White", "Black", "Silver", "Red", "Blue", "Green"]),
        CarModel(name: "XT6", colors: ["White", "Black", "Silver", "Red", "Blue"])
    ]

    let chevroletModels = [
        CarModel(name: "Blazer", colors: ["White", "Black", "Silver", "Red", "Blue", "Grey", "Green"]),
        CarModel(name: "Camaro", colors: ["White", "Black", "Silver", "Red", "Blue", "Yellow", "Green", "Orange"]),
        CarModel(name: "Colorado", colors: ["White", "Black", "Silver", "Red", "Blue", "Grey"]),
        CarModel(name: "Equinox", colors: ["White", "Black", "Silver", "Red", "Blue", "Green"]),
        CarModel(name: "Silverado", colors: ["White", "Black", "Silver", "Red", "Blue", "Green", "Grey"]),
        CarModel(name: "Tahoe", colors: ["White", "Black", "Silver", "Red", "Blue", "Green", "Brown"]),
        CarModel(name: "Traverse", colors: ["White", "Black", "Silver", "Red", "Blue", "Grey", "Green"])
    ]

        let dodgeModels = [
            CarModel(name: "Challenger", colors: ["Red", "Black", "White", "Blue", "Yellow"]),
            CarModel(name: "Charger", colors: ["Black", "White", "Silver", "Blue", "Red"]),
            CarModel(name: "Durango", colors: ["Gray", "Red", "White", "Black", "Blue"]),
            CarModel(name: "Journey", colors: ["White", "Black", "Silver", "Red", "Blue"])
        ]

        let fordModels = [
            CarModel(name: "Bronco", colors: ["Green", "Yellow", "Black", "White", "Blue"]),
            CarModel(name: "Edge", colors: ["Red", "Black", "White", "Silver", "Blue"]),
            CarModel(name: "Escape", colors: ["White", "Black", "Silver", "Red", "Blue"]),
            CarModel(name: "Explorer", colors: ["Red", "Black", "White", "Silver", "Blue"]),
            CarModel(name: "F-150", colors: ["Red", "Black", "White", "Silver", "Blue"]),
            CarModel(name: "Mustang", colors: ["Red", "Black", "White", "Blue", "Yellow"])
        ]

        let gmcModels = [
            CarModel(name: "Acadia", colors: ["White", "Black", "Red", "Silver", "Blue"]),
            CarModel(name: "Canyon", colors: ["Red", "Black", "White", "Silver", "Blue"]),
            CarModel(name: "Sierra", colors: ["Red", "Black", "White", "Silver", "Blue"]),
            CarModel(name: "Terrain", colors: ["White", "Black", "Silver", "Red", "Blue"]),
            CarModel(name: "Yukon", colors: ["White", "Black", "Silver", "Red", "Blue"])
        ]

        let hondaModels = [
            CarModel(name: "Accord", colors: ["Red", "Black", "White", "Silver", "Blue"]),
            CarModel(name: "Civic", colors: ["Red", "Black", "White", "Silver", "Blue"]),
            CarModel(name: "CR-V", colors: ["White", "Black", "Silver", "Red", "Blue"]),
            CarModel(name: "HR-V", colors: ["White", "Black", "Silver", "Red", "Blue"]),
            CarModel(name: "Pilot", colors: ["White", "Black", "Silver", "Red", "Blue"])
        ]

        let hyundaiModels = [
            CarModel(name: "Elantra", colors: ["Red", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "Kona", colors: ["Red", "Blue", "White", "Black", "Green"]),
            CarModel(name: "Palisade", colors: ["White", "Black", "Gray", "Blue", "Silver"]),
            CarModel(name: "Santa Fe", colors: ["Red", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "Sonata", colors: ["Red", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "Tucson", colors: ["Red", "Blue", "White", "Black", "Gray"])
        ]
        let infinitiModels = [
            CarModel(name: "Q50", colors: ["Red", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "Q60", colors: ["Red", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "QX50", colors: ["Red", "Blue", "White", "Black", "Gray"]),
            CarModel(name: "QX60", colors: ["Red", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "QX80", colors: ["Red", "Blue", "White", "Black", "Silver"])
        ]
        
        let jeepModels = [
            CarModel(name: "Cherokee", colors: ["Red", "Blue", "White", "Black", "Gray"]),
            CarModel(name: "Compass", colors: ["Red", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "Gladiator", colors: ["Red", "Blue", "White", "Black", "Green"]),
            CarModel(name: "Grand Cherokee", colors: ["Red", "Blue", "White", "Black", "Gray"]),
            CarModel(name: "Wrangler", colors: ["Red", "Blue", "White", "Black", "Green"])
        ]
       
        let kiaModels = [
            CarModel(name: "Forte", colors: ["Red", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "Optima", colors: ["Green", "Blue", "White", "Black", "Gray"]),
            CarModel(name: "Seltos", colors: ["Yellow", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "Sorento", colors: ["Red", "Blue", "White", "Black", "Gray"]),
            CarModel(name: "Sportage", colors: ["Green", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "Telluride", colors: ["Brown", "Blue", "White", "Black", "Gray"])
        ]

        let landRoverModels = [
            CarModel(name: "Defender", colors: ["Gray", "Blue", "White", "Black", "Green"]),
            CarModel(name: "Discovery", colors: ["Red", "Blue", "White", "Black", "Brown"]),
            CarModel(name: "Range Rover", colors: ["Gray", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "Range Rover Evoque", colors: ["Yellow", "Blue", "White", "Black", "Gray"]),
            CarModel(name: "Range Rover Sport", colors: ["Green", "Blue", "White", "Black", "Silver"])
        ]

        let lexusModels = [
            CarModel(name: "ES", colors: ["Red", "Blue", "White", "Black", "Gray"]),
            CarModel(name: "GX", colors: ["Green", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "IS", colors: ["Yellow", "Blue", "White", "Black", "Gray"]),
            CarModel(name: "LS", colors: ["Red", "Blue", "White", "Black", "Brown"]),
            CarModel(name: "NX", colors: ["Gray", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "RX", colors: ["Green", "Blue", "White", "Black", "Gray"])
        ]

        let lincolnModels = [
            CarModel(name: "Aviator", colors: ["Red", "Blue", "White", "Black", "Gray"]),
            CarModel(name: "Corsair", colors: ["Green", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "Nautilus", colors: ["Yellow", "Blue", "White", "Black", "Gray"]),
            CarModel(name: "Navigator", colors: ["Brown", "Blue", "White", "Black", "Gray"])
        ]

        let mazdaModels = [
            CarModel(name: "CX-3", colors: ["Red", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "CX-30", colors: ["Green", "Blue", "White", "Black", "Gray"]),
            CarModel(name: "CX-5", colors: ["Yellow", "Blue", "White", "Black", "Gray"]),
            CarModel(name: "CX-9", colors: ["Brown", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "Mazda3", colors: ["Red", "Blue", "White", "Black", "Gray"]),
            CarModel(name: "Mazda6", colors: ["Green", "Blue", "White", "Black", "Silver"])
        ]

        let mercedesModels = [
            CarModel(name: "A-Class", colors: ["Gray", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "C-Class", colors: ["Red", "Blue", "White", "Black", "Brown"]),
            CarModel(name: "E-Class", colors: ["Gray", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "GLA", colors: ["Yellow", "Blue", "White", "Black", "Gray"]),
            CarModel(name: "GLE", colors: ["Green", "Blue", "White", "Black", "Silver"]),
            CarModel(name: "S-Class", colors: ["Red", "Blue", "White", "Black", "Gray"])
        ]


        let miniModels = [
            CarModel(name: "Clubman", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray", "Orange", "Purple"]),
            CarModel(name: "Convertible", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray", "Orange", "Purple"]),
            CarModel(name: "Countryman", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray", "Orange", "Purple"]),
            CarModel(name: "Hardtop", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray", "Orange", "Purple"])
        ]

        let mitsubishiModels = [
            CarModel(name: "Eclipse Cross", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Mirage", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Outlander", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Outlander Sport", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"])
        ]

        let nissanModels = [
            CarModel(name: "Altima", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Frontier", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Leaf", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Murano", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Rogue", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Sentra", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"])
        ]

        let porscheModels = [
            CarModel(name: "718 Cayman", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "911", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Cayenne", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Macan", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Panamera", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Taycan", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"])
        ]

        let ramModels = [
            CarModel(name: "1500", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "2500", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "3500", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "ProMaster", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"])
        ]

        let subaruModels = [
            CarModel(name: "Ascent", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Crosstrek", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Forester", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Impreza", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Outback", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"])
        ]

        let teslaModels = [
            CarModel(name: "Model 3", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Model S", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Model X", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Model Y", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"])
        ]

        let toyotaModels = [
            CarModel(name: "4Runner", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Camry", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Corolla", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Highlander", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Prius", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "RAV4", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"]),
            CarModel(name: "Tacoma", colors: ["Red", "Blue", "Green", "Yellow", "Black", "White", "Silver", "Gray"])
        ]
        
        let volkswagenModels = [
            CarModel(name: "Atlas", colors: ["Black", "White", "Silver", "Blue", "Gray"]),
            CarModel(name: "Golf", colors: ["Red", "Black", "White", "Silver", "Blue", "Gray", "Green"]),
            CarModel(name: "Jetta", colors: ["Red", "Black", "White", "Silver", "Blue", "Gray", "Beige"]),
            CarModel(name: "Passat", colors: ["Red", "Black", "White", "Silver", "Blue", "Gray", "Green"]),
            CarModel(name: "Tiguan", colors: ["Red", "Black", "White", "Silver", "Blue", "Gray", "Orange"])
        ]

        let volvoModels = [
            CarModel(name: "S60", colors: ["Black", "White", "Silver", "Blue", "Gray", "Red"]),
            CarModel(name: "S90", colors: ["Black", "White", "Silver", "Blue", "Gray"]),
            CarModel(name: "V60", colors: ["Black", "White", "Silver", "Blue", "Gray", "Red"]),
            CarModel(name: "XC40", colors: ["Black", "White", "Silver", "Blue", "Gray", "Orange"]),
            CarModel(name: "XC60", colors: ["Black", "White", "Silver", "Blue", "Gray", "Red"]),
            CarModel(name: "XC90", colors: ["Black", "White", "Silver", "Blue", "Gray", "Brown"])
        ]
        
      carMakes  = [
            CarMake(name: "Acura", models: acuraModels),
            CarMake(name: "Alfa Romeo", models: alfaRomeoModels),
            CarMake(name: "Audi", models: audiModels),
            CarMake(name: "BMW", models: bmwModels),
            CarMake(name: "Buick", models: buickModels),
            CarMake(name: "Cadillac", models: cadillacModels),
            CarMake(name: "Chevrolet", models: chevroletModels),
            CarMake(name: "Dodge", models: dodgeModels),
            CarMake(name: "Ford", models: fordModels),
            CarMake(name: "GMC", models: gmcModels),
            CarMake(name: "Honda", models: hondaModels),
            CarMake(name: "Hyundai", models: hyundaiModels),
            CarMake(name: "Infiniti", models: infinitiModels),
            CarMake(name: "Jeep", models: jeepModels),
            CarMake(name: "Kia", models: kiaModels),
            CarMake(name: "Land Rover", models: landRoverModels),
            CarMake(name: "Lexus", models: lexusModels),
            CarMake(name: "Lincoln", models: lincolnModels),
            CarMake(name: "Mazda", models: mazdaModels),
            CarMake(name: "Mercedes", models: mercedesModels),
            CarMake(name: "Mini", models: miniModels),
            CarMake(name: "Mitsubishi", models: mitsubishiModels),
            CarMake(name: "Nissan", models: nissanModels),
            CarMake(name: "Porsche", models: porscheModels),
            CarMake(name: "Ram", models: ramModels),
            CarMake(name: "Subaru", models: subaruModels),
            CarMake(name: "Tesla", models: teslaModels),
            CarMake(name: "Toyota", models: toyotaModels),
            CarMake(name: "Volkswagen", models: volkswagenModels),
            CarMake(name: "Volvo", models: volvoModels)
        ]
        
        
        print(getCarMake())
        
        makeTextField.tag = 1
        modelTextField.tag = 2
        yearTextFiekd.tag = 3
        
        makeTextField.delegate = self
        modelTextField.delegate = self
        yearTextFiekd.delegate = self
        

        
        // Add pickerView to the view
           pickerView.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(pickerView)

                // Layout constraints
                NSLayoutConstraint.activate([
                    pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    pickerView.widthAnchor.constraint(equalToConstant: 200),
                    pickerView.heightAnchor.constraint(equalToConstant: 150)
                ])
        
    
    }
    
   
    var carMakeNames = [String]()
    var carModels = [String]()
    var carYears = [String]()
    
    func getCarMake() -> [String] {
        
        // Iterate over each CarMake instance in the carMakes array
        for carMake in carMakes {
            // Extract the name property from each CarMake object and add it to the carMakeNames array
             carMakeNames.append(carMake.name)
        }
        
        return carMakeNames
    }
    
    func getModels(forCarMake carMakeName : String) -> [String]? {
        
        if let carMake = carMakes.first (where : { $0.name == carMakeName}) {
            
            return carMake.models.map{$0.name}
        }
        return nil
    }
    
    func getYear(forModel modelName : String , forCarmake carMakeName : String) -> [String]? {
        
        if let carMake = carMakes.first (where: { $0.name == carMakeName}){
            if let model = carMake.models.first(where: { $0.name == modelName}){
                return model.colors
            }
        }
        
        return nil
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           
            return pickerData.count
        }

        // MARK: - UIPickerViewDelegate

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerData[row]
        }
    
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            // Handle the selection
            guard let activeTextField = activeTextField else { return }

            switch activeTextField.tag {
            case 1:
                makeTextField.text = pickerData[row]
                
            case 2:
                modelTextField.text = pickerData[row]
            case 3:
                yearTextFiekd.text = pickerData[row]
            default:
                break
            }
            activeTextField.resignFirstResponder()
            
        }
    
  
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
            switch textField.tag {
            case 1:
                
                pickerData = carMakeNames
                activeTextField = makeTextField
                modelTextField.text = ""
                yearTextFiekd.text = ""
            case 2:
                let carMake = activeTextField?.text ?? "Tesla"
                                
                if let models = getModels(forCarMake: carMake) {
                                carModels = models
                                print("Models for \(carMake): \(carModels)")
                    }
                pickerData = carModels
                activeTextField = modelTextField
                yearTextFiekd.text = ""
            case 3:
                let carMake = makeTextField?.text ?? "Tesla"
                let carModel = activeTextField?.text ?? "Model X"
                    print("Car model is: \(carModel)  forCarmake: \(carMake)")
                if let years = getYear(forModel: carModel, forCarmake: carMake){
                    carYears = years
                    print("Years of Production : \(carYears)")
                }
                pickerData = carYears
                activeTextField = yearTextFiekd
            default:
                break
            }
            
            pickerView.reloadAllComponents()
            
            textField.inputView = pickerView
        }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        zipArea.resignFirstResponder()
        licenseTextField.resignFirstResponder()
        
        return true
    }
    
}

