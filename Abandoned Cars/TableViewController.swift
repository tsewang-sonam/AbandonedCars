//
//  TableViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 6/11/24.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import SDWebImage
import Lottie

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    var fowardedMake: String?
    var fowardedModel: String?
    var fowardedColor: String?
    var fowardedLicense: String?
    var fowardedZip: String?
    
    let db = Firestore.firestore()
    var cellName = ""
    
    struct Data{
        let title: NSAttributedString
        let imageName: String
    }
    
    struct CarList {
        let id: String               // Firestore document ID
        let score: Int
        let data: [String: Any]      // Document data from Firestore
    }
    
    
    var imagePaths = [String]()

    let storage = Storage.storage()
    
    var carList: [CarList] = []
    
    var cars = [[String: Any]]()
    
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
        
        showLoadingIndicator()
 
        fetchCars{
            DispatchQueue.main.async {
                print("Number of cars: \(self.cars.count)")
                self.hideLoadingIndicator()
                self.table.reloadData()
            }
        }
        
    }
    func showLoadingIndicator() {
        
        let animationView = LottieAnimationView(name: "loading")
      
        let size: CGFloat = 200
            
            
            animationView.frame = CGRect(x: 0, y: 0, width: size, height: size)
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            
            
            table.backgroundView = animationView
        
    }

    func hideLoadingIndicator() {
        table.backgroundView = nil
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
        
        cell.index.text = String(indexPath.row + 1)
        cell.index.textAlignment = .left
        cell.index.textColor = .systemGray
        cell.index.font = .boldSystemFont(ofSize: 20)
        
        // getting path to the image in firestore
        let imagePath = imagePaths[indexPath.row]
        let imageRef = storage.reference().child(imagePath)
        
        
        
        DispatchQueue.global(qos: .background).async {
            let attributedTitle = rowData.title // Expensive operation

            DispatchQueue.main.async {
                cell.content.attributedText = attributedTitle // Update UI on main thread
            }
        }
        
       
        
        
        cell.content.numberOfLines = 0
        cell.img.image = UIImage(systemName: "arrow.triangle.2.circlepath")
        cell.img.tintColor = .systemGray
        
        // Reducing the size of SF Symbol for clean look. (Note : SF Symbols are vector-based and can be resized with SymbolConfiguration)
        cell.img.image = UIImage(systemName: "arrow.triangle.2.circlepath")?
            .withConfiguration(UIImage.SymbolConfiguration(weight: .light))

        let rotation = CABasicAnimation(keyPath: "transform.rotation")
            rotation.toValue = CGFloat.pi * 2
            rotation.duration = 1.0
            rotation.repeatCount = .infinity
            cell.img.layer.add(rotation, forKey: "rotateAnimation")
       
            cell.img.contentMode = .scaleAspectFit
        
                        
        imageRef.downloadURL { url, error in
            if let error = error {
                print("Error fetching image URL: \(error)")
                return
            }
            
            if let url = url {
                cell.img.layer.removeAnimation(forKey: "rotateAnimation")
                
                let blurEffect = UIBlurEffect(style: .systemThinMaterial)
                let blurView = UIVisualEffectView(effect: blurEffect)
                blurView.frame = cell.img.bounds
                blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurView.alpha = 0.4
                cell.img.addSubview(blurView)
                
                cell.img.sd_setImage(with: url, placeholderImage: UIImage(named: "arrow.triangle.2.circlepath"))
                
            }
        }
                
                return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let carItem = carList[indexPath.row]
        

        if let collectionViewController = storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController {
            collectionViewController.documentID = carItem.id
            navigationController?.pushViewController(collectionViewController, animated: true)
            
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
            
            var carLists: [CarList] = []
            
            
            for document in documents {
                
                let data = document.data()
                var score = data["score"] as? Int ?? 0
                let documentID = document.documentID
                
                if let make = document.data()["make"] as? String, make.lowercased() == self.fowardedMake?.lowercased() {
                    score += 3
                }
              
                if let models = document.data()["models"] as? String, models.lowercased() == self.fowardedModel?.lowercased()
                {
                    score += 2
                }
                if let color = document.data()["color"] as? String, color.lowercased() == self.fowardedColor?.lowercased() {
                  
                    score += 1
                }
                
                
                let carList = CarList(id: documentID, score: score, data: data)
                carLists.append(carList)
            }
            
            carLists.sort { $0.score > $1.score }
            
            self.carList = carLists  // Assuming carList is a property of your view controller
           // self.tableView.reloadData()  // Reload table view to reflect sorted data
                    
            
            
            // Extract the sorted data
            self.cars = carLists.map { $0.data }
            
            for img in self.cars {
                if let imgData = img["group_id"] as? String {
                    print(" in FEtch images/\(imgData)")
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
               let color = car["color"] as? String
            {
                let title = "\(make)\n"
                let subTitle = "\(model)"
                let body =  "\(color)"
                let description = textFormat(from: title, subtitle: subTitle, body: body)
                let imageName = "one" // constant image name
                let data = Data(title: description, imageName: imageName)
                dataArray.append(data)
            } else{
                
                let title = "missing info"
                let attributedString = NSAttributedString(string: title)
                let imageName = "one" // constant image name
                let data = Data(title: attributedString, imageName: imageName)
                dataArray.append(data)
            }
        }
        return dataArray
    }
    
    func textFormat(from title: String, subtitle: String, body: String) -> NSAttributedString {
        let attributedText = NSMutableAttributedString()
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3
        paragraphStyle.headIndent = 20
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 20),
            .paragraphStyle : paragraphStyle,
            .foregroundColor: UIColor.darkGray
        ]
        
        attributedText.append(NSAttributedString(string: "\(title)", attributes: titleAttributes))
        
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
               .font: UIFont.systemFont(ofSize: 16),
               .paragraphStyle : paragraphStyle,
               .foregroundColor: UIColor.systemGray
               
           ]
           attributedText.append(NSAttributedString(string: "\(subtitle) ", attributes: subtitleAttributes))
           
        let bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 16),
            .paragraphStyle : paragraphStyle,
            .foregroundColor: UIColor.systemGray
        ]
        attributedText.append(NSAttributedString(string: "\(body)", attributes: bodyAttributes))
        
        return attributedText
    }

}
