//
//  NotesTableViewController.swift
//  LocationBasedNotesApplication
//
//  Created by דוד נוי on 10/10/2021.
//

import UIKit

class NotesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var notesTableOutlet: UITableView!
    let cdm = CoreDataManager.shared
    
    var noteArr: [Note] =  {
        return CoreDataManager.shared.getNotes()
    }() ?? []
    
    var noteTitle: String?
    let defaultTitle = ["A little empty here..", "Want to write somthing?", "Press the 'plus' button"]
    var arrIsEmpty = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notesTableOutlet.delegate = self
        notesTableOutlet.dataSource = self
        overrideUserInterfaceStyle = .light
        sortByDate()
        
    }
    
    func sortByDate(){
        if let arr = cdm.getNotes(){
            noteArr = arr.sorted() { $0.date > $1.date }
        } else {
            noteArr = []
        }
        
        if noteArr == [] {
            arrIsEmpty = true
        } else {
            arrIsEmpty = false
        }
        
        notesTableOutlet.reloadData()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if arrIsEmpty{
            return defaultTitle.count
        } else {
            return noteArr.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if arrIsEmpty{
            cell.textLabel?.text = defaultTitle[indexPath.row]
            cell.textLabel?.textColor = .systemGray
        } else {
            cell.textLabel?.text = noteArr[indexPath.row].title
            cell.textLabel?.textColor = .black
        }
        return cell
    }
    
    
    
    // MARK: - Navigation
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !arrIsEmpty{
            noteTitle = noteArr[indexPath.row].title
            performSegue(withIdentifier: "tableToNote", sender: .none)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if !arrIsEmpty{
            if let dest = segue.destination as? NoteViewController{
                dest.noteTitle = noteTitle
            }
        }
    }
    
    
}

