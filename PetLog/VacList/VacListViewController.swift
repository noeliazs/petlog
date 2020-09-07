//
//  VacListViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 07/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class VacListViewController: UIViewController {
     @IBOutlet weak var tableView: UITableView!
    
    var petName: String = ""
    private var petVacArray: [PetVaccine] = []
    private let COLLECTIONVACCINES = "Vacunas"
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Lista de vacunas"
        tableView.register(UINib(nibName: "PetVacCell",bundle:nil), forCellReuseIdentifier: "ReusableCell")
        tableView.dataSource=self
        tableView.delegate=self
        tableView.rowHeight = 90
        //Si no tenemos un filtro recuperaremos todas las vacunas
        if petName == ""{
            AllVaccines()
        }
        else{
            filterPet()
        }
        
         
    }
               
    

    func AllVaccines(){
        if let user = user, let email = user.email{
          db.collection(COLLECTIONVACCINES).whereField("propietario", isEqualTo: email).getDocuments() { (querySnapshot, err) in
           if let err = err {
              print("Error extrayendo los documentos \(err)")
          } else {
              for document in querySnapshot!.documents {
                  let datos = document.data()
                  let propietario = datos["propietario"] as? String ?? "Propietario"
                  let nombre = datos["nombre"] as? String ?? "Nombre"
                  let fecha = datos["fecha"] as? String ?? "Fecha"
                  let vacuna = datos ["vacuna"] as? String ?? "Vacuna"
                  let veterinario = datos ["veterinario"] as? String ?? "Veterinario"
                  let vacunacion = PetVaccine(name: nombre,email: propietario,vaccine:vacuna,vet:veterinario,date:fecha)
                  self.petVacArray.append(vacunacion)
              }
                  self.tableView.reloadData()
          }
         }
       }
    }
        
    func filterPet(){
            if let user = user, let email = user.email{
                db.collection(COLLECTIONVACCINES).whereField("propietario", isEqualTo: email).whereField("nombre", isEqualTo: petName).getDocuments() { (querySnapshot, err) in
               if let err = err {
                  print("Error extrayendo los documentos \(err)")
              } else {
                  for document in querySnapshot!.documents {
                      let datos = document.data()
                      let propietario = datos["propietario"] as? String ?? "Propietario"
                      let nombre = datos["nombre"] as? String ?? "Nombre"
                      let fecha = datos["fecha"] as? String ?? "Fecha"
                      let vacuna = datos ["vacuna"] as? String ?? "Vacuna"
                      let veterinario = datos ["veterinario"] as? String ?? "Veterinario"
                      let vacunacion = PetVaccine(name: nombre,email: propietario,vaccine:vacuna,vet:veterinario,date:fecha)
                      self.petVacArray.append(vacunacion)
                  }
                      self.tableView.reloadData()
              }
            }
        }
    
    }
}


//MARK: - TableViewDataSource
extension VacListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petVacArray.count
      
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! PetVacCell
        
        
        let fecha = petVacArray[indexPath.row].date
        let nombre =  petVacArray[indexPath.row].name
        let vacuna = petVacArray[indexPath.row].vaccine
        let veterinario = petVacArray[indexPath.row].vet
        
        cell.dateLabel.text = fecha
        cell.nameLabel.text = nombre
        cell.vacLabel.text = "Vacuna \(vacuna)"
        cell.vetLabel.text = veterinario
        cell.selectionStyle = .none

        
        return cell
    }

    
}
//MARK: - UITableViewDelegate

extension VacListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //ver si al clicar en cada animal podemos saber cuantas vacunas tiene
       
    }
}
 



