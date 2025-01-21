//
//  ReportEndViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 4/16/24.
//

import UIKit
import Lottie

class ReportEndViewController: UIViewController {

    
    @IBOutlet weak var lottieView: UIView!
    
    
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     let animation = LottieAnimationView(name: "read")
            
            
            
            
            animation.frame = lottieView.bounds
            animation.contentMode =  .scaleAspectFit
            animation.loopMode = .loop
            animation.animationSpeed = 1.0
            // Do any additional setup after loading the view.
            
        lottieView.addSubview(animation)
            animation.play()
        
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
