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
    
    let alert=Alert()
    
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
            if isValidEmail(string: email){
                if isValidPassword(string: password){
                    Auth.auth().createUser(withEmail: email, password: password){
                        (result,error)in
                        if let result = result, error == nil{
                            
                            self.navigationController?.pushViewController(HomeViewController(), animated: true)
                        }else{
                            self.alert.viewSimpleAlert(view: self,title:"Error",message:"No se ha podido registrar el usuario")
                        }
                    }
                }
                else{
                     self.alert.viewSimpleAlert(view: self,title:"Error",message:"Contraseña no válida. Introduzca al menos 6 caracteres.")
                }
            }
            else{
               self.alert.viewSimpleAlert(view: self,title:"Error",message:"E-mail no válido.")
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
                self.alert.viewSimpleAlert(view: self,title:"Error",message:"El usuario no puede acceder. Revise sus credenciales")
               }
           }
       }
    }
    
    func isValidEmail(string: String) -> Bool {
          let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
          let emailTest = NSPredicate(format:"SELF MATCHES %@", emailReg)
          return emailTest.evaluate(with: string)
      }
      
      func isValidPassword(string: String) -> Bool{
          if string.count<6{
              return false
          }
          else{
              return true
          }
      }
     
}

