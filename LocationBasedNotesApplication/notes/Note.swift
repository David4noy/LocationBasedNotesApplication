//
//  Note.swift
//  LocationBasedNotesApplication
//
//  Created by דוד נוי on 10/10/2021.
//

import Foundation
import MapKit

class Note: NSObject, MKAnnotation {
    
    var title:String?
    var body: String
    var date: Date
    var coordinate: CLLocationCoordinate2D
    
    init(title:String, body: String, date: Date, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.body = body
        self.date = date
        self.coordinate = coordinate
        
    }
    
}
