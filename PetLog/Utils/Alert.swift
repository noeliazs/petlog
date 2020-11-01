
import Foundation
import UIKit

class Alert {
        let alerta = UIAlertController(title: "Guardando",message:"",
                                       preferredStyle: UIAlertController.Style.alert)
    
 
    
    func stopAlert(viewController: UIViewController){
        viewController.dismiss(animated: false, completion: nil)
              
    }
    
    func viewSimpleAlert(view: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
       alert.addAction(UIAlertAction(title: "Aceptar", style: .default))
       view.present(alert, animated: true,completion:nil)
        
     }
    
    
    func showAlert(viewController: UIViewController){
     // height constraint
     let constraintHeight = NSLayoutConstraint(
        item: alerta.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
        NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300)
     alerta.view.addConstraint(constraintHeight)

     // width constraint
     let constraintWidth = NSLayoutConstraint(
        item: alerta.view!, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
        NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 300)
     alerta.view.addConstraint(constraintWidth)
        

        
        let imageView = UIImageView(frame: CGRect(x: 50, y: 80, width:200, height: 200))
        
        imageView.image = UIImage.gif(asset: "gif")

           alerta.view.addSubview(imageView)
        viewController.present(alerta, animated: true, completion: nil)
    }
    
}
