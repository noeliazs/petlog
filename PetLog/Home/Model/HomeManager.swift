//
//  HomeManager.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 02/10/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class HomeManager{
    var homeViewController: HomeViewController?
    
    func putController(homeViewController: HomeViewController) {
        self.homeViewController = homeViewController
    }
    
    func changeName(user: User, name: String){
        let changeRequest = user.createProfileChangeRequest()
        changeRequest.displayName = name
        changeRequest.commitChanges { (error) in
            print(user.displayName!)
        }
    }
    
    
    func changePassword(user: User, password: String){
        if isValidPassword(string: password){
            user.updatePassword(to: password) { (error) in
                print(password)
            }
        }else{
            homeViewController?.viewAlertPassword()
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
