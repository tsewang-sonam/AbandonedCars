//
//  TableViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 6/11/24.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var fowardedMake : String?
    var fowardedModel : String?
    var fowardedColor : String?
    var fowardedLicense : String?
    var fowardedZip : String?
    
    let db = Firestore.firestore()
   
    
    struct Data{
        let title : String
        let imageName: String
    }
    
    var imagePaths = [String]()

    let storage = Storage.storage()
    
    var cars = [[String: Any]]()
    
   // var test = [Data]()
    var test: [Data] = []
    
    @IBOutlet weak var table : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        table.dataSource = self
        table.delegate = self
       // table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        print("We got word : \(fowardedMake ?? "default value")")
        print("We got word : \(fowardedModel ?? "default value")")
        print("We got word : \(fowardedColor ?? "default value")")
 
        fetchCars{
            print("Number of cars: \(self.cars.count)")
            self.table.reloadData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("From Table \(test.count)")
        if let firstElement = self.test.first {
            print(firstElement)
        } else {
            print("The test array is empty.")
        }
        return test.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!
        CarListTableViewCell
        
        let storage = Storage.storage()
        
        // Getting info about car
           let rowData = test[indexPath.row]
        
        // getting path to the image in firestore
        let imagePath = imagePaths[indexPath.row]
        let imageRef = storage.reference().child(imagePath)
        
        cell.content.text = rowData.title
        cell.img.image = UIImage(named: "car")
        
        imageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                    if let error = error {
                        print("Error downloading image: \(error)")
                        return
                    }
            
                    guard let imageData = data else {
                        print("No image data found")
                        return
                    }
                    
        let image = UIImage(data: imageData)
            
        DispatchQueue.main.async {
                        if let updateCell = tableView.cellForRow(at: indexPath) as? CarListTableViewCell {
                            updateCell.img.image = image
                        }
                    }
                }
                
                return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let VC = self.storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController {
            
            navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    
    // This function gets the info from the database and then checks if it matched to the user input. It then ranks the matches with score and sort them in a ranking order.  Then updates the test Array with the sorted array of cars found based on ranking.
    
    func fetchCars(completion: @escaping () -> Void) {
        db.collection("cars").getDocuments { (querySnapshot, error) in
            if let error = error
            {
                print("Error getting documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            var carList: [(score: Int, data: [String: Any])] = []
            
            for document in documents {
                
                let data = document.data()
                
                
                var score = 0
                
                if let make = document.data()["make"] as? String, make.lowercased() == self.fowardedMake?.lowercased() {
                    
                    print("make : ''''''''")
                    score += 1
                }
                
              
                if let models = document.data()["models"] as? String, models.lowercased() == self.fowardedModel?.lowercased()
                {
                    
                    print("models : ''---'")
                    score += 1
                }
                if let color = document.data()["color"] as? String, color.lowercased() == self.fowardedColor?.lowercased() {
                    
                    print("color : '',,,,,,,'''''")
                    score += 1
                }
                
                carList.append((score: score, data: data))
            }
            
            carList.sort { $0.score > $1.score }
            
            
            // Extract the sorted data
            self.cars = carList.map { $0.data }
            
            for img in self.cars {
                if let imgData = img["group_id"] as? String {
                    print("images/\(imgData)")
                    self.imagePaths.append( "images/\(imgData)_1.png")
                }
            }
          
            self.test = self.createDataArray(from: self.cars)
            
            completion()
            
            print("Test \(self.test.count)")
            
        }
    }
    
    
    // creates an array of data for the description part of the table view. The data created is then updated to the test array in the fetchCars function.
    
    func createDataArray(from carsArray: [[String: Any]]) -> [Data] {
        print("hrelloooooooo")
        var dataArray = [Data]()
        print(carsArray.count)
        for car in carsArray {
           
            if let make = car["make"] as? String,
               let model = car["models"] as? String,
               let color = car["color"] as? String,
            let duration = car["duration"] as? String{
                let title = "\(make)  \(model)  \n  \(color) \n  \(duration)"
                print(title)
                let imageName = "one" // constant image name
                let data = Data(title: title, imageName: imageName)
                dataArray.append(data)
            } else{
                let title = "missing info"
                let imageName = "one" // constant image name
                let data = Data(title: title, imageName: imageName)
                dataArray.append(data)
            }
        }
        
        table.reloadData()
        return dataArray
    }

}
