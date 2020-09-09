//
//  RegVacViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 07/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class RegVacViewController: UIViewController {

    private let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    private let alert = Alert()
    private let colors = Colors()
    var petName: String = ""
    private var date: String = ""
    private let COLLECTIONVACCINES = "Vacunas"

    @IBOutlet weak var vacTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var vetTextField: UITextField!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Registro de Vacunas"
        vacTextField.delegate = self
        vetTextField.delegate = self
        textFieldsConfigure()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewAnimalViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func textFieldsConfigure(){
        vacTextField.layer.cornerRadius=10
        vacTextField.layer.masksToBounds=true
        vacTextField.layer.borderWidth = 2
        vacTextField.layer.borderColor = colors.brownColor.cgColor
        vetTextField.layer.cornerRadius=10
        vetTextField.layer.masksToBounds=true
        vetTextField.layer.borderWidth = 2
        vetTextField.layer.borderColor = colors.brownColor.cgColor
        
        
        vacTextField.attributedPlaceholder = NSAttributedString(string: "Nombre de la vacuna",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
        vetTextField.attributedPlaceholder = NSAttributedString(string: "Nombre del veterinario o clínica",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
        
    }
    
    @objc func dismissKeyboard() {
           view.endEditing(true)
       }

    
    @IBAction func saveButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if let user = user, let email = user.email, let vaccine = vacTextField.text, let vet = vetTextField.text{
            if vaccine != "" && vet != "" && date != ""{
                db.collection(COLLECTIONVACCINES).document(petName+"-"+vaccine+"-"+date).setData([
                    "propietario": email,
                    "nombre": petName,
                    "vacuna": vaccine,
                    "veterinario": vet,
                    "fecha": date
                ])
                print("guardando")
                clean()
                alert.viewSimpleAlert(view: self,title:"Vacuna añadida añadido",message:"Datos guardados")
            }
            else{
                alert.viewSimpleAlert(view: self,title:"Error",message:"Rellena todos los campos correctamente")
            }
        }
        else{
             alert.viewSimpleAlert(view: self,title:"Error",message:"Rellena todos los campos correctamente")
        }
        
    }
    
    
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        clean()
    }
    

    @IBAction func listButtonAction(_ sender: UIButton) {
        print("cambio de vista listado de todas las vacunas")
        let vacListViewController = VacListViewController()
         navigationController?.pushViewController(vacListViewController, animated: true)
        vacListViewController.petName = petName
         
    }
    
    func clean(){
           vacTextField.text = ""
           vetTextField.text = ""
        //Colocar una fecha por defecto en el datePicker
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
extension RegVacViewController: UITextFieldDelegate{
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
              self.view.endEditing(true)
              return false
        }
    
}
