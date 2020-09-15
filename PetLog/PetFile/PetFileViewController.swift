//
//  PetFileViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 03/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit

class PetFileViewController: UIViewController {
    
    @IBOutlet weak var walkButton: UIButton!
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
        checkWalkButton()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Editar", style: .done, target: self, action: #selector(edit))
    }
    
    @objc func edit(){
        print("editar")
        let updateAnimalViewController = UpdateAnimalViewController()
        navigationController?.pushViewController(updateAnimalViewController, animated: true)
        updateAnimalViewController.id = myPet[0].id
    }

    @IBAction func walkButtonAction(_ sender: UIButton) {
        print("Paseo")
        let regWalkViewController = RegWalkViewController()
        navigationController?.pushViewController(regWalkViewController, animated: true)
        regWalkViewController.petID = myPet[0].id
        regWalkViewController.petName = myPet[0].name
        
    }
    
    @IBAction func vacButtonAction(_ sender: Any) {
        print("vacuna")
        let regVacViewController = RegVacViewController()
        navigationController?.pushViewController(regVacViewController, animated: true)
        regVacViewController.petName = myPet[0].name
    }
    
    @IBAction func vetButtonAction(_ sender: Any) {
        print("veterinario")
        let regVetViewController = RegVetViewController()
        navigationController?.pushViewController(regVetViewController, animated: true)
        regVetViewController.petName = myPet[0].name
    }
    
    func checkWalkButton(){
        let specie = myPet[0].specie
        if specie != "Canina"  {
            walkButton.isEnabled = false
        }
    }
}
