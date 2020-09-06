//
//  WalkListViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 05/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class WalkListViewController: UIViewController {
    
    var petWalksArray: [PetWalk] = []
    let COLECTIONWALKS = "Paseos"
    var totalDistance: Double = 0.0
    var primeraVez = true
     
    private let db = Firestore.firestore()
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var id: String = ""
    var nombre: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Lista de paseos de \(nombre)"
        
        tableView.register(UINib(nibName: "PetWalkCell",bundle:nil), forCellReuseIdentifier: "ReusableCell")
        tableView.dataSource=self
        tableView.delegate=self
        tableView.rowHeight = 60
         db.collection(COLECTIONWALKS).whereField("id", isEqualTo: id).getDocuments() { (querySnapshot, err) in
                 if let err = err {
                    print("Error extrayendo los documentos \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        let datos = document.data()
                        let nombre = datos["nombre"] as? String ?? "Nombre"
                        let id = datos["id"] as? String ?? "ID"
                        let distancia = datos["distancia"] as? Double ?? 0.0
                        let lugar = datos ["lugar"] as? String ?? "Lugar"
                        let fecha = datos ["fecha"] as? String ?? "Fecha"
                        let hora = datos["hora"] as? String ?? "Hora"
                        let paseo = PetWalk(name: nombre,id: id, place: lugar, distance: distancia, date: fecha, hour: hora)
                        self.petWalksArray.append(paseo)
                    }
                        self.tableView.reloadData()
                }
            }
        distanceLabel.text = "Toca un paseo para contar los kms totales"
               
           }


}


    



//MARK: - TableViewDataSource
extension WalkListViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petWalksArray.count
      
    }
    
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! PetWalkCell
        
        let hora = petWalksArray[indexPath.row].hour
        let fecha =  petWalksArray[indexPath.row].date
        let lugar = petWalksArray[indexPath.row].place
        let distancia = petWalksArray[indexPath.row].distance
        
        cell.dateLabel.text = fecha
        cell.hourLabel.text = hora
        cell.placeLabel.text = lugar
        cell.selectionStyle = .none
      
        return cell
    }

    
}
//MARK: - UITableViewDelegate

extension WalkListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(primeraVez){
            for indice in petWalksArray{
                totalDistance+=indice.distance
                primeraVez = false
            }
        }
        
         distanceLabel.text = "Has recorrido  \(totalDistance) km con \(nombre)"

       
    }
}
 


