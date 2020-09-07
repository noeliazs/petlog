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
    let colors=Colors()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Autenticación"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AuthViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        textFieldsConfigure()
       
    }
    
    func textFieldsConfigure(){
        emailText.layer.cornerRadius=10
        emailText.layer.masksToBounds=true
        emailText.layer.borderWidth = 2
        passText.layer.cornerRadius=10
        passText.layer.masksToBounds=true
        passText.layer.borderWidth = 2
        putColors(isTrue: true)
            
        emailText.attributedPlaceholder = NSAttributedString(string: "E-mail",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
               
        passText.attributedPlaceholder = NSAttributedString(string: "Contraseña",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
    }
    
    @objc func dismissKeyboard() {
              view.endEditing(true)
          }

    
    @IBAction func signupButtonAction(_ sender: Any) {
        if let email = emailText.text,let password = passText.text{
            if isValidEmail(string: email){
                emailText.layer.borderColor = colors.brownColor.cgColor
                if isValidPassword(string: password){
                    passText.layer.borderColor = colors.brownColor.cgColor
                    Auth.auth().createUser(withEmail: email, password: password){
                        (result,error)in
                        if let _ = result, error == nil{
                            
                            self.navigationController?.pushViewController(HomeViewController(), animated: true)
                        }else{
                            self.alert.viewSimpleAlert(view: self,title:"Error",message:"No se ha podido registrar el usuario")
                            self.putColors(isTrue: false)
                        }
                    }
                }
                else{
                     self.alert.viewSimpleAlert(view: self,title:"Error",message:"Contraseña no válida. Introduzca al menos 6 caracteres.")
                     passText.layer.borderColor = colors.redColor.cgColor
                   
                }
            }
            else{
               self.alert.viewSimpleAlert(view: self,title:"Error",message:"E-mail no válido.")
                 emailText.layer.borderColor = colors.redColor.cgColor
            }
            
        }
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
      
       if let email = emailText.text,let password = passText.text{
           Auth.auth().signIn(withEmail: email, password: password){
               (result,error)in
            if let _ = result, error == nil{
                self.putColors(isTrue : true)
                   self.navigationController?.pushViewController(MainViewController(), animated: true)
               }else{
                self.alert.viewSimpleAlert(view: self,title:"Error",message:"El usuario no puede acceder. Revise sus credenciales")
                self.putColors(isTrue: false)
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
    func putColors(isTrue: Bool){
        if isTrue{
            self.emailText.layer.borderColor = self.colors.brownColor.cgColor
                       self.passText.layer.borderColor = self.colors.brownColor.cgColor
        }
        else{
            self.emailText.layer.borderColor = self.colors.redColor.cgColor
            self.passText.layer.borderColor = self.colors.redColor.cgColor
        }
        
    }
    
     
}

