//
//  MapViewController.swift
//  LocationBasedNotesApplication
//
//  Created by דוד נוי on 09/10/2021.
//

import UIKit
import MapKit
import CoreLocation

protocol MapCurrentLocation : AnyObject{
    func didUpdateLocation(location: CLLocationCoordinate2D?)
}

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapOutlet: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 1000
    var noteTitle: String?
    weak var delegate:MapCurrentLocation?
    
    let cdm = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunc()
    }
    
    func loadFunc(){
        
        locationManager.requestWhenInUseAuthorization()
        
        mapOutlet.delegate = self
        mapOutlet.showsUserLocation = true
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        getAnnotationsFromData()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        
        let region = MKCoordinateRegion.init(center: locValue, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapOutlet.setRegion(region, animated: true)
        
        delegate?.didUpdateLocation(location: locValue)
        
        locationManager.stopUpdatingLocation()
        
    }
    
    func getAnnotationsFromData() {
        
        mapOutlet.removeAnnotations(mapOutlet.annotations)
        if let arr = cdm.getNotes(){
            for pin in arr {
                mapOutlet.addAnnotation(pin)
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        noteTitle =  (view.annotation)?.title ?? nil
        showNote()
    }
    
    @objc func showNote(){
        performSegue(withIdentifier: "mapToNote", sender: .none)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? NoteViewController{
            dest.noteTitle = noteTitle
        }
    }
    
}



