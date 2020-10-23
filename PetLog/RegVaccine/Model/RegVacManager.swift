//
//  RegVacManager.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 03/10/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class RegVacManager{
    private var regVacViewController: RegVacViewController?
    private let db = Firestore.firestore()
    private let strings = Strings()
  
    func putController(regVacViewController: RegVacViewController) {
        self.regVacViewController = regVacViewController
    }
    
    func saveVac(vac: PetVaccine){
        if vac.vaccine != "" && vac.vet != "" && vac.date != ""{
            db.collection(strings.COLLECTIONVACCINES).document(vac.name+"-"+vac.vaccine+"-"+vac.date).setData([
                "propietario": vac.email,
                "nombre": vac.name,
                "vacuna": vac.vaccine,
                "veterinario": vac.vet,
                "fecha": vac.date
                ])
            regVacViewController?.alertGood()
        }else{
            regVacViewController?.alertBad()
        }
    }
}
