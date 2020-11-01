//
//  NewAnimalManager.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 02/10/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//


import UIKit
import FirebaseFirestore
import Firebase

class NewAnimalManager{
    
    private var newAnimalViewController: NewAnimalViewController?
    private let db = Firestore.firestore()
    private var strings = Strings()
    var species: [String] = []
    
    func putController(newAnimalViewController: NewAnimalViewController) {
        self.newAnimalViewController = newAnimalViewController
    }
    
    func saveAnimal(pet : Pet){
        if pet.specie != "" && pet.name != "" && pet.race != "" && pet.year != 0 && pet.med != "" && pet.weight != 0.0 && pet.food != ""{
            if checkYear(year: pet.year){
                print("guardando")
                print(pet.owner)
                db.collection(strings.COLLECTIONANIMALS).document(pet.id).setData([
                    "id": pet.id,
                           "propietario": pet.owner,
                           "nombre": pet.name,
                           "especie": pet.specie,
                           "raza": pet.race,
                           "nacimiento": pet.year,
                           "medicacion": pet.med,
                           "peso": pet.weight,
                           "alimentacion": pet.food
                       ])
                newAnimalViewController?.viewAlertSave()
                }else{
                    newAnimalViewController?.viewAlertBadYear()
                }
        }else{
               newAnimalViewController?.viewAlertBad()
        }
              
               
    }
    
    // Controla si se introduce un año válido
       func checkYear(year : Int)->Bool{
           let date = Date()
           let calendar = Calendar.current
           let components = calendar.dateComponents([.year], from: date)
           let now = components.year
           
           if(year > now!){
               return false
           }
           return true
       }
    
    func loadSpecies(){
        var specie: String = ""
        var n = 0
        db.collection(strings.COLLECTIONSPECIES).order(by: "0")
        .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error extrayendo los documentos \(err)")
            } else {
                for document in querySnapshot!.documents {
                  let datos = document.data()
                    for _ in datos{
                        specie = datos["\(n)"] as? String ?? "Animal"
                        self.species.append(specie)
                        n+=1
            
                    }
                  
                }
            }
        }
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(reload), userInfo: nil, repeats: false)
        
    }
    
    @objc func reload(){
        newAnimalViewController?.reloadPicker()
    }
   
}
    
       

