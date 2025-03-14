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
    
    var pageControl: UIPageControl!
    
    @IBOutlet weak var home: UIButton!
    
    var documentID: String?
    
    var latitude : Double?
    var longitude : Double?
    var imageGroup : String?
    
    var countyName: String?
    
    var pageNum : Int?
    
    @IBOutlet weak var carName: UILabel!
    
    @IBOutlet weak var carLocation: UILabel!
    
    

    @IBAction func backBtn(_ sender: Any) {
        
            self.navigationController?.popViewController( animated: true)
    }
    
    @IBAction func homeButton(_ sender: Any) {
        
      if let VC = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as? MainMenuViewController {
            
          self.navigationController?.setViewControllers([VC], animated: true)
            
        }
    }
    
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
        
        
        navigationItem.hidesBackButton = true
        home.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
                home.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16), // Align to the right
                home.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0)
            ])
        
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
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        collectionView.isPagingEnabled = true
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let pageWidth = collectionView.frame.width
            let currentPage = Int(collectionView.contentOffset.x / pageWidth)
            pageControl.currentPage = Int((collectionView.contentOffset.x + (0.5 * pageWidth)) / pageWidth)

        }
    

    
    // Here we fecth the data from firebase database for displaying text about car details and location it was found. ALso we get the group id so we can fetch multiple image related to a single item from the fire store.
   
    // MARK: - fetch
    func fetchCarDetails(documentID: String) {
        
       // here newDate is todays date and will be compared to old date of upload
        let newDate = Calendar.current.startOfDay(for: Date())
        
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
                let getDate = data?["upLoadDate"] as? String
               
                var temp = 0
                print("image=  \(self.imageGroup ?? "error")")
                
                print("date = \(String(describing: getDate))")
                print("newDate = \(newDate)")
              
                // using dateformatter to make the date from string to date
                let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd"
                
                let lastUpdatedDate = formatter.date(from: getDate ?? "") ?? Date.distantPast
                
                let calendar = Calendar.current
                let numberOfDays = calendar.dateComponents([.day], from: lastUpdatedDate, to: newDate).day ?? 5
                print("numberOfDays = \(numberOfDays)")
                // compares old date to currentdate and get the difference.
                if numberOfDays > 0 {
                    temp = (Int(carDay ?? "5555555") ?? 99999) + numberOfDays
                            }
                
               
                
                self.latitude = carLat ?? 37.8721
                self.longitude = carLong ?? 175.6829
                self.reverseLocation(latitude: carLat ?? 37.8721, longitude: carLong ?? 175.6829){ address in
                    if let address = address {
                        print("Address: \(address)")
                        self.carLocation.text = address
                        self.carLocation.lineBreakMode = .byWordWrapping
                        self.carLocation.font = UIFont.systemFont(ofSize: 16)
                    } else {
                        print("Could not retrieve address.")
                        self.carLocation.text = "address not found"
                    }
                    
                    
//                    self.carName.text =  " \(carMake ?? "") \(carModel ?? "")  \(carColor ?? "")  \n Days on Street : \(String(temp)) \n Location : \(String(describing: self.countyName ?? "Nil"))"
                    
                    let carDetails = """
                         \(carMake ?? "") \(carModel ?? "") \(carColor ?? "")
                         Days on Street: \(String(temp))
                         Location: \(self.countyName ?? "")
                    """
                    
                    
                    // Adding right padding and other styling options
                    let formattedText = carDetails.padding(toLength: carDetails.count + 10, withPad: " ", startingAt: 0)


                    
                    self.carName.text = formattedText

                    self.carName.numberOfLines = 0  // Allows for multi-line text
                    self.carName.lineBreakMode = .byWordWrapping  // Wrap words nicely
                    self.carName.font = UIFont.systemFont(ofSize: 16)  // Adjust font size
                    
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
        pageNum = items.count
        
        
        pageControl = UIPageControl()
            pageControl.translatesAutoresizingMaskIntoConstraints = false
            pageControl.numberOfPages = pageNum ?? 5  // Set this dynamically based on your data
            pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.currentPageIndicatorTintColor = .black
              view.addSubview(pageControl)

              NSLayoutConstraint.activate([
                  pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
                  pageControl.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -5)
              ])
        
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
                        cell.carImage.contentMode = .scaleAspectFit
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
                     self.countyName = "\(locality)"
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
