//
//  PetsViewController.swift
//  PetLog
//
//  Created by NOELIA ZARZOSO on 03/09/2020.
//  Copyright © 2020 NOELIA ZARZOSO. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase
import SwipeCellKit
import CoreGraphics

class PetsViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    private let db = Firestore.firestore()
    private let colors = Colors()
    private let fonts = Fonts()
    private var petManager = PetManager()
    private let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    private let strings = Strings()
    private var petsArray = [Pet]()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mis mascotas"
        tableView.register(UINib(nibName: "PetCell",bundle:nil), forCellReuseIdentifier: "ReusableCell")
        tableView.dataSource=self
        tableView.delegate=self
        tableView.rowHeight = 60
        petManager.delegate = self
        petManager.loadPets()
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


}


//MARK: - TableViewDataSource
extension PetsViewController: UITableViewDataSource, SwipeTableViewCellDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petsArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath)as! SwipeTableViewCell
        cell.delegate = self
 
        let nombre = petsArray[indexPath.row].name
        let specie = petsArray[indexPath.row].specie
        
        cell.textLabel!.text = nombre
        cell.textLabel!.font = fonts.cellsTablesPetsFont
        cell.selectionStyle = .none
      
        let image : UIImage = imageWithImage(image: UIImage(named: specie)!, scaledToSize: CGSize(width: 40, height: 40))
        cell.imageView!.image = image
      
        if indexPath.row % 2 != 0{
            cell.backgroundColor = colors.lightPinkColor
            cell.imageView?.tintColor = colors.lightBrownColor
            cell.textLabel!.textColor = colors.lightBrownColor
        }
        else{
            cell.backgroundColor = colors.lightBrownColor
            cell.imageView?.tintColor = colors.lightPinkColor
            cell.textLabel!.textColor = colors.lightPinkColor
        }
       
        
        return cell
    }
    
    //cuando deslizamos una celda
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            self.updateModel(at: indexPath)
        }
        deleteAction.image = UIImage(named: "delete")
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func updateModel(at indexPath: IndexPath) {
         let mascota = petsArray[indexPath.row]
         let id = mascota.id
       
        db.collection(strings.COLLECTIONANIMALS).document(id).delete() { err in
            if let err = err {
                print("Error de borrado \(err)")
            } else {
                print("Animal eliminado")
                self.tableView.reloadData()
            }
        }
        petsArray.remove(at: indexPath.row)
    }
    
    
    
    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    func imageWithImage(image:UIImage,scaledToSize newSize:CGSize)->UIImage{

      UIGraphicsBeginImageContext( newSize )
        image.draw(in: CGRect(x: 0,y: 0,width: newSize.width,height: newSize.height))
      let newImage = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysTemplate)
    }
}

//MARK: - UITableViewDelegate

extension PetsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let petFileViewController = PetFileViewController()
        var array = [Pet]()
        let pet = petsArray[indexPath.row]
        array.append(pet)
        navigationController?.pushViewController(petFileViewController, animated: true)
        petFileViewController.petID = array[0].id

    }
}
 

//MARK: - PetFileDelegate
extension PetsViewController:PetFileDelegate{
    func updatePhoto(_ petManager: PetManager, photos: [PetPhoto]) {
        //
    }
    
    
    func updatePets(_ petManager: PetManager, pets: [Pet]){
        DispatchQueue.main.async{
            self.showActivityIndicatory(uiView: self.view)
            self.petsArray =  pets
            
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.stopActivityIndicatory), userInfo: nil, repeats: false)
            self.tableView.reloadData()
        }
       
    }
    
    func didFailWithError(error: Error) {
         print(error)
     }
}


