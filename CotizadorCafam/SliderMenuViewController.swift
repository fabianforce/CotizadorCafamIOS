//
//  SliderMenuViewController.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 29/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit
protocol SlideMenuDelegate{
    func slideMenuItemSelectArIndex(_ index : Int32)
}

class SliderMenuViewController: UIViewController {
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
    var productCartItems1: [CartItem] = []
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var tableViewCart: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewCart.dataSource = self
        self.tableViewCart.delegate = self
        //print("hola perra")
        let preferences = UserDefaults.standard
        let total = preferences.string(forKey: "totalCart")
        self.labelTotal?.text = "$" + total!
        guard let getProduct = UserDefaults.standard.object(forKey: "cartProduct") as? NSData else {
            print("'places' not found in UserDefaults")
            return
        }
        guard let productCartItems = NSKeyedUnarchiver.unarchiveObject(with: getProduct as Data) as? [CartItem] else {
            print("Could not unarchive from placesData")
            return
        }
        for producto in productCartItems {
            print(producto.name!)
            let objetCartItem = CartItem(name: producto.name!,price: 1,quantity: 2,unitVal: producto.name)
            self.productCartItems1.append(objetCartItem)
            self.tableViewCart.reloadData();
            //self.textViewNombreProduct.text = producto.Nombre!
            //self.textViewDetalle.text = producto.Descripcion!
        }
         print("entro",productCartItems.count)
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnCloseSliderMenu(_ sender: UIButton) {
        btnClose.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(sender.tag)
            if(sender == self.btnClose){
                index = -1
            }
            delegate?.slideMenuItemSelectArIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            //self.view.removeFromSuperview()
            self.removeFromParent()
            
        })
    }
    
    
}
extension SliderMenuViewController: UITableViewDataSource,UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productCartItems1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
        }
        let ejeFormacion = self.productCartItems1[indexPath.row]
                   //self.textViewNombreProduct.text = producto.Nombre!
                   //self.textViewDetalle.text = producto.Descripcion!
           
        
        /* if let url = NSURL(string: infraestructura.nombre) {
         if let data = NSData(contentsOf: url as URL) {
         //cell?.imageView?.image = UIImage(data: data as Data)
         }
         }*/
        cell!.textLabel?.text = ejeFormacion.name //
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //let clickInfraestructura = self.items[indexPath.row]
        var idInfraestuctura : String!
        var nombreInfra : String!
        print("hp", self.productCartItems1.count)
        //idInfraestuctura = clickInfraestructura.idInfraestructura;
        //nombreInfra = clickInfraestructura.nombre
        //let preferences = UserDefaults.standard
        //preferences.set(idInfraestuctura, forKey: "infra") //Bool
        //preferences.set(nombreInfra, forKey: "infraNombre") //Bool
        //didSave(preferences: preferences)
        //print(nombreInfra!)
        // self.closePopup?.closeTapped()
        
    }
    
    // Checking the UserDefaults is saved or not
    func didSave(preferences: UserDefaults){
        let didSave = preferences.synchronize()
        if !didSave{
            // Couldn't Save
            print("Preferences could not be saved!")
        }
    }
    
}
