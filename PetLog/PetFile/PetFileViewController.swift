//
//  PetFileViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 03/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit

class PetFileViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    var id: String = ""
    var myPet: [Pet] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ficha"
        label.text = myPet[0].name
        
    }


}
