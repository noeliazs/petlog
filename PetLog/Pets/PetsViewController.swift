//
//  PetsViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 03/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class PetsViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var petsArray: [Pet] = []
    private let db = Firestore.firestore()
    let COLECTIONANIMALS = "Animales"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Mis mascotas"
        let user = Auth.auth().currentUser
        let email = user!.email!
        tableView.register(UINib(nibName: "PetCell",bundle:nil), forCellReuseIdentifier: "ReusableCell")
        tableView.dataSource=self
        tableView.delegate=self
        tableView.rowHeight = 60
        
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
                            let mascota = Pet(id: id,name: nombre, specie: especie, race: raza, year: nacimiento, weight: peso, med: medicacion, food: alimentacion)
                            self.petsArray.append(mascota)
                          }
                        self.tableView.reloadData()
                      }
              }
        
    }


}


//MARK: - TableViewDataSource
extension PetsViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petsArray.count
      
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! PetCell
 
        let nombre = petsArray[indexPath.row].name
    
        cell.nameLabel.text = nombre
        cell.selectionStyle = .none
       
        return cell
    }

    
}
//MARK: - UITableViewDelegate

extension PetsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let petFileViewController = PetFileViewController()
        var array = [Pet]()
        let pet = petsArray[indexPath.row]
        array.append(pet)
        navigationController?.pushViewController(petFileViewController, animated: true)
            petFileViewController.myPet = array

       
    }
}
 

