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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var speciePicker: UIPickerView!
    @IBOutlet weak var raceTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var medTextField: UITextField!
    @IBOutlet weak var foodTextField: UITextField!
    
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
        title = "Registro nueva mascota"
        email = user!.email!
    }
    
    @IBAction func cleanButtonAction(_ sender: UIButton) {
        //quitar teclado
        view.endEditing(true)
        
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
                        id = email+name
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
                        clean()
                    }
                    
                   alert.viewSimpleAlert(view: self,title:"Error",message:"Comprueba el año de nacimiento.")
                }
                alert.viewSimpleAlert(view: self,title:"Error",message:"Rellena todos los campos.")
                
            }
             alert.viewSimpleAlert(view: self,title:"Error",message:"Revisa los campos por favor.")
              
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
