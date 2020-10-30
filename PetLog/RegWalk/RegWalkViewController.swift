//
//  RegWalkViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 04/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//
import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class RegWalkViewController: UIViewController {
    
    @IBOutlet weak var placeTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var hourPicker: UIDatePicker!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    private let db = Firestore.firestore()
    private let alert = Alert()
    private let colors = Colors()
    private let regWalkManager = RegWalkManager()
    var petID: String = ""
    var petName: String = ""
    private var date: String = ""
    private var hour: String = ""
     
    override func viewDidLoad() {
        super.viewDidLoad()
       title = "Registro paseo"
       distanceTextField.delegate = self
       placeTextField.delegate = self
       textFieldsConfigure()
       regWalkManager.putController(regWalkViewController: self)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewAnimalViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        //solo se permite seleccionar hasta la fecha actual
        datePicker.maximumDate = Calendar.current.date(byAdding: .hour, value: 1, to: Date())
    }
    
    func textFieldsConfigure(){
        placeTextField.layer.cornerRadius=10
        placeTextField.layer.masksToBounds=true
        placeTextField.layer.borderWidth = 2
        placeTextField.layer.borderColor = colors.brownColor.cgColor
        distanceTextField.layer.cornerRadius=10
        distanceTextField.layer.masksToBounds=true
        distanceTextField.layer.borderWidth = 2
        distanceTextField.layer.borderColor = colors.brownColor.cgColor
        
        placeTextField.attributedPlaceholder = NSAttributedString(string: "Lugar",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
        distanceTextField.attributedPlaceholder = NSAttributedString(string: "Distancia en km",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
        
    }
    
    @objc func dismissKeyboard() {
           view.endEditing(true)
    }
 
    @IBAction func saveButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if let distance = Double(distanceTextField.text!), let place = placeTextField.text{
            let walk = PetWalk(name: petName, id: petID, place: place, distance: distance, date: date, hour: hour)
            regWalkManager.saveWalk(walk: walk)
        }
        else{
             alertBad()
        }
    }
    
    @IBAction func deleteButtonAction(_ sender: Any) {
        view.endEditing(true)
        clean()
    }
    @IBAction func listButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        let walkListViewController = WalkListViewController()
        navigationController?.pushViewController(walkListViewController, animated: true)
        walkListViewController.id = petID
        walkListViewController.nombre = petName
     }
    
    func alertBad(){
        alert.viewSimpleAlert(view: self,title:"Error",message:"Rellena todos los campos correctamente")
    }
    func alertGood(){
        clean()
        alert.viewSimpleAlert(view: self,title:"Paseo añadido",message:"Datos guardados")
    }
    
    
    func clean(){
        distanceTextField.text = ""
        placeTextField.text = ""
        //Colocar una fecha y una hora por defecto en los pickers
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSCalendar.Identifier.gregorian.rawValue))!
        calendar.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let components: NSDateComponents = NSDateComponents()
        components.year = 2020
        components.month = 1
        components.day = 1
        let defaultDate: NSDate = calendar.date(from: components as DateComponents)! as NSDate
        datePicker.date = defaultDate as Date
        components.hour = 00
        components.minute = 00
        let defaultHour: NSDate = calendar.date(from: components as DateComponents)! as NSDate
        hourPicker.date = defaultHour as Date
          
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
    
    @IBAction func hourPickerChanged(sender: UIDatePicker) {
           let hourFormatter = DateFormatter()
           hourFormatter.dateFormat = "HH:mm"
           hour = hourFormatter.string(from: sender.date)
           print(hour)
       }
}


//MARK: TextFieldDelegate
extension RegWalkViewController: UITextFieldDelegate{
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
              self.view.endEditing(true)
              return false
        }
    
}
