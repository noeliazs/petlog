//
//  AuthViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 24/08/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class AuthViewController: UIViewController {
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Autenticación"
    }

    
    @IBAction func signupButtonAction(_ sender: Any) {
        if let email = emailText.text,let password = passText.text{
            Auth.auth().createUser(withEmail: email, password: password){
                (result,error)in
                if let result = result, error == nil{
                    
                    self.navigationController?.pushViewController(HomeViewController(email: result.user.email!,provider: .basic), animated: true)
                }else{
                    let alert = UIAlertController(title: "Error" , message: "No se ha podido registrar el usuario" , preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                    self.present(alert,animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
      
       if let email = emailText.text,let password = passText.text{
           Auth.auth().signIn(withEmail: email, password: password){
               (result,error)in
               if let result = result, error == nil{
                   
                   self.navigationController?.pushViewController(HomeViewController(email: result.user.email!,provider: .basic), animated: true)
               }else{
                   let alert = UIAlertController(title: "Error" , message: "Ese usuario no está registrado" , preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                   self.present(alert,animated: true, completion: nil)
               }
           }
       }
    }
}

