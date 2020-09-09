//
//  MainViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 25/08/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import Foundation
import Firebase


class MainViewController: UIViewController {
     
     @IBOutlet weak var newButton: UIButton!
     @IBOutlet weak var petButton: UIButton!
     @IBOutlet weak var vetButton: UIButton!
     @IBOutlet weak var vacButton: UIButton!
     @IBOutlet weak var newsButton: UIButton!
     @IBOutlet weak var profileButton: UIButton!
    
     override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Inicio"
     }
    
    @IBAction func newButtonAction(_ sender: Any){
        navigationController?.pushViewController(NewAnimalViewController(), animated: true)
        print("nuevo animal")
    }
    
    @IBAction func petButtonAction(_ sender: Any){
        navigationController?.pushViewController(PetsViewController(), animated: true)
        print("Mis mascotas")
    }
    
    @IBAction func vetButtonAction(_ sender: Any){
        print("Veterinario")
         navigationController?.pushViewController(VetListViewController(), animated: true)
    }
    
    @IBAction func vacButtonAction(_ sender: Any){
        print("Vacunas")
         navigationController?.pushViewController(VacListViewController(), animated: true)
    }
    
    @IBAction func newsButtonAction(_ sender: Any){
        print("Noticias")
        navigationController?.pushViewController(NewsViewController(), animated: true)
        
    }
    
    @IBAction func profileButtonAction(_ sender: Any){
        print("Mi perfil")
         navigationController?.pushViewController(HomeViewController(), animated: true)
    }
    
    @IBAction func closeSesionButtonAction(_ sender: Any){
        print("Cerrar sesion")
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
            print("cerrando sesion")
            } catch let err {
                print(err)
        }
            navigationController?.popViewController(animated: true)
       }
    
}
