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

    @IBOutlet weak var closeSesionButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var providerLabel: UILabel!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Perfil de Usuario"
        
         let user = Auth.auth().currentUser
       
         if let user = user{
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = "mj"
            changeRequest.commitChanges { (error) in
              print(user.displayName)
            }

            let email = user.email
            emailLabel.text = email
            providerLabel.text = "Bienvenid@ \(user.displayName ?? "usuario")"
            
        }
        
    
    }
    
    @IBAction func closeSesionAction(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            navigationController?.popViewController(animated: true)
        }catch{
            //error
        }
    }
    
    /*
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    */

}
