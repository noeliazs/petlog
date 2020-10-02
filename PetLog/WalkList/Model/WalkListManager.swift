//
//  WalkListManager.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 02/10/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class WalkListManager{
    var walkListViewController: WalkListViewController?
    private let db = Firestore.firestore()
    let COLECTIONWALKS = "Paseos"
  
    func putController(walkListViewController: WalkListViewController) {
        self.walkListViewController = walkListViewController
    }
    
    func loadWalks(id: String){
        db.collection(COLECTIONWALKS).whereField("id", isEqualTo: id).getDocuments() { (querySnapshot, err) in
             if let err = err {
                print("Error extrayendo los documentos \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let datos = document.data()
                    let nombre = datos["nombre"] as? String ?? "Nombre"
                    let id = datos["id"] as? String ?? "ID"
                    let distancia = datos["distancia"] as? Double ?? 0.0
                    let lugar = datos ["lugar"] as? String ?? "Lugar"
                    let fecha = datos ["fecha"] as? String ?? "Fecha"
                    let hora = datos["hora"] as? String ?? "Hora"
                    let paseo = PetWalk(name: nombre,id: id, place: lugar, distance: distancia, date: fecha, hour: hora)
                    self.walkListViewController?.petWalksArray.append(paseo)
                }
                self.walkListViewController?.reloadTable()
            }
        }
    }
    
    
}
