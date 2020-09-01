//
//  HomeViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 24/08/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    //recupera el usuario que está registrado
    let user = Auth.auth().currentUser
    let alert=Alert()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Perfil de Usuario"
        
        if let user = user{
            let email = user.email
            emailLabel.text = email
            welcomeLabel.text = "Bienvenid@ \(user.displayName ?? "usuario")"
        }
    
    }
    
    @IBAction func saveChangesButtonAction(_ sender: Any) {
    
        //comprobar si los tres estan vacios
        if nameTextField.text?.count==0 && passTextField.text?.count==0 && emailTextField.text?.count==0 {
            alert.viewSimpleAlert(view: self,title:"Error",message:"No se ha introducido ningún campo para modificar")
        }
        else{
            if let user = user, let name = nameTextField.text{
                 
                 if name != ""{
                     let changeRequest = user.createProfileChangeRequest()
                     changeRequest.displayName = name
                     changeRequest.commitChanges { (error) in
                         print(user.displayName)
                     }
                 }
                 
             
             }
             
             if let user = user , let email = emailTextField.text{
                if email != ""{
                    if isValidEmail(string: email){
                        user.updateEmail(to: email) { (error) in
                        print(user.email)
                        }
                    }
                    else{
                        alert.viewSimpleAlert(view: self,title:"Error",message:"E-mail no válido. No se cambiará ese campo")
                    }
                }
               
             }
             
             if let user = user, let password = passTextField.text{
                if password != ""{
                    if isValidPassword(string: password){
                        user.updatePassword(to: password) { (error) in
                            print(password)
                        }
                    }
                    else{
                        alert.viewSimpleAlert(view: self,title:"Error",message:"Contraseña no válida. No se cambiará ese campo")
                    }
                    
                }
                
             }
             
            
             alert.showAlert(viewController: self)
             
             let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(reload), userInfo: nil, repeats: false)
        }
    }
    
    @objc func reload()
    {
        alert.stopAlert(viewController: self)
        viewDidLoad()
        emailTextField.text = ""
        nameTextField.text = ""
        passTextField.text = ""
        
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



