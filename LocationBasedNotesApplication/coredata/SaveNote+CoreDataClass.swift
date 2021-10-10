//
//  SaveNote+CoreDataClass.swift
//  LocationBasedNotesApplication
//
//  Created by דוד נוי on 10/10/2021.
//
//

import Foundation
import CoreData

@objc(SaveNote)
public class SaveNote: NSManagedObject {
        
    static func saveNote(note: Note) {
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        let savedNote = NSEntityDescription.insertNewObject(forEntityName: "SaveNote", into: context) as! SaveNote
        
        savedNote.title = note.title
        savedNote.body = note.body
        savedNote.date = note.date
        savedNote.latitude = note.coordinate.latitude
        savedNote.longitude = note.coordinate.longitude
        
    }
    
    
     func toNote() -> Note? {
        
        guard let title = self.title,
              let body = self.body,
              let date = self.date else {
            return nil
        }
   
        return Note(title: title, body: body, date: date, coordinate: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude))
    }
    

      func updateNote(note: Note){
        
        self.title = note.title
        self.body = note.body
        self.date = note.date
        self.latitude = note.coordinate.latitude
        self.longitude = note.coordinate.longitude
        
    }
    
    
}
