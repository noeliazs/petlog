//
//  VetListManager.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 03/10/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class VetListManager{
    var vetListViewController: VetListViewController?
    private let db = Firestore.firestore()
    private let COLLECTIONVETS = "Veterinario"
  
    func putController(vetListViewController: VetListViewController) {
        self.vetListViewController = vetListViewController
    }
    
    func loadVisits(email: String,name: String){
        db.collection(COLLECTIONVETS).whereField("propietario", isEqualTo: email).whereField("nombre", isEqualTo: name).getDocuments() { (querySnapshot, err) in
           if let err = err {
              print("Error extrayendo los documentos \(err)")
          } else {
              for document in querySnapshot!.documents {
                  let datos = document.data()
                  let propietario = datos["propietario"] as? String ?? "Propietario"
                  let nombre = datos["nombre"] as? String ?? "Nombre"
                  let fecha = datos["fecha"] as? String ?? "Fecha"
                  let razon = datos ["razon"] as? String ?? "Razon"
                  let veterinario = datos ["veterinario"] as? String ?? "Veterinario"
                  let visit = PetVetVisit(name: nombre, email: propietario, reason: razon, vet: veterinario, date: fecha)
                 self.vetListViewController?.petVetArray.append(visit)
              }
                 self.vetListViewController?.reloadTable()
          }
        }
    }
    
    func loadVisits(email: String){
        db.collection(COLLECTIONVETS).whereField("propietario", isEqualTo: email).getDocuments() { (querySnapshot, err) in
          if let err = err {
             print("Error extrayendo los documentos \(err)")
         } else {
             for document in querySnapshot!.documents {
                 let datos = document.data()
                 let propietario = datos["propietario"] as? String ?? "Propietario"
                 let nombre = datos["nombre"] as? String ?? "Nombre"
                 let fecha = datos["fecha"] as? String ?? "Fecha"
                 let razon = datos ["razon"] as? String ?? "Razon"
                 let veterinario = datos ["veterinario"] as? String ?? "Veterinario"
                 let visit = PetVetVisit(name: nombre, email: propietario, reason: razon, vet: veterinario, date: fecha)
                self.vetListViewController?.petVetArray.append(visit)
             }
            self.vetListViewController?.reloadTable()
         }
        }
    }
}
