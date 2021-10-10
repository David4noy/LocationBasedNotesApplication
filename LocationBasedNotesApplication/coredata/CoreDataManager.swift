//
//  CoreDataManager.swift
//  LocationBasedNotesApplication
//
//  Created by דוד נוי on 10/10/2021.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init (){}
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "LocationBasedNotesApplication")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getNotes() -> [Note]? {
        
        var noteArr:[Note] = []
        guard let saved = getSaved() else {
            return []
        }
        
        for note in saved {
            if let n = note.toNote() {
                noteArr.append(n)
            }
        }
        return noteArr
    }
    
    func getNoteByTitle(title: String) -> Note?{
        
        guard let saved = getSaved() else {
            return nil
        }
        
        for note in saved {
            if  title == note.title {
                return note.toNote()
            }
        }
        return nil
    }
    
    
    func getSaved() -> [SaveNote]?{
        let request: NSFetchRequest<SaveNote> = SaveNote.fetchRequest()
        let context = persistentContainer.viewContext
        
        if let response = try?  context.fetch(request){
            return response
        }
        return nil
    }
    
    func noteExistsCheck(note: Note) -> SaveNote? {
        return getSaved()?.first(where: { savedNote   in
            savedNote.title == note.title
        }) ?? nil
        
    }
    
    func saveNewNote(note: Note) {
        
        let existsedNote = noteExistsCheck(note: note)
        
        if let existsedNote = existsedNote {
            existsedNote.updateNote(note: note)
        } else {
            SaveNote.saveNote(note: note)
        }
        saveContext()
    }
    
    func deleteNote(note: Note) {
        
        let context = persistentContainer.viewContext
        let existsedNote = noteExistsCheck(note: note)
        
        if let existsedNote = existsedNote {
            context.delete(existsedNote)
        }
        saveContext()
    }
    
}
