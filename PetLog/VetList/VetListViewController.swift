//
//  VetListViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 09/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class VetListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let alert = Alert()
    var petName: String = ""
    private var petVetArray: [PetVetVisit] = []
    private let COLLECTIONVETS = "Veterinario"
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    var primeraVez = true
    private var totalVetsVisits:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Listado de visitas veterinarias"
        tableView.register(UINib(nibName: "PetVetCell",bundle:nil), forCellReuseIdentifier: "ReusableCell")
        tableView.dataSource=self
        tableView.delegate=self
        tableView.rowHeight = 90
        if petName == ""{
            AllVetsVisits()
        }
        else{
            filterPet()
        }
    }
    

      func AllVetsVisits(){
          if let user = user, let email = user.email{
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
                    self.petVetArray.append(visit)
                }
                    self.tableView.reloadData()
            }
           }
         }
         
      }
          
      func filterPet(){
              if let user = user, let email = user.email{
                  db.collection(COLLECTIONVETS).whereField("propietario", isEqualTo: email).whereField("nombre", isEqualTo: petName).getDocuments() { (querySnapshot, err) in
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
                        self.petVetArray.append(visit)
                    }
                        self.tableView.reloadData()
                }
              }
          }
          
      }
      
      @IBAction func filterButtonAction(_ sender: UIButton){
          let alertController = UIAlertController(title: "FILTRO", message: "Introduce el nombre de tu mascota", preferredStyle: UIAlertController.Style.alert)
          let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.default, handler: {
                 (action : UIAlertAction!) -> Void in })
          alertController.addTextField { (textField : UITextField!) -> Void in
                 textField.placeholder = "Nombre"
             }
          
          let saveAction = UIAlertAction(title: "Filtrar", style: UIAlertAction.Style.default, handler: { alert -> Void in
                 let firstTextField = alertController.textFields![0] as UITextField
              self.petName = firstTextField.text ?? ""
              self.changeView()
             })
          
             alertController.addAction(saveAction)
             alertController.addAction(cancelAction)
             
             self.present(alertController, animated: true, completion: nil)
    
      }
      
      @objc func changeView() {
           let vetListViewController = VetListViewController()
          navigationController?.pushViewController(vetListViewController, animated: false)
          vetListViewController.petName = petName
      }
    
    
    @IBAction func allActionButton(_ sender: UIButton) {
        let vetListViewController = VetListViewController()
         navigationController?.pushViewController(vetListViewController, animated: true)
        vetListViewController.petName = ""
    }
    

   
    @IBAction func printActionButton(_ sender: UIButton) {
        if (petName != ""){
                   let pdfFilePath = self.tableView.exportAsPdfFromTable()
                   print(pdfFilePath)
                   alert.viewSimpleAlert(view: self,title:"Aviso",message:"Pdf disponible en: \(pdfFilePath)")
               }
               else{
                    alert.viewSimpleAlert(view: self,title:"Aviso",message:"Función de imprimir solo disponible para una mascota. Por favor filtre antes.")
               }
    }
    @IBAction func homeActionButton(_ sender: UIButton) {
         navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
}

//MARK: - TableViewDataSource
extension VetListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petVetArray.count
      
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! PetVetCell
        
        
        let fecha = petVetArray[indexPath.row].date
        let nombre =  petVetArray[indexPath.row].name
        let razon = petVetArray[indexPath.row].reason
        let veterinario = petVetArray[indexPath.row].vet
        
        cell.dateLabel.text = fecha
        cell.nameLabel.text = nombre
        cell.reasonLabel.text = razon
        cell.vetLabel.text = veterinario
        cell.selectionStyle = .none

        
        return cell
    }

    
}
//MARK: - UITableViewDelegate

extension VetListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //al hacer click en la celda de nuestra mascota ya filtrados los resultados nos dice cuantas vacunas tiene
        if petName != ""{
            if primeraVez{
                for _ in petVetArray{
                    totalVetsVisits+=1
                    primeraVez = false
                }
           }
            alert.viewSimpleAlert(view: self,title:"Aviso",message:"\(petName) ha hecho en total \(totalVetsVisits) visitas al veterinario")
       }
       else{
             alert.viewSimpleAlert(view: self,title:"Aviso",message:"Filtre por el nombre de su mascota para conocer una funcionalidad extra")
        }
        
       
    }
}


 




