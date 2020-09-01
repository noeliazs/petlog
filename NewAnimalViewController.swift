//
//  NewAnimalViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 01/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit

class NewAnimalViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var speciePicker: UIPickerView!
    
    @IBOutlet weak var raceTextField: UITextField!
    
  
    @IBOutlet weak var yearTextField: UITextField!
    
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var medTextField: UITextField!
      @IBOutlet weak var foodTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Registro nueva mascota"
    }


   

}
