//
//  AuthManager.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 08/10/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import FirebaseAuth

class AuthManager{
    private var authViewController: AuthViewController?
    private let db = Firestore.firestore()
    private var strings = Strings()
    private var remember : Bool = false
    private var keyPassword : String =  "keyPassword"
    private var keyEmail : String = "keyEmail"
    private let defaults = UserDefaults.standard
    
    func putController(authViewController: AuthViewController) {
            self.authViewController = authViewController
    }
    
    func register(email: String, password: String){
        if isValidEmail(string: email){
            authViewController?.putColorEmail(isTrue: true)
            if isValidPassword(string: password){
                 authViewController?.putColorPass(isTrue: true)
                Auth.auth().createUser(withEmail: email, password: password){
                    (result,error)in
                    if let _ = result, error == nil{
                        self.authViewController?.putColors(isTrue : true)
                        if self.remember {
                            self.saveDefaults(email: email, password: password)
                        }
                        self.authViewController?.changeView(vista: "HOME")
                    }else{
                        self.authViewController?.showAlertRegisterBad()
                        self.authViewController?.putColors(isTrue: false)
                    }
                }
            }
            else{
                authViewController?.showAlertBadPass()
                authViewController?.putColorPass(isTrue: false)
                
            }
        }
        else{
            authViewController?.showAlertBadEmail()
            authViewController?.putColorEmail(isTrue: false)
        }
        
    }
    
    func login(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password){
            (result,error)in
            if let _ = result, error == nil{
                self.authViewController?.putColors(isTrue : true)
                if self.remember {
                    self.saveDefaults(email: email, password: password)
                }
                 self.authViewController?.changeView(vista: "MAIN")
            }else{
                self.authViewController?.showAlertLoginBad()
                self.authViewController?.putColors(isTrue: false)
            }
        }
    }
    
    func resetPassword(email: String){
        if isValidEmail(string: email){
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                print(email)
                self.authViewController?.showAlertChangePassGood()
                self.authViewController?.putColorEmail(isTrue: true)
            }
        }else{
            self.authViewController?.showAlertChangePassBad()
            self.authViewController?.putColorEmail(isTrue: false)
        }
    }
    
    
    
    func isValidEmail(string: String) -> Bool {
        let emailReg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailReg)
        return emailTest.evaluate(with: string)
    }
    
    func isValidPassword(string: String) -> Bool{
        if string.count<strings.NUMCHAR{
            return false
        }
        else{
            return true
        }
    }
    
    func changeRemember(encendido: Bool){
        remember = encendido
    }
   
    func getRemember()-> Bool{
        return remember
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
    
    func retrieveCredentials(){
        guard let email = defaults.string(forKey: keyEmail) else {
            return
        }
        authViewController?.loadEmail(email:email)
        
        do {
            let passwordItem = KeychainPasswordItem(
                service: KeychainConfiguration.serviceName,
                account: email,
                accessGroup: KeychainConfiguration.accessGroup)
            let password = try passwordItem.readPassword()
            authViewController?.loadPass(password:password)
        } catch {
            fatalError("Error reading password from keychain - \(error)")
        }
    }
    
    
    
    
}
