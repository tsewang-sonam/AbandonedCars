//
//  ReportEndViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 4/16/24.
//

import UIKit
import FLAnimatedImage

class ReportEndViewController: UIViewController {

    
    @IBOutlet weak var lottieView: UIView!
    
   
    
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imgGIF = FLAnimatedImageView()
        imgGIF.contentMode = .scaleAspectFit
        imgGIF.translatesAutoresizingMaskIntoConstraints = false
        
        lottieView.addSubview(imgGIF)
        
        NSLayoutConstraint.activate([
            imgGIF.topAnchor.constraint(equalTo: lottieView.topAnchor),
            imgGIF.bottomAnchor.constraint(equalTo: lottieView.bottomAnchor),
            imgGIF.rightAnchor.constraint(equalTo: lottieView.rightAnchor),
            imgGIF.leftAnchor.constraint(equalTo: lottieView.leftAnchor)
            
        ])
        
        if let pathToGIF = Bundle.main.path(forResource: "thankYou", ofType: "gif"),
           let gifData = try?Data(contentsOf: URL(fileURLWithPath: pathToGIF)){
            let AnimatedImage = FLAnimatedImage(animatedGIFData: gifData)
            imgGIF.animatedImage = AnimatedImage
        }
        

        
        
    }
   
    
    @IBAction func returnBtn(_ sender: Any) {
        if let VC = self.storyboard?.instantiateViewController(withIdentifier: "MainMenuViewController") as? MainMenuViewController
        {
            self.navigationController?.setViewControllers([VC], animated: true)
        }
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
