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
   
    private let authManager =  AuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Autenticación"
        textFieldsConfigure()
        authManager.putController(authViewController: self)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AuthViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @objc func dismissKeyboard() {
            view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        authManager.retrieveCredentials()
    }
    
    func loadEmail(email: String){
        emailText.text = email
    }
    
    func loadPass(password: String){
        passText.text = password
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
    
    
    @IBAction func signupButtonAction(_ sender: Any) {
        if let email = emailText.text,let password = passText.text{
            authManager.register(email: email, password: password)
        }
    }
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        if let email = emailText.text,let password = passText.text{
            authManager.login(email: email, password:password)
        }
    }
    
    @IBAction func resetPassButtonAction(_ sender: Any) {
        
        if let email = emailText.text{
            authManager.resetPassword(email:email)
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
    
    
    
    
    @IBAction func switchOn(_ sender: Any) {
        if ((sender as AnyObject).isOn == true) {
            print("encendido")
            authManager.changeRemember(encendido: true)
        }
        else {
            print("apagado")
            authManager.changeRemember(encendido: true)
        }
    }
    
    func changeView(vista: String){
        if vista == "HOME"{
            navigationController?.pushViewController(HomeViewController(), animated: true)
        }
        if vista == "MAIN"{
            navigationController?.pushViewController(MainViewController(), animated: true)
        }
    }
    func putColorEmail(isTrue: Bool){
        if isTrue{
            emailText.layer.borderColor = colors.brownColor.cgColor
        }
        else{
             self.emailText.layer.borderColor = self.colors.redColor.cgColor
        }
    }
    
    func putColorPass(isTrue: Bool){
           if isTrue{
               passText.layer.borderColor = colors.brownColor.cgColor
           }
           else{
                passText.layer.borderColor = self.colors.redColor.cgColor
           }
       }
    
    func showAlertRegisterBad(){
         alert.viewSimpleAlert(view: self,title:"Error",message:"No se ha podido registrar el usuario")
    }
    func showAlertBadEmail(){
        alert.viewSimpleAlert(view: self,title:"Error",message:"E-mail no válido.")
    }
    
    func showAlertBadPass(){
        alert.viewSimpleAlert(view: self,title:"Error",message:"Contraseña no válida. Introduzca al menos 6 caracteres.")
    }
    
    func showAlertLoginBad(){
        alert.viewSimpleAlert(view: self,title:"Error",message:"El usuario no puede acceder. Revise sus credenciales")
    }
    
    func showAlertChangePassGood(){
        alert.viewSimpleAlert(view: self,title:"Petición enviada",message:"Revisa la bandeja de entrada de tu correo (mira también en spam).")
    }
    
    func showAlertChangePassBad(){
        alert.viewSimpleAlert(view: self,title:"Error",message:"Escribe un correo válido.")
    }
}


