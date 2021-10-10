//
//  LoginViewController.swift
//  LocationBasedNotesApplication
//
//  Created by דוד נוי on 06/10/2021.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide the default back buttons
         self.navigationItem.hidesBackButton = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailLabel.becomeFirstResponder()
    }
    
    @IBAction func continueBtn(_ sender: UIButton) {
        
        guard let email = emailLabel.text, !email.isEmpty,
              let password = passwordLabel.text, !password.isEmpty else {return}
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            
            guard error == nil else {
                self?.errorLogin()
                return
            }
            self?.performSegue(withIdentifier: "logToMain", sender: .none)
        }
        
    }
    
    func errorLogin(){
        
        let alert = UIAlertController(title: "Error Login", message: "Incorrect email or password", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Back", style: .cancel, handler: {_ in
            
        }))
        
        present(alert, animated: true)

        emailLabel.text = ""
        passwordLabel.text = ""
    }
    
    
}
