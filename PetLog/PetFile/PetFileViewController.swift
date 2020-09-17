//
//  PetFileViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 03/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class PetFileViewController: UIViewController{
    
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
    
    var petManager = PetManager()
    var arrayPet=[Pet]()
    var petID: String = ""
    let COLECTIONANIMALS = "Animales"
    private let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ficha"
        petManager.delegate = self
        petManager.petID = petID
        petManager.loadPet()
        //Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(completeLabels), userInfo: nil, repeats: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Editar", style: .done, target: self, action: #selector(edit))
    }
    
    @objc func edit(){
        print("editar")
        let updateAnimalViewController = UpdateAnimalViewController()
        navigationController?.pushViewController(updateAnimalViewController, animated: true)
        updateAnimalViewController.id = petID
    }
    
    
    
    func completeLabels(){
        let mascota = arrayPet[0]
        nameLabel.text = "Nombre: \(mascota.name)"
        specieLabel.text = "Especie: \(mascota.specie)"
        raceLabel.text = "Raza: \(mascota.race)"
        yearLabel.text = "Año de nacimiento:  \(String(mascota.year))"
        medLabel.text = "Medicación especial: \(mascota.med)"
        foodLabel.text = "Alimentación especial: \(mascota.food)"
        weightLabel.text = "Peso:  \(String(mascota.weight)) Kg"
        let image : UIImage = UIImage(named: mascota.specie)!
        specieImage.image = image
        imagePet.image = image
    }
    
    

    @IBAction func walkButtonAction(_ sender: UIButton) {
        print("Paseo")
        let mascota = arrayPet[0]
        let regWalkViewController = RegWalkViewController()
        navigationController?.pushViewController(regWalkViewController, animated: true)
        regWalkViewController.petID = mascota.id
        regWalkViewController.petName = mascota.name
        
    }
    
    @IBAction func vacButtonAction(_ sender: Any) {
        print("vacuna")
        let mascota = arrayPet[0]
        let regVacViewController = RegVacViewController()
        navigationController?.pushViewController(regVacViewController, animated: true)
        regVacViewController.petName = mascota.name
    }
    
    @IBAction func vetButtonAction(_ sender: Any) {
        print("veterinario")
        let mascota = arrayPet[0]
        let regVetViewController = RegVetViewController()
        navigationController?.pushViewController(regVetViewController, animated: true)
        regVetViewController.petName = mascota.name
    }
    
    func checkWalkButton(){
        let mascota = arrayPet[0]
        let specie = mascota.specie
        if specie != "Canina"  {
            walkButton.isEnabled = false
        }
    }
}


//MARK: - PetFileDelegate
extension PetFileViewController:PetFileDelegate{

    func updatePets(_ petManager: PetManager, pets: [Pet]){
        DispatchQueue.main.async{
            self.arrayPet =  pets
            self.completeLabels()
            self.checkWalkButton()
        }
       
    }
    
    func didFailWithError(error: Error) {
         print(error)
     }
}
