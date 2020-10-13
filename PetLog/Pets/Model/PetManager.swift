//
//  PetManager.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 17/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class PetManager {

    var petArray = [Pet]()
    var petsArray = [Pet]()
    var petID: String = ""
    let COLECTIONANIMALS = "Animales"
    private let db = Firestore.firestore()

    var delegate: PetFileDelegate?
    
    func loadPet(){
        print(petID)
        //inicializamos el array para que no haya problemas
        petArray = []
        db.collection(COLECTIONANIMALS).whereField("id", isEqualTo: petID)
        .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error extrayendo los documentos \(err)")
            } else {
                for document in querySnapshot!.documents {
                  let datos = document.data()
                  let id = datos["id"] as? String ?? "ID"
                  let nombre = datos["nombre"] as? String ?? "Nombre"
                  let especie = datos["especie"] as? String ?? "Especie"
                  let raza = datos ["raza"] as? String ?? "Raza"
                  let nacimiento = datos["nacimiento"] as? Int ?? 0000
                  let medicacion = datos ["medicacion"] as? String ?? "Medicación"
                  let peso = datos ["peso"] as? Double ?? 0.0
                  let alimentacion = datos["alimentacion"] as? String ?? "Alimentacion"
                  let propietario = datos["propietario"] as? String ?? "Propietario"
                  let mascota = Pet(id: id,name: nombre, specie: especie, race: raza, year: nacimiento, weight: peso, med: medicacion, food: alimentacion,owner:propietario)
                    self.petArray.append(mascota)
                }
                self.delegate?.updatePets(self, pets: self.petArray)
            }
        }
        
    }
    func loadPets(){
        let user = Auth.auth().currentUser
        let email = user!.email!
        db.collection(COLECTIONANIMALS).whereField("propietario", isEqualTo: email)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error extrayendo los documentos \(err)")
                } else {
                    for document in querySnapshot!.documents {
                      let datos = document.data()
                      let id = datos["id"] as? String ?? "ID"
                      let nombre = datos["nombre"] as? String ?? "Nombre"
                      let especie = datos["especie"] as? String ?? "Especie"
                      let raza = datos ["raza"] as? String ?? "Raza"
                      let nacimiento = datos["nacimiento"] as? Int ?? 0000
                      let medicacion = datos ["medicacion"] as? String ?? "Medicación"
                      let peso = datos ["peso"] as? Double ?? 0.0
                      let alimentacion = datos["alimentacion"] as? String ?? "Alimentacion"
                      let propietario = datos["propietario"] as? String ?? "Propietario"
                      let mascota = Pet(id: id,name: nombre, specie: especie, race: raza, year: nacimiento, weight: peso, med: medicacion, food: alimentacion,owner:propietario)
                      self.petsArray.append(mascota)
                    }
                  self.delegate?.updatePets(self, pets: self.petsArray)
                }
        }
    }
    
    

}
