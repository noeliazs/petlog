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
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    private let fonts = Fonts()
    private let alert = Alert()
    private var vetListManager = VetListManager()
    var petName: String = ""
    var petVetArray: [PetVetVisit] = []
    private var primeraVez = true
    private var totalVetsVisits:Int = 0
  
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Listado de visitas veterinarias"
        tableView.register(UINib(nibName: "PetVetCell",bundle:nil), forCellReuseIdentifier: "ReusableCell")
        tableView.dataSource=self
        tableView.delegate=self
        tableView.rowHeight = 120
        vetListManager.putController(vetListViewController: self)
        if petName == ""{
            AllVetsVisits()
        }
        else{
            filterPet()
        }
    }

    func AllVetsVisits(){
          if let user = user, let email = user.email{
            vetListManager.loadVisits(email: email)
         }
         
    }
          
    func filterPet(){
          if let user = user, let email = user.email{
              vetListManager.loadVisits(email: email, name: petName)
          }
          
    }
      
    @IBAction func filterButtonAction(_ sender: UIButton){
          let alertController = UIAlertController(title: "FILTRO", message: "Introduce el nombre de tu mascota", preferredStyle: UIAlertController.Style.alert)
          let cancelAction = UIAlertAction(title: "Cancelar", style: UIAlertAction.Style.default, handler: {
                 (action : UIAlertAction!) -> Void in })
          alertController.addTextField { (textField : UITextField!) -> Void in
                 textField.placeholder = "Nombre, comience con mayúsculas"
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
    
    func reloadTable(){
        tableView.reloadData()
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let razon = petVetArray[indexPath.row].reason
        return CGFloat(60) + razon.heightWithConstrainedWidth(width: tableView.frame.width, font: fonts.cellsTablesFont)
    }

    
}
//MARK: - UITableViewDelegate

extension VetListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //al hacer click en la celda de nuestra mascota ya filtrados los resultados nos dice cuantas visitas al veterinario a realizado
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


 




