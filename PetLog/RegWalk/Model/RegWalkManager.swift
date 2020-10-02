//
//  RegWalkManager.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 02/10/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class RegWalkManager{
    var regWalkViewController: RegWalkViewController?
    private let db = Firestore.firestore()
    private let COLLECTIONWALKS = "Paseos"
  
    func putController(regWalkViewController: RegWalkViewController) {
        self.regWalkViewController = regWalkViewController
    }

    func saveWalk(walk: PetWalk){
        if walk.distance != 0.0 && walk.place != "" && walk.date != "" && walk.hour != "" && walk.id != "" && walk.name != ""{
            print("guardando")
        db.collection(COLLECTIONWALKS).document(walk.name+"-"+walk.date+"-"+walk.hour).setData([
                "id": walk.id,
                "nombre": walk.name,
                "fecha": walk.date,
                "hora": walk.hour,
                "distancia": walk.distance,
                "lugar": walk.place
            ])
           regWalkViewController?.alertGood()
        }
        else{
            regWalkViewController?.alertBad()
        }
    }
}
