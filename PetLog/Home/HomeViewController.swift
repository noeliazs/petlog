//
//  HomeViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 24/08/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth


class HomeViewController: UIViewController {

    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    //recupera el usuario que está registrado
    private let user = Auth.auth().currentUser
    private let alert = Alert()
    private let colors = Colors()
    private let homeManager = HomeManager()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Perfil de Usuario"
        nameTextField.delegate = self
        passTextField.delegate = self
        textFieldsConfigure()
        homeManager.putController(homeViewController: self)
        self.navigationItem.setHidesBackButton(true, animated: false)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HomeViewController.dismissKeyboard))
               view.addGestureRecognizer(tap)
      
         
        if let user = user{
            let email = user.email
            emailLabel.text = "Correo: \(email ?? "correo")"
            welcomeLabel.text = "Bienvenid@ \(user.displayName ?? "usuario")"
        }
    
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveChangesButtonAction(_ sender: Any) {
    
        //comprobar si los tres estan vacios
        if nameTextField.text?.count==0 && passTextField.text?.count==0 {
            alert.viewSimpleAlert(view: self,title:"Error",message:"No se ha introducido ningún campo para modificar")
        }else{
            if let user = user, let name = nameTextField.text{
                 if name != ""{
                    homeManager.changeName(user:user, name: name)
                 }
             }
             
             
             if let user = user, let password = passTextField.text{
                if password != ""{
                    homeManager.changePassword(user: user, password:password)
                }
             }
             
            
             alert.showAlert(viewController: self)
             
            Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(reload), userInfo: nil, repeats: false)
        }
    }
    func textFieldsConfigure(){
        nameTextField.layer.cornerRadius=10
        nameTextField.layer.masksToBounds=true
        nameTextField.layer.borderWidth = 2
        nameTextField.layer.borderColor = colors.brownColor.cgColor
        passTextField.layer.cornerRadius=10
        passTextField.layer.masksToBounds=true
        passTextField.layer.borderWidth = 2
        passTextField.layer.borderColor = colors.brownColor.cgColor
        
        passTextField.attributedPlaceholder = NSAttributedString(string: "Contraseña",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Nombre",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
    }
    
    
    @objc func reload(){
        alert.stopAlert(viewController: self)
        viewDidLoad()
        nameTextField.text = ""
        passTextField.text = ""
        
    }
    
    
    func viewAlertPassword(){
         alert.viewSimpleAlert(view: self,title:"Error",message:"Contraseña no válida. No se cambiará ese campo")
    }
    
    
  
    @IBAction func goMainButton(_ sender: Any) {
         navigationController?.pushViewController(MainViewController(), animated: true)
    }
}

//MARK: TextFieldDelegate
extension HomeViewController: UITextFieldDelegate{
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
              self.view.endEditing(true)
              return false
        }
    
}


