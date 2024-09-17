//
//  MapViewController.swift
//  Abandoned Cars
//
//  Created by tsewang sonam on 4/16/24.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseFirestore

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let defaults = UserDefaults.standard
    let database = Firestore.firestore()
    
    @IBAction func continueBtn(_ sender: Any) {
        print("pressed")
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "CarDetailsViewController") as? CarDetailsViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedLocation: CLLocationCoordinate2D?
    var pinAnnotation: MKPointAnnotation?
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let zipCode = self.defaults.string(forKey: "zipSaved") ?? ""
        getCoordinates(fromZipCode: zipCode) { coordinates in
            if let coordinates = coordinates {
                print("Latitude: \(coordinates.latitude), Longitude: \(coordinates.longitude)")
                let region = MKCoordinateRegion(center: coordinates, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                self.mapView.setRegion(region, animated: false)
            } else {
                print("Failed to get coordinates for \(zipCode)")
            }
        }
        
        let locationBtn = UIButton(type: .custom)
        locationBtn.setImage(UIImage(named: "arrow"), for: .normal)
        locationBtn.frame = CGRect(x: view.frame.size.width - 70, y: 20, width: 40, height: 40)
        locationBtn.backgroundColor = UIColor.lightGray
        locationBtn.layer.cornerRadius = 10
        locationBtn.layer.masksToBounds = true
        locationBtn.addTarget(self, action: #selector(zoomToUserLocation), for: .touchUpInside)
        mapView.addSubview(locationBtn)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        mapView.addGestureRecognizer(longPressGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }
        
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            annotationView?.image = UIImage(named: "car")
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .ended {
            let locationInView = gestureRecognizer.location(in: mapView)
            let locationOnMap = mapView.convert(locationInView, toCoordinateFrom: mapView)
            
            // Remove previous pin if exists
            if let existingAnnotation = pinAnnotation {
                mapView.removeAnnotation(existingAnnotation)
            }
            
            // Add new pin
            let annotation = MKPointAnnotation()
            annotation.coordinate = locationOnMap
            let newData = [
                "latitude": annotation.coordinate.latitude,
                "longitude": annotation.coordinate.longitude
            ]
            
            let id = self.defaults.string(forKey: "docId") ?? ""
            
            self.database.collection("cars").document(id).updateData(newData as [AnyHashable: Any]) { error in
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Location updated successfully")
                }
            }
            mapView.addAnnotation(annotation)
            pinAnnotation = annotation
            
            // Save selected location
            selectedLocation = locationOnMap
        }
    }
    
    func getCoordinates(fromZipCode zipCode: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(zipCode) { (placemarks, error) in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let placemark = placemarks?.first, let location = placemark.location {
                completion(location.coordinate)
            } else {
                print("No coordinates found for the zip code.")
                completion(nil)
            }
        }
    }
    
    @objc func zoomToUserLocation() {
        if let userLocation = mapView.userLocation.location {
            print("User Location Available:")
            print("Latitude: \(userLocation.coordinate.latitude), Longitude: \(userLocation.coordinate.longitude)")
            
            let region = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        } else {
            print("User Location Not Available")
        }
        
    }
}
