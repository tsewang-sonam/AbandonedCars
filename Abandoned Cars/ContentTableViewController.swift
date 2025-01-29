//
//  ContentTableViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 1/15/25.
//

import UIKit

class ContentTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView! // Connect this in storyboard
    
    let details = ["""
                   <!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Immediate Steps</title><style>body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; font-size: 16px; color: #333; line-height: 1.6; margin: 20px; padding: 20px; background-color: #f9f9f9; } h1 { font-size: 22px; font-weight: bold; color: #1a73e8; text-align: center; } h2 { font-size: 18px; margin-top: 20px; color: #333; } ul { padding-left: 20px; } li { margin-bottom: 10px; }</style></head><body><h1>Immediate Steps</h1><h2>Stay Calm and Assess:</h2><ul><li>Confirm your car is indeed missing and not towed.</li><li>Ensure you're in a secure location before taking further action. Avoid confronting anyone you suspect of being involved.</li></ul><h2>Contact Authorities:</h2><ul><li>Call the non-emergency line and file a police report. Provide them with necessary details such as the make, model, color, license plate number, and VIN.</li><li>Ask for a copy of the police report or at least the report number for future reference.</li></ul><h2>Notify Your Insurance:</h2><ul><li>Call your insurance provider immediately to report the theft. Provide them with the police report number.</li><li>Ask about coverage for rental cars if you need a temporary vehicle.</li><li>Inquire about the next steps for a stolen vehicle claim.</li></ul><h2>Alert Your Lender/Leasing Company:</h2><ul><li>If you have a loan or lease, notify your lender or leasing company about the theft to prevent any liability issues.</li></ul><h2>Check for Tracking or GPS:</h2><ul><li>If your car has a GPS tracker, use it to track its location.</li><li>Some vehicles have tracking services like OnStar that can help recover the car.</li></ul><h2>Spread the Word:</h2><ul><li>Share your car's details on social media or local neighborhood platforms like Nextdoor to alert others.</li><li>Consider reporting the theft to car tracking apps like Stolen911 or similar services if available.</li></ul></body></html>

                   """, """
                        <!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Aftermath: Steps to Take After the Car Is Stolen</title><style>body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; font-size: 16px; color: #333; line-height: 1.6; margin: 20px; padding: 20px; background-color: #f9f9f9; } h1 { font-size: 22px; font-weight: bold; color: #1a73e8; text-align: center; } h2 { font-size: 18px; margin-top: 20px; color: #333; } ul { padding-left: 20px; } li { margin-bottom: 10px; }</style></head><body><h1>Aftermath: Steps to Take After the Car Is Stolen</h1><h2>Car Recovery:</h2><ul><li>Follow up with the police on any updates regarding the recovery of your vehicle.</li><li>Check with local impound lots in case your car was found and towed there.</li></ul><h2>Work with Insurance:</h2><ul><li>Submit any required documentation to your insurance company for processing.</li><li>Understand the terms of your insurance coverage for replacement or repairs.</li><li>Work through the claims process: the insurer may cover repair costs if the car is recovered or offer a replacement if the car is declared a total loss.</li></ul><h2>Vehicle Damage Assessment:</h2><ul><li>If recovered, inspect the vehicle for any damage. Make sure to document everything.</li><li>Work with your insurance company for repairs or assess if you’ll be receiving compensation for a new car.</li></ul><h2>Avoid Fraud:</h2><ul><li>Be cautious of potential scams. Thieves may try to sell your car’s parts or attempt to re-register it using forged documents.</li><li>Regularly monitor online marketplaces to ensure your vehicle isn’t being sold illegally.</li></ul><h2>Legal Issues:</h2><ul><li>If your car was used in a crime, you might need to cooperate with police investigations.</li><li>Contact a legal advisor if needed to protect yourself from any legal implications resulting from the theft.</li></ul><h2>Emotional Impact:</h2><ul><li>Acknowledge the emotional stress of car theft. It’s a violation of personal space and can lead to feelings of anxiety.</li><li>Consider talking to a counselor or someone you trust to navigate the stress or frustration.</li></ul></body></html>

                        ""","""
                        <!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Prevention: How to Prevent Car Theft</title><style>body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; font-size: 16px; color: #333; line-height: 1.6; margin: 20px; padding: 20px; background-color: #f9f9f9; } h1 { font-size: 22px; font-weight: bold; color: #1a73e8; text-align: center; } h2 { font-size: 18px; margin-top: 20px; color: #333; } ul { padding-left: 20px; } li { margin-bottom: 10px; }</style></head><body><h1>Prevention: How to Prevent Car Theft</h1><h2>General Tips:</h2><ul><li>Always lock your car and roll up the windows, even if you're just stepping away for a minute.</li><li>Never leave spare keys in or near your car.</li><li>Install an alarm or GPS tracking system to deter thieves.</li><li>Park in well-lit, busy areas, and avoid secluded spots.</li><li>Use a steering wheel lock or other anti-theft devices.</li><li>Consider installing a dash cam or surveillance cameras around your parking space.</li></ul><h2>Advanced Protection:</h2><ul><li>Use a kill switch or disable your car’s ignition system for added security.</li><li>Utilize smartphone-enabled vehicle tracking systems.</li><li>Employ tinted windows to limit visibility into the car.</li></ul><h2>Keep Your Car’s Appearance Low-Key:</h2><ul><li>Avoid flashy accessories or decals that might attract thieves.</li><li>Remove valuables from plain sight; use the glove compartment or trunk.</li></ul><h2>Home and Neighborhood Safety:</h2><ul><li>Install motion-sensor lights in your driveway or garage.</li><li>Lock garage doors, gates, and fences to secure your vehicle at home.</li></ul></body></html>

                        """, """
                `<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Long-Term Considerations</title><style>body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif; font-size: 16px; color: #333; line-height: 1.6; margin: 20px; padding: 20px; background-color: #f9f9f9; } h1 { font-size: 22px; font-weight: bold; color: #1a73e8; text-align: center; } h2 { font-size: 18px; margin-top: 20px; color: #333; } ul { padding-left: 20px; } li { margin-bottom: 10px; }</style></head><body><h1>Long-Term Considerations</h1><h2>Reevaluate Insurance:</h2><ul><li>Review your policy and consider adding theft protection if it wasn’t included initially.</li><li>Consider purchasing a new car with enhanced security features.</li></ul><h2>Stay Vigilant:</h2><ul><li>Always be alert for any unusual activity around your vehicle, especially in areas where theft is common.</li><li>Keep an eye on online listings for stolen parts or whole cars.</li></ul><h2>Record Keeping:</h2><ul><li>Keep all documentation, including the police report, insurance claim, and any communication with authorities, for future reference or in case of further incidents.</li></ul></body></html>
>

"""]
    
    let rowNames = ["Immediate Steps","Steps to Take After the Car Is Stolen","How to Prevent Car Theft","Long-Term Considerations"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = rowNames[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ScrollViewController", sender: details[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ScrollViewController",
           let vc = segue.destination as? ScrollViewController,
           let detailText = sender as? String {
            vc.textToDisplay = detailText
        }
    }
}
