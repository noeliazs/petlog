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
    
    //acceso a la bd
    private let db = Firestore.firestore()
    private let alert = Alert()
    private let colors = Colors()
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var speciePicker: UIPickerView!
    @IBOutlet weak var raceTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var medTextField: UITextField!
    @IBOutlet weak var foodTextField: UITextField!
    
    //Nombre de la colección en la BD
    let COLECTIONANIMALS = "Animales"
    var SpeciesArray = ["","Canina","Felina","Ave","Roedor","Pez","Reptil","Otros"]
    let user = Auth.auth().currentUser
    var email : String = ""
    var specie: String = ""
    //se utilizará este id para recuperar los animales de una forma más sencilla
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.speciePicker.dataSource = self
        self.speciePicker.delegate = self
        self.nameTextField.delegate = self
        self.raceTextField.delegate = self
        self.yearTextField.delegate = self
        self.weightTextField.delegate = self
        self.medTextField.delegate = self
        self.foodTextField.delegate = self
        
        title = "Registro nueva mascota"
        textFieldsConfigure()
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
        
        db.collection(COLECTIONANIMALS).whereField("propietario", isEqualTo: email).whereField("nombre", isEqualTo: "Misi")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error extrayendo los documentos \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                    }
                }
        }

    }
    @IBAction func saveButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if let user = user, let email = user.email{
            if let name = nameTextField.text, let race = raceTextField.text, let year = Int(yearTextField.text!),let med = medTextField.text, let weight = Double(weightTextField.text!), let food = foodTextField.text{
                if specie != "" && name != "" && race != "" && year != 0 && med != "" && weight != 0.0 && food != ""{
                    if checkYear(year:year){
                        id = email+"/"+name
                        print("guardando")
                        print(email)
                        db.collection(COLECTIONANIMALS).document(id).setData([
                            "id": id,
                            "propietario": email,
                            "nombre": name,
                            "especie": specie,
                            "raza": race,
                            "nacimiento": year,
                            "medicacion": med,
                            "peso": weight,
                            "alimentacion": food
                            
                        ])
                         alert.viewSimpleAlert(view: self,title:"Mascota añadida",message:"Datos guardados")
                        yearTextField.layer.borderColor = colors.brownColor.cgColor
                        clean()
                    }
                    else{
                        alert.viewSimpleAlert(view: self,title:"Error",message:"Comprueba el año de nacimiento.")
                        yearTextField.layer.borderColor = colors.redColor.cgColor
                    }
                    
                  
                }
                else{
                     alert.viewSimpleAlert(view: self,title:"Error",message:"Rellena todos los campos.")
                }
               
                
            }
            else{
                  alert.viewSimpleAlert(view: self,title:"Error",message:"Revisa los campos por favor.")
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
   
    // Controla si se introduce un año válido
    func checkYear(year : Int)->Bool{
        let date = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        let now = components.year
        
        if(year > now!){
            return false
        }
        return true
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
     //cuando pulsamos la tecla return
    private func textFieldShouldReturn(textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
}
