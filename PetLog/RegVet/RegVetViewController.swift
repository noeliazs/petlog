//
//  RegVetViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 09/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class RegVetViewController: UIViewController {

    private let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    private let alert = Alert()
    private let colors = Colors()
    var petName: String = ""
    private var date: String = ""
    private let COLLECTIONVETS = "Veterinario"
    
    @IBOutlet weak var vetTextField: UITextField!
    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registro de visitas veterinarias"
        reasonTextField.delegate = self
        vetTextField.delegate = self
        textFieldsConfigure()
          let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewAnimalViewController.dismissKeyboard))
          view.addGestureRecognizer(tap)
    }
    
    func textFieldsConfigure(){
           reasonTextField.layer.cornerRadius=10
           reasonTextField.layer.masksToBounds=true
           reasonTextField.layer.borderWidth = 2
           reasonTextField.layer.borderColor = colors.brownColor.cgColor
           vetTextField.layer.cornerRadius=10
           vetTextField.layer.masksToBounds=true
           vetTextField.layer.borderWidth = 2
           vetTextField.layer.borderColor = colors.brownColor.cgColor
           
           
           reasonTextField.attributedPlaceholder = NSAttributedString(string: "Nombre de la vacuna",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
           vetTextField.attributedPlaceholder = NSAttributedString(string: "Nombre del veterinario o clínica",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
           
       }
       
    @objc func dismissKeyboard() {
             view.endEditing(true)
    }


    @IBAction func saveButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if let user = user, let email = user.email, let reason = reasonTextField.text, let vet = vetTextField.text{
            if reason != "" && vet != "" && date != ""{
                db.collection(COLLECTIONVETS).document(petName+"-"+vet+"-"+date).setData([
                    "propietario": email,
                    "nombre": petName,
                    "razon": reason,
                    "veterinario": vet,
                    "fecha": date
                ])
                print("guardando visita veterinaria")
                clean()
                alert.viewSimpleAlert(view: self,title:"Visita al veterinario añadida",message:"Datos guardados")
            }
            else{
                alert.viewSimpleAlert(view: self,title:"Error",message:"Rellena todos los campos correctamente")
            }
        }
        else{
             alert.viewSimpleAlert(view: self,title:"Error",message:"Rellena todos los campos correctamente")
        }
        
    }
    
    
    @IBAction func listButtonAction(_ sender: UIButton) {
        print("cambio de vista listado de todas las vacunas")
        let vetListViewController = VetListViewController()
        navigationController?.pushViewController(vetListViewController, animated: true)
        vetListViewController.petName = petName
    }
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        clean()
    }
    
    func clean(){
        reasonTextField.text = ""
        vetTextField.text = ""
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSCalendar.Identifier.gregorian.rawValue))!
           calendar.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let components: NSDateComponents = NSDateComponents()
        components.year = 2020
        components.month = 1
        components.day = 1
        let defaultDate: NSDate = calendar.date(from: components as DateComponents)! as NSDate
        datePicker.date = defaultDate as Date
    }
    
    @IBAction func datePickerChanged(sender: UIDatePicker) {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM, yyyy"
        //Para convertir el mes en español
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
        dateFormatter.locale = Locale(identifier: "es")
        dateFormatter.date(from: date)
        date = dateFormatter.string(from: sender.date)

        print(date)
    }
    
}


//MARK: TextFieldDelegate
extension RegVetViewController: UITextFieldDelegate{
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
              self.view.endEditing(true)
              return false
        }
    
}



