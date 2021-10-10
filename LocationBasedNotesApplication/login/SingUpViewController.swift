//
//  SingUpViewController.swift
//  LocationBasedNotesApplication
//
//  Created by דוד נוי on 07/10/2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class SingUpViewController: UIViewController {

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    
    @IBAction func createBtn(_ sender: UIButton) {
        
        guard let name = nameLabel.text,
              let email = emailLabel.text,
              let password = passwordLabel.text else {
            showErrorAlert("Please fill all the fields")
            return
        }
        
        let error = validateFiledss(name: name, email: email, password: password)
        
        if error != nil {
            // just cheked so using "!"
            showErrorAlert(error!)
        } else {

            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, err) in
                
                if err != nil {
                    self?.showErrorAlert("Error creating user\nCould be because:\nAlready exists\nInternet connection")
                } else {
                    
                    let db = Firestore.firestore()
                    guard let uid = result?.user.uid else {return}
                    
                    db.collection("users").document(uid).setData(["name":name])
                    self?.performSegue(withIdentifier: "logToMain", sender: .none)
                }
                
            }
            
        }
        
    }
    
    // checking the fields
    func validateFiledss(name: String, email: String, password: String) -> String? {

        if name.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            email.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.trimmingCharacters(in: .whitespacesAndNewlines).count < 8 {
            return "Please fill all the fields correctly"
        }
        
        return nil
    }
    
    func showErrorAlert(_ error: String){
    let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
    

    alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: {_ in}))
    
    present(alert, animated: true)
    }
    

}

