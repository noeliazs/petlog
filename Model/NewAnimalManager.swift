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
    var newAnimalViewController: NewAnimalViewController?
    private let db = Firestore.firestore()
    let COLECTIONANIMALS = "Animales"
    
    func putController(newAnimalViewController: NewAnimalViewController) {
        self.newAnimalViewController = newAnimalViewController
    }
    
    func saveAnimal(pet : Pet){
        if pet.specie != "" && pet.name != "" && pet.race != "" && pet.year != 0 && pet.med != "" && pet.weight != 0.0 && pet.food != ""{
            if checkYear(year: pet.year){
                print("guardando")
                print(pet.owner)
                db.collection(COLECTIONANIMALS).document(pet.id).setData([
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
}
    
       
