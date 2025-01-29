//
//  CollectionViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 6/25/24.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore
import CoreLocation
import SDWebImage

class CollectionViewController: UIViewController {
    
    
    var documentID: String?
    
    var latitude : Double?
    var longitude : Double?
    var imageGroup : String?
    
    
    //var id
    
    @IBOutlet weak var carName: UILabel!
    
    @IBOutlet weak var carLocation: UILabel!
    
    @IBAction func copyBtn(_ sender: Any) {
        let text = "\(latitude ?? 37.8721), \(longitude ?? 175.6829) "
        UIPasteboard.general.string = text
        copyConfirmation()
    }
    
    @IBAction func viewCarBtn(_ sender: Any) {
        openMaps()
    }
    // Firebase Storage reference
        let storage = Storage.storage()
    
    var items: [String] = []
    
    var words = ["one","two","three","four","five","six","seven", "eight"]
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let documentID = documentID {
            fetchCarDetails(documentID: documentID)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        print("Delegate: \(collectionView.delegate as Any)")
        print(type(of: collectionView.collectionViewLayout))
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            print("Using UICollectionViewFlowLayout") // Debugging log
            layout.estimatedItemSize = .zero
            layout.scrollDirection = .horizontal
        } else {
            // Set a new layout if it's not using UICollectionViewFlowLayout
            collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        }
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
    // Here we fecth the data from firebase database for displaying text about car details and location it was found. ALso we get the group id so we can fetch multiple image related to a single item from the fire store.
    func fetchCarDetails(documentID: String) {
        let db = Firestore.firestore()
        let docRef = db.collection("cars").document(documentID)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                let carMake = data?["make"] as? String
                let carModel = data?["models"] as? String
                let carColor = data?["color"] as? String
                let carDay = data?["duration"] as? String
                let carLat = data?["latitude"] as? Double
                let carLong = data?["longitude"] as? Double
                self.imageGroup = data?["group_id"] as? String
               
                print("image=  \(self.imageGroup ?? "error")")
               
                
                self.carName.text =  "\(carMake ?? "") \(carModel ?? "")  \n\(carColor ?? "")  \n Days on Street '\(carDay ?? "")'"
                
                self.latitude = carLat ?? 37.8721
                self.longitude = carLong ?? 175.6829
                self.reverseLocation(latitude: carLat ?? 37.8721, longitude: carLong ?? 175.6829){ address in
                    if let address = address {
                        print("Address: \(address)")
                        self.carLocation.text = address
                    } else {
                        print("Could not retrieve address.")
                        self.carLocation.text = "address not found"
                    }
                }
               
              // here we call this function so that we can filter and get the images that are in same group
                self.fetchAndFilterImagesByPrefix(prefix: self.imageGroup ?? "a"){
                  DispatchQueue.main.async {
                    self.collectionView.reloadData()// Notify that fetching is complete
                }
                    //self.collectionCell.reloadData()
                }
                
            } else {
                print("Document does not exist")
            }
            
        }
    }
    
    func fetchAndFilterImagesByPrefix(prefix: String, completion: @escaping () -> Void) {
        // Clear the array before adding new references
        items.removeAll()

        // Create a reference to the folder in Firebase Storage
        let imagesRef = storage.reference().child("images")

        imagesRef.listAll { (result) in
            switch result {
            case .success(let storageListResult):
                // Loop through each item in the result
                for item in storageListResult.items {
                    let imagePath = item.fullPath // The image file name
                    
                    // Filter by prefix
                    if imagePath.hasPrefix("images/\(prefix)") {
                        
                        // adding all the images names of the same group to the array
                        self.items.append(imagePath)
                    }
                }

                // After filtering and creating references, reload the collection view to display filtered images
                DispatchQueue.main.async {
                                completion() // Notify that fetching is complete
                            }

            case .failure(let error):
                // Handle error if the listing failed
                print("Error listing images: \(error.localizedDescription)")
                DispatchQueue.main.async {
                               completion() // Still call the completion handler even on failure
                           }
            }
        }
    }
    
    func copyConfirmation(){
        let alert = UIAlertController(title: "Address Copied", message: "", preferredStyle: .alert)
        present(alert, animated: true, completion: {
            print("Is : \(String(describing: self.imageGroup))")
            DispatchQueue.main.asyncAfter(deadline: .now()+1){
                alert.dismiss(animated: true, completion: nil)
            }
        })
        
    }
    
    func openMaps() {
        if let url = URL(string: "maps://?q=\(latitude ?? 37.8721),\(longitude ?? 175.6829)") { // San Francisco coordinates
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
   



extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print(" Count is \(items.count)")
        return items.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        
        let imgUrl = items[indexPath.row]

      // we get the image source path from the array and download images from the firebase storage and display it on UIImage using SDWebImage.
        
        if let url = URL(string: imgUrl), let storagePath = url.path.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
                
                let storageRef = Storage.storage().reference(withPath: storagePath)
                
                // Download the image URL from Firebase Storage
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting image URL: \(error)")
                        return
                    }
                    
                    if let url = url {
                        
                        cell.carImage.sd_setImage(with: url, placeholderImage: UIImage(named: "car1"))
                    }
                }
            }
        
        return cell
    }
    
    
   
    
    func reverseLocation(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void){
        
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Error in reverse geocoding: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let placemark = placemarks?.first else {
                    print("No placemark found")
                    completion(nil)
                    return
                }
            
            // Construct address from placemark
                
            var addressString = ""
                 
                 if let street = placemark.thoroughfare {
                     addressString += "\(street), \n "
                 }
                 if let subLocality = placemark.subLocality {
                     addressString += "\(subLocality), "
                 }
                 if let locality = placemark.locality {
                     addressString += "\(locality),  \n"
                 }
                 if let administrativeArea = placemark.administrativeArea {
                     addressString += "\(administrativeArea),  \n"
                 }
                 if let postalCode = placemark.postalCode {
                     addressString += "\(postalCode),  \n"
                 }
                 if let country = placemark.country {
                     addressString += "\(country)"
                 }
                 
                 // Remove trailing comma and space
                 addressString = addressString.trimmingCharacters(in: .whitespacesAndNewlines)
                 
                 completion(addressString)
             }
        
        
        
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenSize = UIScreen.main.bounds.size
        let height = screenSize.height
        let width = screenSize.width
        
        if(height < 570){
            print("One")
            return CGSize(width: 200, height:220)
            
        } else if (height < 750){
            print("Two")
            return CGSize(width: 300, height:340)
            
        }else{
            print("Three")
            return CGSize(width: 400, height:480)
           
        }
        
            
    }
    
}
