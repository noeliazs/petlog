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
        print("nuevo animal")
    }
    
    @IBAction func petButtonAction(_ sender: Any){
        print("Mis mascotas")
    }
    
    @IBAction func vetButtonAction(_ sender: Any){
        print("Veterinario")
    }
    
    @IBAction func vacButtonAction(_ sender: Any){
        print("Vacunas")
    }
    
    @IBAction func newsButtonAction(_ sender: Any){
        print("Noticias")
        
    }
    
    @IBAction func profileButtonAction(_ sender: Any){
        print("Mi perfil")
         navigationController?.pushViewController(HomeViewController(), animated: true)
    }
    
    @IBAction func closeSesionButtonAction(_ sender: Any){
           print("Cerrar sesion")
            navigationController?.popViewController(animated: true)
       }
    
}
