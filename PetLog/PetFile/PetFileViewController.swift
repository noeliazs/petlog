//
//  PetFileViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 03/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class PetFileViewController: UIViewController{
    
    @IBOutlet weak var walkButton: UIButton!
    @IBOutlet weak var specieImage: UIImageView!
    @IBOutlet weak var imagePet: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specieLabel: UILabel!
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var medLabel: UILabel!
    @IBOutlet weak var foodLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    private var petManager = PetManager()
    private let db = Firestore.firestore()
    private let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    private let colors = Colors()
    private var arrayPet=[Pet]()
    private var photosArray = [PetPhoto]()
    var petID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ficha"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Editar", style: .done, target: self, action: #selector(edit))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        petManager.delegate = self
        petManager.petID = petID
        petManager.loadPet()
        petManager.loadPhoto(id: petID)
        imagePet.layer.cornerRadius = imagePet.bounds.size.width / 2.0
    }
 
    @objc func edit(){
        print("editar")
        let updateAnimalViewController = UpdateAnimalViewController()
        navigationController?.pushViewController(updateAnimalViewController, animated: true)
        updateAnimalViewController.id = petID
    }
    
    
    func completeLabels(){
        let mascota = arrayPet[0]
        nameLabel.text = "Nombre: \(mascota.name)"
        specieLabel.text = "Especie: \(mascota.specie)"
        raceLabel.text = "Raza: \(mascota.race)"
        yearLabel.text = "Año de nacimiento:  \(String(mascota.year))"
        medLabel.text = "Medicación especial: \(mascota.med)"
        foodLabel.text = "Alimentación especial: \(mascota.food)"
        weightLabel.text = "Peso:  \(String(mascota.weight)) Kg"
        let image : UIImage = UIImage(named: mascota.specie)!
        specieImage.image = image
        imagePet.image = image
    }
    

    @IBAction func walkButtonAction(_ sender: UIButton) {
        print("Paseo")
        let mascota = arrayPet[0]
        let regWalkViewController = RegWalkViewController()
        navigationController?.pushViewController(regWalkViewController, animated: true)
        regWalkViewController.petID = mascota.id
        regWalkViewController.petName = mascota.name
        
    }
    
    @IBAction func vacButtonAction(_ sender: Any) {
        print("vacuna")
        let mascota = arrayPet[0]
        let regVacViewController = RegVacViewController()
        navigationController?.pushViewController(regVacViewController, animated: true)
        regVacViewController.petName = mascota.name
    }
    
    @IBAction func vetButtonAction(_ sender: Any) {
        print("veterinario")
        let mascota = arrayPet[0]
        let regVetViewController = RegVetViewController()
        navigationController?.pushViewController(regVetViewController, animated: true)
        regVetViewController.petName = mascota.name
    }
    
    func checkWalkButton(){
        let mascota = arrayPet[0]
        let specie = mascota.specie
        if specie != "Canina"  {
            walkButton.isEnabled = false
        }
    }
    
    func showActivityIndicatory(uiView: UIView) {
        actInd.frame = CGRectMake(40.0, 40.0, 150.0, 150.0);
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.style = UIActivityIndicatorView.Style.large
        actInd.color = .black
        uiView.addSubview(actInd)
        actInd.startAnimating()
    }
    
    @objc func stopActivityIndicatory(){
        actInd.stopAnimating()
    }
    
   
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    public func imageFromUrl(urlString: String) {
       let imageURL = URL(string: photosArray[0].image)
       var image: UIImage?
        if let url = imageURL{
           DispatchQueue.global(qos: .userInitiated).async {
               let imageData = NSData(contentsOf: url)
               DispatchQueue.main.async {
                   if imageData != nil {
                       image = UIImage(data: imageData! as Data)
                       self.loadImage(image: image!)
                      
                   } else {
                       image = nil
                       print("nulo")
                   }
               }
           }
        }
    }
    
    public func loadImage(image: UIImage){
         imagePet.image = image
    }

}


//MARK: - PetFileDelegate
extension PetFileViewController:PetFileDelegate{
    
    func updatePhoto(_ petManager: PetManager, photos: [PetPhoto]) {
        self.photosArray = photos
        if(photosArray.count > 0){
            imageFromUrl(urlString: photosArray[0].image)
        }
    }

    
    func updatePets(_ petManager: PetManager, pets: [Pet]){
        DispatchQueue.main.async{
            self.showActivityIndicatory(uiView: self.view)
            self.arrayPet =  pets
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.stopActivityIndicatory), userInfo: nil, repeats: false)
            self.completeLabels()
            self.checkWalkButton()
        }
       
    }
    
    func didFailWithError(error: Error) {
         print(error)
     }
}

