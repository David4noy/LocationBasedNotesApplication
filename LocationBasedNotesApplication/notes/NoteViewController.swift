//
//  NoteViewController.swift
//  LocationBasedNotesApplication
//
//  Created by דוד נוי on 07/10/2021.
//

import UIKit
import MapKit

class NoteViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var dateOutlet: UIDatePicker!
    @IBOutlet weak var titleOutlet: UITextField!
    @IBOutlet weak var body: UITextView!
    @IBOutlet weak var bodyPlaceholder: UILabel!
    
    var currentLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    var noteTitle: String?
    
    let cdm = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        body.delegate = self
        view.bringSubviewToFront(bodyPlaceholder)
        
        loadNote()
        
        if body.hasText{
            bodyPlaceholder.isHidden = true
        } else {
            bodyPlaceholder.isHidden = false
        }
        
    }
    
    func loadNote(){
        guard let title = noteTitle else {return}
        
        let temp = cdm.getNoteByTitle(title: title)
        
        guard let currentNote = temp else {return}
        
        dateOutlet.date = currentNote.date
        titleOutlet.text = currentNote.title
        body.text = currentNote.body
        currentLocation = currentNote.coordinate
        
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        bodyPlaceholder.isHidden = true
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if body.hasText{
            bodyPlaceholder.isHidden = true
        } else {
            bodyPlaceholder.isHidden = false
        }
    }
    
    @IBAction func saveNote(_ sender: UIButton) {
        
        if let title = titleOutlet.text {
            let newNote = Note(title: title,
                               body: body.text,
                               date: dateOutlet.date,
                               coordinate: currentLocation)
            
            cdm.saveNewNote(note: newNote)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didUpdateNotes"), object: nil)
            self.performSegue(withIdentifier: "noteToMain", sender: .none)
        } else {
            showErrorAlert("Please write a title.")
        }
    }
    
    @IBAction func deleteNote(_ sender: UIButton) {
        if let title = noteTitle,
           let noteToDelete = cdm.getNoteByTitle(title: title) {
            cdm.deleteNote(note: noteToDelete)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "didUpdateNotes"), object: nil)
            self.performSegue(withIdentifier: "noteToMain", sender: .none)
        }
        else{
            showErrorAlert("Note not exists.")
        }
    }
    
    func showErrorAlert(_ error: String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {_ in}))
        
        present(alert, animated: true)
    }
    
}
