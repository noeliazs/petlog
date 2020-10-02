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
    private let fonts = Fonts()
    let walkListManager = WalkListManager()
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var id: String = ""
    var nombre: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Lista de paseos de \(nombre)"
        walkListManager.putController(walkListViewController: self)
        
        tableView.register(UINib(nibName: "PetWalkCell",bundle:nil), forCellReuseIdentifier: "ReusableCell")
        tableView.dataSource=self
        tableView.delegate=self
        walkListManager.loadWalks(id: id)
        
        distanceLabel.text = "Toca un paseo para contar los kms totales"
               
    }
    
    @IBAction func HomeButtonAction(_ sender: UIButton){
           navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    func reloadTable(){
          self.tableView.reloadData()
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
        //let distancia = petWalksArray[indexPath.row].distance
        
        cell.dateLabel.text = fecha
        cell.hourLabel.text = hora
        cell.placeLabel.text = lugar
        cell.selectionStyle = .none
        cell.placeLabel.numberOfLines = 0
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        let lugar = petWalksArray[indexPath.row].place
     
        return CGFloat(25) + lugar.heightWithConstrainedWidth(width: tableView.frame.width, font: fonts.cellsTablesFont)
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
 

extension String {
     func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
     let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
     let boundingBox = self.boundingRect(with: constraintRect, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font: font], context: nil)
     
     return boundingBox.height + 30
     }
}




