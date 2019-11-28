//
//  AlertInfoProgramaViewController.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 28/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit

protocol PopupDelegetProductos {
    func closeTappedProductos()
}
class AlertInfoProgramaViewController: UIViewController {
     var closePopupProductos:PopupDelegetProductos?
    
    @IBOutlet weak var textViewDetalle: UILabel!
    @IBOutlet weak var textViewNombreProduct: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        guard let placesData = UserDefaults.standard.object(forKey: "detalleProducto") as? NSData else {
               print("'places' not found in UserDefaults")
               return
           }
        
        guard let detalleProducto = NSKeyedUnarchiver.unarchiveObject(with: placesData as Data) as? [ProductoObject] else {
               print("Could not unarchive from placesData")
               return
           }
        for producto in detalleProducto {
            print("")
            self.textViewNombreProduct.text = producto.Nombre!
            self.textViewDetalle.text = producto.Descripcion!
        }
        
        //let access_token = preferences.array(forKey: "detalleProducto")
        //print(access_token)

        // Do any additional setup after loading the view.
    }

    @IBAction func closeAlertProducts(_ sender: Any) {
         self.closePopupProductos?.closeTappedProductos()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
