//
//  UpdateAnimalViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 15/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore

class UpdateAnimalViewController: UIViewController {
    
    @IBOutlet weak var medTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var foodTextField: UITextField!
    var id: String = ""
    private let db = Firestore.firestore()
    let user = Auth.auth().currentUser
    private let alert = Alert()
    private let colors = Colors()
    private let COLECTIONANIMALS = "Animales"
    let updateAnimalManager = UpdateAnimalManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Editar mascota"
        medTextField.delegate = self
        weightTextField.delegate = self
        foodTextField.delegate = self
        textFieldsConfigure()
        updateAnimalManager.putController(updateAnimalViewController: self)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NewAnimalViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Foto", style: .done, target: self, action: #selector(addPhoto))
    }
    
    @objc func addPhoto(){
          print("añadir foto")
        let url = "https://metricool.com/wp-content/uploads/new-igbio-header-2020.png"
        let photo = PetPhoto(id: id, image: url)
        updateAnimalManager.savePhoto(photo: photo)
          
    }
      
    func textFieldsConfigure(){
        medTextField.layer.cornerRadius=10
        medTextField.layer.masksToBounds=true
        medTextField.layer.borderWidth = 2
        medTextField.layer.borderColor = colors.brownColor.cgColor
        weightTextField.layer.cornerRadius=10
        weightTextField.layer.masksToBounds=true
        weightTextField.layer.borderWidth = 2
        weightTextField.layer.borderColor = colors.brownColor.cgColor
        foodTextField.layer.cornerRadius=10
        foodTextField.layer.masksToBounds=true
        foodTextField.layer.borderWidth = 2
        foodTextField.layer.borderColor = colors.brownColor.cgColor
        
        
        medTextField.attributedPlaceholder = NSAttributedString(string: "No o la medicación que necesita",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
        weightTextField.attributedPlaceholder = NSAttributedString(string: "Peso en kilos. Admite decimales",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
        foodTextField.attributedPlaceholder = NSAttributedString(string: "No o el tipo de alimentación que necesita",attributes: [NSAttributedString.Key.foregroundColor:colors.darkPinkColor,NSAttributedString.Key.font: UIFont(name: "Helvetica", size: 18)!])
        
    }
    
    @objc func dismissKeyboard() {
           view.endEditing(true)
       }


    @IBAction func saveFoodButtonAction(_ sender: UIButton) {
        view.endEditing(true)
            if let food = foodTextField.text{
                updateAnimalManager.updateFood(id:id,food:food)
            }
            else{
                alertBad()
            }
    
    }
    
    
    @IBAction func saveWeightButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if let weight = Double(weightTextField.text!){
            updateAnimalManager.updateWeight(id: id, weight: weight)
        }
        else{
            alertBad()
        }
    }
    
    @IBAction func saveMedButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        if let med = medTextField.text{
            updateAnimalManager.updateMed(id:id, med: med)
        }
        else{
            alertBad()
        }
    }
    
    @IBAction func cleanButtonAction(_ sender: UIButton) {
        view.endEditing(true)
        clean()
    }
    
    func clean(){
        weightTextField.text = ""
        medTextField.text = ""
        foodTextField.text = ""
    }
    
    func alertBad(){
        alert.viewSimpleAlert(view: self,title:"Error",message:"Revisa el campo por favor.")
        clean()
    }
    
    func alertMedGood(){
        alert.viewSimpleAlert(view: self,title:"Medicación de la mascota modificada.",message:"Datos guardados")
        clean()
    }
    
    func alertFoodGood(){
        alert.viewSimpleAlert(view: self,title:"Alimentación de la mascota modificada",message:"Datos guardados")
        clean()
    }
    
    func alertWeightGood(){
        alert.viewSimpleAlert(view: self,title:"Peso de la mascota modificado.",message:"Datos guardados")
        clean()
    }
    
    func viewAlertSavePhoto(){
        alert.viewSimpleAlert(view: self,title:"Foto guardada",message:"Datos guardados")
    }
}

//MARK: TextFieldDelegate
extension UpdateAnimalViewController: UITextFieldDelegate{
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
              self.view.endEditing(true)
              return false
        }
    
}
