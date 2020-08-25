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
        let brownColor = UIColor(red: 125/255, green: 90/255, blue: 90/255, alpha: 1)
        
        let DarkpinkColor = UIColor(red: 241/255, green: 209/255, blue: 209/255, alpha: 1)
        
        emailText.layer.cornerRadius=10
        emailText.layer.masksToBounds=true
        emailText.layer.borderWidth = 2
        emailText.layer.borderColor = brownColor.cgColor
        passText.layer.cornerRadius=10
        passText.layer.masksToBounds=true
        passText.layer.borderWidth = 2
        passText.layer.borderColor = brownColor.cgColor
        
        
            
        emailText.attributedPlaceholder = NSAttributedString(string: "E-mail",attributes: [NSAttributedString.Key.foregroundColor:DarkpinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
        
        passText.attributedPlaceholder = NSAttributedString(string: "Contraseña",attributes: [NSAttributedString.Key.foregroundColor:DarkpinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
    }

    
    @IBAction func signupButtonAction(_ sender: Any) {
        if let email = emailText.text,let password = passText.text{
            Auth.auth().createUser(withEmail: email, password: password){
                (result,error)in
                if let result = result, error == nil{
                    
                    self.navigationController?.pushViewController(HomeViewController(), animated: true)
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
                   
                   self.navigationController?.pushViewController(MainViewController(), animated: true)
               }else{
                   let alert = UIAlertController(title: "Error" , message: "El usuario no puede acceder. Revise sus credenciales" , preferredStyle: .alert)
                   alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
                   self.present(alert,animated: true, completion: nil)
               }
           }
       }
    }
}

