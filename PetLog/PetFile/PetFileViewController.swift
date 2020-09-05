//
//  PetFileViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 03/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit

class PetFileViewController: UIViewController {
    
    @IBOutlet weak var specieImage: UIImageView!
    @IBOutlet weak var imagePet: UIImageView!
     @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var medLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    var id: String = ""
    var myPet: [Pet] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ficha"
        nameLabel.text = "Nombre: \(myPet[0].name)"
        specieLabel.text = "Especie: \(myPet[0].specie)"
        raceLabel.text = "Raza: \(myPet[0].race)"
        yearLabel.text = "Año de nacimiento:  \(String(myPet[0].year))"
        medLabel.text = "Medicación especial: \(myPet[0].med)"
        foodLabel.text = "Alimentación especial: \(myPet[0].food)"
        weightLabel.text = "Peso:  \(String(myPet[0].weight)) Kg"
        let image : UIImage = UIImage(named: myPet[0].specie)!
        specieImage.image = image
        imagePet.image = image
        
    }

    @IBAction func walkButtonAction(_ sender: UIButton) {
        print("Paseo")
        navigationController?.pushViewController(RegWalkViewController(), animated: true)
    }
    
    @IBAction func vacButtonAction(_ sender: Any) {
        print("vacuna")
        //navigationController?.pushViewController(RegVacViewController(), animated: true)
    }
    
    @IBAction func vetButtonAction(_ sender: Any) {
        print("veterinario")
        //navigationController?.pushViewController(RegVetViewController(), animated: true)
    }
}
