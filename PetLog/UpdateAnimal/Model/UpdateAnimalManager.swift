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
import FirebaseStorage

class UpdateAnimalManager{
    var updateAnimalViewController: UpdateAnimalViewController?
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    private let strings = Strings()
  
    func putController(updateAnimalViewController: UpdateAnimalViewController) {
        self.updateAnimalViewController = updateAnimalViewController
    }
    
    func updateFood(id: String, food: String){
        if  food != ""{
            db.collection(strings.COLLECTIONANIMALS)
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
            db.collection(strings.COLLECTIONANIMALS)
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
            db.collection(strings.COLLECTIONANIMALS)
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
    
    func savePhoto(photo: PetPhoto){
        db.collection(strings.COLLECTIONPHOTOS).document(photo.id).setData([
                       "id": photo.id,
                       "imagen": photo.image
        ])
        updateAnimalViewController?.viewAlertSavePhoto()
    }
       
    func savePhotoStorage(imageData: Data,id: String){
        let title = "images/\(id).png"
          self.updateAnimalViewController?.viewIndicator()
       storage.child(title).putData(imageData, metadata: nil, completion: {_ ,error in
            guard error == nil else{
                print("fallo en la subida")
                return
            }
        self.storage.child(title).downloadURL(completion: {url,error in
          
                guard let url = url, error == nil else{
                    return
                }
                let urlString = url.absoluteString
                self.updateAnimalViewController?.viewIndicator()
                let photo = PetPhoto(id: id, image: urlString)
                self.savePhoto(photo: photo)
            })
        })
    }


}
