//
//  FirstPageViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 4/12/24.
//

import UIKit
import FLAnimatedImage

class MainMenuViewController: UIViewController {

    
    //var forwardedString : String?
    
    @IBOutlet weak var lottieView: UIView!
    
    let loadingImage = FLAnimatedImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadingGIF()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            self.loadingImage.isHidden = true
        }
        
        

        let imageGIF = FLAnimatedImageView()
        imageGIF.contentMode = .scaleAspectFit
        imageGIF.translatesAutoresizingMaskIntoConstraints = false
        
        lottieView.addSubview(imageGIF)
        
        NSLayoutConstraint.activate([
            imageGIF.topAnchor.constraint(equalTo: lottieView.topAnchor),
            imageGIF.bottomAnchor.constraint(equalTo: lottieView.bottomAnchor),
            imageGIF.rightAnchor.constraint(equalTo: lottieView.rightAnchor),
            imageGIF.leftAnchor.constraint(equalTo: lottieView.leftAnchor)
        ])
        
       if let pathToGIF = Bundle.main.path(forResource: "home", ofType: "gif"),
        let gifData = try? Data(contentsOf: URL(fileURLWithPath: pathToGIF)){
            
            let AnimatedImage = FLAnimatedImage(animatedGIFData: gifData)
            imageGIF.animatedImage = AnimatedImage
            
        }
        
    }
    
    @IBAction func searchBtn(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CarSearchViewController") as? CarSearchViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func reportBtn(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CameraViewController") as? CameraViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func helpBtn(_ sender: Any) {
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContentTableViewController") as? ContentTableViewController{
            self.navigationController?.pushViewController(vc, animated: true)  
        }
    }
    
    func loadingGIF(){
        
        loadingImage.frame = UIScreen.main.bounds
        loadingImage.contentMode = .scaleAspectFit
        loadingImage.clipsToBounds = true
        
        if let pathToGIF = Bundle.main.path(forResource: "animation", ofType: "gif"),
           let gifData = try?Data(contentsOf: URL(fileURLWithPath: pathToGIF)){
            
            let animation  = FLAnimatedImage(animatedGIFData: gifData)
            loadingImage.animatedImage = animation
        }
        
        view.addSubview(loadingImage)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
