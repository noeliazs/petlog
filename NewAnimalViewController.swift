//
//  NewAnimalViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 01/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import Firebase

class NewAnimalViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var speciePicker: UIPickerView!
    @IBOutlet weak var raceTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var medTextField: UITextField!
    @IBOutlet weak var foodTextField: UITextField!
    
    var SpeciesArray = ["","Canina","Felina","Ave","Roedor","Pez","Reptil","Otros"]
    let user = Auth.auth().currentUser
    var specie: String = ""
    var id: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.speciePicker.dataSource = self
        self.speciePicker.delegate = self
        title = "Registro nueva mascota"
      
    
    }
    
    @IBAction func cleanButtonAction(_ sender: UIButton) {
        nameTextField.text = ""
        speciePicker.selectRow(0, inComponent: 0, animated: false)
        raceTextField.text = ""
        yearTextField.text = ""
        weightTextField.text = ""
        medTextField.text = ""
        foodTextField.text = ""
    }
    @IBAction func saveButtonAction(_ sender: UIButton) {
        if let user = user, let email = user.email{
            if let name = nameTextField.text, let race = raceTextField.text, let year = Int(yearTextField.text!), let weight = Double(weightTextField.text!), let food = foodTextField.text{
                if specie != "" && name != "" && race != "" && year != 0 && weight != 0.0 && food != ""{
                    if checkYear(year:year){
                        id = race+name
                        print("guardando")
                        print(email)
                    }
                  
                }
                
            }
              
        }
     
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
