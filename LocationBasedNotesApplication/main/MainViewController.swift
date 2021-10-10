//
//  MainViewController.swift
//  LocationBasedNotesApplication
//
//  Created by דוד נוי on 06/10/2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import MapKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var isMoving = false
    var isDragging = false
    let firebaseDB = Firestore.firestore()
    var currentLocation: CLLocationCoordinate2D?
    let cdm = CoreDataManager.shared
    var didUpdate: Bool = true
    
    let floatingButton: UIView = {
        
        // floating button with plus in the middle
        let button = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        button.backgroundColor = .purple
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30,weight: .unspecified))
        let imageView = UIImageView(image: image)
        button.addSubview(imageView)
        imageView.frame = CGRect(x: button.bounds.maxX/4, y: button.bounds.maxY/4, width: 30, height: 30)
        button.bringSubviewToFront(imageView)
        button.tintColor = .white
        button.layer.cornerRadius = 30
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadFunc()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingButton.frame = CGRect(x: view.frame.size.width - 100,
                                      y: view.frame.size.height - 100,
                                      width: 60, height: 60)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        userCheck()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dest = segue.destination as? NoteViewController,
           let location = currentLocation {
            dest.currentLocation = location
        } else if let dest = segue.destination as? MapViewController{
            dest.delegate = self
            weak var temp = dest
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "didUpdateNotes"), object: nil, queue: .main, using: { notification in
                temp?.getAnnotationsFromData()
            })
        } else if let dest = segue.destination as? NotesTableViewController{
            weak var temp = dest
            NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "didUpdateNotes"), object: nil, queue: .main, using: { notification in
                
                temp?.sortByDate()
            })
        }
    }
    
    @IBAction func logoutBtn(_ sender: UIButton) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
            login()
        } catch  {
            print("***Error:", error)
        }
    }
    
    @IBAction func viewSelect(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            notesView.isHidden = false
            mapView.isHidden = true
        case 1:
            notesView.isHidden = true
            mapView.isHidden = false
        default:
            notesView.isHidden = false
            mapView.isHidden = true
        } // switch end
    }
    
    
    func userCheck(){
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            login()
        } else {
            guard let uid = FirebaseAuth.Auth.auth().currentUser?.uid else {return}
            firebaseDB.collection("users").document(uid).getDocument { [weak self] (doc, error) in
                
                // fetch name
                if error == nil {
                    guard let doc = doc else {return}
                    if doc.exists {
                        let name = doc.data()
                        guard let userName = name?["name"] else {
                            self?.welcomeLabel.text = "Welcome!"
                            return
                        }
                        self?.welcomeLabel.text = "Welcome \(userName)!"
                    }
                }// fetch name end
            } // closure end
        } // else end
    }
    
    func login(){
        performSegue(withIdentifier: "toLogin", sender: .none)
    }
    
    @objc func addNote(){
        performSegue(withIdentifier: "toNote", sender: .none)
    }
        
    @IBAction func unwindToMain(_ sender: UIStoryboardSegue){}
    
    func loadFunc(){
        
        notesView.isHidden = false
        mapView.isHidden = true
        
        view.addSubview(floatingButton)
        view.bringSubviewToFront(floatingButton)

    }
    
}


extension MainViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: floatingButton)
        
        if floatingButton.bounds.contains(location) {
            isDragging = true
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDragging, let touch = touches.first else {
            return
        }
        let location = touch.location(in: view)
        floatingButton.frame.origin.x = location.x - (floatingButton.frame.size.width/2)
        floatingButton.frame.origin.y = location.y - (floatingButton.frame.size.height/2)
        isMoving = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        let location = touch.location(in: floatingButton)
        
        if floatingButton.bounds.contains(location) && !isMoving {
            addNote()
        }
        
        isDragging = false
        isMoving = false
    }
}

extension MainViewController: MapCurrentLocation {
    func didUpdateLocation(location: CLLocationCoordinate2D?) {
        currentLocation = location
    }
    
}
