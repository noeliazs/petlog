//
//  NewAnimalViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 01/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore

class NewAnimalViewController: UIViewController {
    
   
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var speciePicker: UIPickerView!
    @IBOutlet weak var raceTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var medTextField: UITextField!
    @IBOutlet weak var foodTextField: UITextField!
    
    private let db = Firestore.firestore()
    private let alert = Alert()
    private let colors = Colors()
    let newAnimalManager = NewAnimalManager()
    let user = Auth.auth().currentUser
    
    //Nombre de la colección en la BD
    let COLECTIONANIMALS = "Animales"
    var SpeciesArray = ["","Canina","Felina","Ave","Roedor","Pez","Reptil","Otros"]
    var email : String = ""
    var specie: String = ""
    //se utilizará este id para recuperar los animales de una forma más sencilla
    var id: String = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.speciePicker.dataSource = self
        self.speciePicker.delegate = self
        nameTextField.delegate = self
        raceTextField.delegate = self
        yearTextField.delegate = self
        weightTextField.delegate = self
        medTextField.delegate = self
        foodTextField.delegate = self
        
        title = "Registro nueva mascota"
        textFieldsConfigure()
        newAnimalManager.putController(newAnimalViewController: self)
        email = user!.email!
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewAnimalViewController.dismissKeyboard))
         view.addGestureRecognizer(tap)
    }
    
    func textFieldsConfigure(){
        nameTextField.layer.cornerRadius=10
        nameTextField.layer.masksToBounds=true
        nameTextField.layer.borderWidth = 2
        nameTextField.layer.borderColor = colors.brownColor.cgColor
        raceTextField.layer.cornerRadius=10
        raceTextField.layer.masksToBounds=true
        raceTextField.layer.borderWidth = 2
        raceTextField.layer.borderColor = colors.brownColor.cgColor
        yearTextField.layer.cornerRadius=10
        yearTextField.layer.masksToBounds=true
        yearTextField.layer.borderWidth = 2
        yearTextField.layer.borderColor = colors.brownColor.cgColor
        weightTextField.layer.cornerRadius=10
        weightTextField.layer.masksToBounds=true
        weightTextField.layer.borderWidth = 2
        weightTextField.layer.borderColor = colors.brownColor.cgColor
        medTextField.layer.cornerRadius=10
        medTextField.layer.masksToBounds=true
        medTextField.layer.borderWidth = 2
        medTextField.layer.borderColor = colors.brownColor.cgColor
        foodTextField.layer.cornerRadius=10
        foodTextField.layer.masksToBounds=true
        foodTextField.layer.borderWidth = 2
        foodTextField.layer.borderColor = colors.brownColor.cgColor
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: "Nombre",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
        raceTextField.attributedPlaceholder = NSAttributedString(string: "Raza",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
        yearTextField.attributedPlaceholder = NSAttributedString(string: "Año de nacimiento",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
        medTextField.attributedPlaceholder = NSAttributedString(string: "No o la medicación que necesita",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
        weightTextField.attributedPlaceholder = NSAttributedString(string: "Peso en kilos. Admite decimales",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
        foodTextField.attributedPlaceholder = NSAttributedString(string: "No o el tipo de alimentación que necesita",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
    }
    
    @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    
    @IBAction func cleanButtonAction(_ sender: UIButton) {
        //quitar teclado
        view.endEditing(true)
        clean()
    

    }
    @IBAction func saveButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        yearTextField.layer.borderColor = colors.brownColor.cgColor
        if let user = user, let email = user.email{
            if let name = nameTextField.text, let race = raceTextField.text, let year = Int(yearTextField.text!),let med = medTextField.text, let weight = Double(weightTextField.text!), let food = foodTextField.text{
                id = email+"-"+name
                let pet = Pet(id: id, name: name, specie: specie, race: race, year: year, weight: weight, med: med, food: food, owner: email)
                newAnimalManager.saveAnimal(pet: pet)
            }
            else{
               viewAlertBad()
            }
              
        }
        
     
    }
    
    func clean(){
         //limpiar campos
        nameTextField.text = ""
        speciePicker.selectRow(0, inComponent: 0, animated: false)
        raceTextField.text = ""
        yearTextField.text = ""
        weightTextField.text = ""
        medTextField.text = ""
        foodTextField.text = ""
    }
    
    func viewAlertSave(){
        alert.viewSimpleAlert(view: self,title:"Mascota añadida",message:"Datos guardados")
        yearTextField.layer.borderColor = colors.brownColor.cgColor
        clean()
    }
    
    func viewAlertBadYear(){
        alert.viewSimpleAlert(view: self,title:"Error",message:"Comprueba el año de nacimiento.")
        yearTextField.layer.borderColor = colors.redColor.cgColor
    }
    
    func viewAlertBad(){
         alert.viewSimpleAlert(view: self,title:"Error",message:"Rellena todos los campos correctamente.")
    }
    
   
}


//MARK: Picker Delegate

extension NewAnimalViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return SpeciesArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return SpeciesArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        specie=SpeciesArray[row]
        print(specie)
    }
}

//MARK: TextFieldDelegate
extension NewAnimalViewController: UITextFieldDelegate{
    //cuando pulsamos la tecla return el teclado desaparece
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
              self.view.endEditing(true)
              return false
        }
    
}
