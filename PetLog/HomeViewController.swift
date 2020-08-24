//
//  HomeViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 24/08/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
enum ProviderType: String{
    case basic
}

class HomeViewController: UIViewController {

    @IBOutlet weak var closeSesionButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var providerLabel: UILabel!
    private let email: String
    private let provider: ProviderType
    init(email: String, provider:ProviderType){
        self.email = email
        self.provider = provider
        super.init(nibName:nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("Implementa el código de inicialización")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Inicio"
    }
    
    @IBAction func closeSesionAction(_ sender: Any) {
    }
    
    /*
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    */

}
