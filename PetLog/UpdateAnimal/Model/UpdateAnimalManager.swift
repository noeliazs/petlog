//
//  UpdateAnimalManager.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 02/10/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//


import UIKit
import FirebaseFirestore
import Firebase

class UpdateAnimalManager{
    var updateAnimalViewController: UpdateAnimalViewController?
    private let db = Firestore.firestore()
    private let COLECTIONANIMALS = "Animales"
  
    func putController(updateAnimalViewController: UpdateAnimalViewController) {
        self.updateAnimalViewController = updateAnimalViewController
    }
    
    func updateFood(id: String, food: String){
        if  food != ""{
            db.collection(COLECTIONANIMALS)
                .whereField("id", isEqualTo: id)
                .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error extrayendo los documentos \(err)")
                } else if querySnapshot!.documents.count != 1 {
                        print("No se encuentra la mascota")
                } else {
                    let document = querySnapshot!.documents.first
                    document?.reference.updateData([
                        "alimentacion": food])
                }
            }
                updateAnimalViewController?.alertFoodGood()
            }else{
                updateAnimalViewController?.alertBad()
            }
    }
    
    func updateMed(id: String,med: String){
        if  med != ""{
            db.collection(COLECTIONANIMALS)
                .whereField("id", isEqualTo: id)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error extrayendo los documentos \(err)")
                    } else if querySnapshot!.documents.count != 1 {
                        print("No se encuentra la mascota")
                    } else {
                        let document = querySnapshot!.documents.first
                        document?.reference.updateData([
                            "medicacion": med
                        ])
                    }
                }
                updateAnimalViewController?.alertMedGood()
        }else{
                updateAnimalViewController?.alertBad()
        }
    }
    
    
    func updateWeight(id: String, weight: Double){
        if  weight != 0.0{
            db.collection(COLECTIONANIMALS)
            .whereField("id", isEqualTo: id)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error extrayendo los documentos \(err)")
                } else if querySnapshot!.documents.count != 1 {
                    print("No se encuentra la mascota")
                } else {
                    let document = querySnapshot!.documents.first
                    document?.reference.updateData([
                        "peso": weight
                    ])
                }
            }
            updateAnimalViewController?.alertWeightGood()
        }else{
            updateAnimalViewController?.alertBad()
        }
    }


}
