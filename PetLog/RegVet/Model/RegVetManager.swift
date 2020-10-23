//
//  RegVetManager.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 03/10/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class RegVetManager{
    private var regVetViewController: RegVetViewController?
    private let db = Firestore.firestore()
    private let strings = Strings()
  
    func putController(regVetViewController: RegVetViewController) {
        self.regVetViewController = regVetViewController
    }
    
    func saveVac(visit: PetVetVisit){
        if visit.reason != "" && visit.vet != "" && visit.date != ""{
            db.collection(strings.COLLECTIONVETS).document(visit.name+"-"+visit.vet+"-"+visit.date).setData([
                        "propietario": visit.email,
                        "nombre": visit.name,
                        "razon": visit.reason,
                        "veterinario": visit.vet,
                        "fecha": visit.date
                       ])
            regVetViewController?.alertGood()
        }else{
            regVetViewController?.alertBad()
        }
    }
}
