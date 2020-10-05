//
//  VacListManager.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 03/10/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class VacListManager{
    var vacListViewController: VacListViewController?
    private let db = Firestore.firestore()
    private let COLLECTIONVACCINES = "Vacunas"
  
    func putController(vacListViewController: VacListViewController) {
        self.vacListViewController = vacListViewController
    }
    
    func loadVacs(email: String){
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
                        self.vacListViewController?.petVacArray.append(vacunacion)
                     }
                    self.vacListViewController?.reloadTable()
                 }
                }
   }
    
    func loadVacs(email: String,name: String){
        db.collection(COLLECTIONVACCINES).whereField("propietario", isEqualTo: email).whereField("nombre", isEqualTo: name).getDocuments() { (querySnapshot, err) in
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
                  self.vacListViewController?.petVacArray.append(vacunacion)
              }
                  self.vacListViewController?.reloadTable()
          }
        }
    }

}


//MARK: - UITableView PDF
extension UITableView {
    
    // Export pdf from UITableView and save pdf in drectory and return pdf file path
    func exportAsPdfFromTable() -> String {
        
        let originalBounds = self.bounds
        self.bounds = CGRect(x:originalBounds.origin.x, y: originalBounds.origin.y, width: self.contentSize.width, height: self.contentSize.height)
        let pdfPageFrame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.contentSize.height)
        
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageFrame, nil)
        UIGraphicsBeginPDFPageWithInfo(pdfPageFrame, nil)
        guard let pdfContext = UIGraphicsGetCurrentContext() else { return "" }
        self.layer.render(in: pdfContext)
        UIGraphicsEndPDFContext()
        self.bounds = originalBounds
        // Save pdf data
        return self.saveTablePdf(data: pdfData)
        
    }
    
    // Save pdf file in document directory
    func saveTablePdf(data: NSMutableData) -> String {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docDirectoryPath = paths[0]
        let pdfPath = docDirectoryPath.appendingPathComponent("Listado.pdf")
        if data.write(to: pdfPath, atomically: true) {
            return pdfPath.path
        } else {
            return ""
        }
    }
}
 

