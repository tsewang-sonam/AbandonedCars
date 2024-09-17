//
//  FirstPageViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 4/12/24.
//

import UIKit

class MainMenuViewController: UIViewController {

    
    //var forwardedString : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
