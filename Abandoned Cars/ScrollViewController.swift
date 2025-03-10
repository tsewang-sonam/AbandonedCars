//
//  ScrollViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 1/16/25.
//

import UIKit

class ScrollViewController: UIViewController {

    @IBOutlet weak var displayLabel: UILabel!
    var textToDisplay: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         guard let textToDisplay = textToDisplay  else { return }
        
        if let data = textToDisplay.data(using: .utf8){
            let sentence = try? NSAttributedString(
                data: data, options: [.documentType: NSAttributedString.DocumentType.html,
                                      .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil )
            
            displayLabel.attributedText = sentence
            displayLabel.textColor = UIColor{ traitCollection in
                return traitCollection.userInterfaceStyle == .dark ? .white : .darkGray
            }
        }
        

        // Do any additional setup after loading the view.
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
