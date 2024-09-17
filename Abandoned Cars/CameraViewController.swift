//
//  CameraUIViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 4/12/24.
//

import UIKit
import FirebaseStorage
import FirebaseFirestore

class CameraViewController: UIViewController, UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    // Generate a unique image group UUID
     let imageGroupUUID = UUID().uuidString
    
    let database = Firestore.firestore()

    
    //  private reference to the firebaseStorage
    private let storage = Storage.storage().reference()
    
    var currentCount = 0
    
    @IBOutlet weak var doneView: UIButton!
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImagePicker()
        navigationItem.hidesBackButton = true
        doneView.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    func setupImagePicker() {
            imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
        }
    
    @IBAction func backBtn(_ sender: Any) {
        
        let alert = UIAlertController(title: "Heading Back ?", message: "You will lose the images you captured.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("I Know", comment: "Default action"), style: .default, handler:
                                        { _ in
            NSLog(" 'I Know' pressed")
            
            // User is taken back to the main menu option.
            
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as? MainMenuViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancel action"), style: .cancel, handler:
                                        { _ in
            // When cancel pressed ... we continue on the same view
            
            NSLog("cancel pressed")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func takePicBtn(_ sender: Any) {
        if currentCount < sixImages.count {
                    present(imagePicker, animated: true)
                    
                
                } else {
                    print("All images taken")
                }
        
        if(currentCount < 1){
            doneView.isHidden = true
        }else{
            doneView.isHidden = false
        }
    }
    
    
    @IBAction func doneBtn(_ sender: Any) {
        
                
        let carCollection = database.collection("cars")
        let carReference = carCollection.document()
        carReference.setData([
            "group_id" : imageGroupUUID,
            "timestamp": FieldValue.serverTimestamp()
        ])
            let forward = imageGroupUUID
            if let VC = self.storyboard?.instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController {
                VC.fowardedString = forward
                self.navigationController?.pushViewController(VC, animated: true)
            }
    }
  
    
    @IBOutlet var sixImages: [UIImageView]!
 
    
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        
        // Array to store image data
        var imageDataArray: [Data] = []
        
        
        // Here we select the three or more images .... give them same group UUID and have unique index .. then we store
        //  it in the fireStorage database... Idea that having a group UUID will help retreive image quicker
        
        if let image = info[.editedImage] as? UIImage {
            if currentCount < sixImages.count {
                sixImages[currentCount].image = image
                sixImages[currentCount].contentMode = .scaleAspectFill
                
                currentCount += 1
                
                
                if let imageData = image.pngData() {
                    // Append image data to the array
                    imageDataArray.append(imageData)
                   
                    
                    
                    let index = currentCount
                    let imageName = "\(imageGroupUUID)_\(index).png"
                    
                    // Create a reference to the location in Firebase Storage where the image will be uploaded
                    let imageRef = storage.child("images/\(imageName)")
                    
                    // Upload the image data to Firebase Storage
                    imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                        if let error = error {
                            print("Error uploading image: \(error.localizedDescription)")
                            return
                        }
                        
                        print("Image uploaded successfully! Metadata: \(String(describing: metadata))")
                    }
                }
            }
        }
    }
    
}


