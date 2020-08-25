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
            print("no se cambia nada")
            let alert = UIAlertController(title: "Error" , message: "No ha introducido ningún campo para modificar" , preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
            self.present(alert,animated: true, completion: nil)
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
                 user.updateEmail(to: email) { (error) in
                     print(user.email)
                 }
             }
             
             if let user = user, let password = passTextField.text{
                 user.updatePassword(to: password) { (error) in
                    print(password)
                 }
             }
             
            
             alert.showAlert(viewController: self)
             
             let timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(changeView), userInfo: nil, repeats: false)
        }
        

       
       
    }
    
    @objc func changeView()
    {
        alert.stopAlert(viewController: self)
        navigationController?.pushViewController(HomeViewController(),animated: true)
    }
    
    
   
    

}

