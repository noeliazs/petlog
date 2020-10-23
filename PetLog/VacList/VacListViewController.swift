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
    @IBOutlet weak var printButton: UIButton!
    @IBOutlet weak var HomeButton: UIButton!
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    private let fonts = Fonts()
    private let alert = Alert()
    private var vacListManager = VacListManager()
    var petName: String = ""
    var petVacArray: [PetVaccine] = []
    private var primeraVez = true
    private var totalVacs:Int = 0
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lista de vacunas"
        tableView.register(UINib(nibName: "PetVacCell",bundle:nil), forCellReuseIdentifier: "ReusableCell")
        tableView.dataSource=self
        tableView.delegate=self
        tableView.rowHeight = 100
        vacListManager.putController(vacListViewController: self)
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
            vacListManager.loadVacs(email: email)
        }
    }
        
    func filterPet(){
        if let user = user, let email = user.email{
            vacListManager.loadVacs(email: email,name: petName)
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
         let vacListViewController = VacListViewController()
        navigationController?.pushViewController(vacListViewController, animated: false)
        vacListViewController.petName = petName
    }
    
    @IBAction func printButtonAction(_ sender: UIButton) {
        if (petName != ""){
            let pdfFilePath = self.tableView.exportAsPdfFromTable()
            print(pdfFilePath)
            alert.viewSimpleAlert(view: self,title:"Aviso",message:"Pdf disponible en: \(pdfFilePath)")
        }
        else{
             alert.viewSimpleAlert(view: self,title:"Aviso",message:"Función de imprimir solo disponible para una mascota. Por favor filtre antes.")
        }
              
    }
    
    @IBAction func cleanFilterButtonAction(_ sender: UIButton){
        let vacListViewController = VacListViewController()
         navigationController?.pushViewController(vacListViewController, animated: true)
        vacListViewController.petName =
         ""
    }
    
    @IBAction func HomeButtonAction(_ sender: UIButton){
        navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    func reloadTable(){
        tableView.reloadData()
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
        
        //al hacer click en la celda de nuestra mascota ya filtrados los resultados nos dice cuantas vacunas tiene
        if petName != ""{
            if primeraVez{
                for _ in petVacArray{
                    totalVacs+=1
                    primeraVez = false
                }
           }
            alert.viewSimpleAlert(view: self,title:"Aviso",message:"\(petName) tiene en total \(totalVacs) vacunas")
       }
       else{
             alert.viewSimpleAlert(view: self,title:"Aviso",message:"Filtre por el nombre de su mascota para conocer una funcionalidad extra")
        }
        
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        let vacuna = petVacArray[indexPath.row].vaccine
        return CGFloat(50) + vacuna.heightWithConstrainedWidth(width: tableView.frame.width, font: fonts.cellsTablesFont) 
    }
}






