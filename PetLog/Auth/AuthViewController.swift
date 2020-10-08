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
    
    @IBOutlet weak var SwitchRemember: UISwitch!
    private let alert=Alert()
    private let colors=Colors()
    private var remember: Bool = false
    private var keyPassword : String =  "keyPassword"
    private var keyEmail : String = "keyEmail"
    private let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Autenticación"
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AuthViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.navigationItem.setHidesBackButton(true, animated: false)
        textFieldsConfigure()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        guard let email = defaults.string(forKey: keyEmail) else {
            return
        }
        emailText.text = email
        
        do {
            let passwordItem = KeychainPasswordItem(
                service: KeychainConfiguration.serviceName,
                account: email,
                accessGroup: KeychainConfiguration.accessGroup)
            let password = try passwordItem.readPassword()
            passText.text = password
        } catch {
            fatalError("Error reading password from keychain - \(error)")
        }
        
        
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
                            self.putColors(isTrue : true)
                            if self.remember {
                                self.saveDefaults(email: email, password: password)
                            }
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
                    if self.remember {
                        self.saveDefaults(email: email, password: password)
                    }
                    self.navigationController?.pushViewController(MainViewController(), animated: true)
                }else{
                    self.alert.viewSimpleAlert(view: self,title:"Error",message:"El usuario no puede acceder. Revise sus credenciales")
                    self.putColors(isTrue: false)
                }
            }
        }
    }
    
    @IBAction func resetPassButtonAction(_ sender: Any) {
        
        if let email = emailText.text{
            if isValidEmail(string: email){
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    print(email)
                    self.alert.viewSimpleAlert(view: self,title:"Petición enviada",message:"Revisa la bandeja de entrada de tu correo (mira también en spam).")
                    self.emailText.layer.borderColor = self.colors.brownColor.cgColor
                }
            }else{
                self.alert.viewSimpleAlert(view: self,title:"Error",message:"Escribe un correo válido.")
                self.emailText.layer.borderColor = self.colors.redColor.cgColor
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
    
    
    func saveDefaults(email: String, password:String){
        defaults.set(email, forKey: keyEmail)
        do {
            let passwordItem = KeychainPasswordItem(
                service: KeychainConfiguration.serviceName,
                account: email,
                accessGroup: KeychainConfiguration.accessGroup)
            try passwordItem.savePassword(password)
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
    }
    
    @IBAction func switchOn(_ sender: Any) {
        if ((sender as AnyObject).isOn == true) {
            print("encendido")
            remember = true
        }
        else {
            print("apagado")
            remember = false
        }
    }
    
    
}


