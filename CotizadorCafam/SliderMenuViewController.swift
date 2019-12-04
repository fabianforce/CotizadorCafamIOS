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

class SliderMenuViewController: UIViewController,PopupDelegetProductosDescu {
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
    var productCartItems1: [CartItem] = []
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var labelTotal: UILabel!
    @IBOutlet weak var tableViewCart: UITableView!
    @IBOutlet weak var btnEnviarCoti: UIButton!
    @IBOutlet weak var btnMasOpciones: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewCart.dataSource = self
        self.tableViewCart.delegate = self
        self.registerTbaleViewCells()
        //self.btnEnviarCoti.backgroundColor = .clear
        self.btnEnviarCoti.layer.cornerRadius = 5
        //self.btnEnviarCoti.layer.borderWidth = 1
        //self.btnEnviarCoti.layer.borderColor = UIColor.green.cgColor
        
        //self.btnMasOpciones.backgroundColor = .clear
        self.btnMasOpciones.layer.cornerRadius = 5
        //self.btnMasOpciones.layer.borderWidth = 1
        //self.btnMasOpciones.layer.borderColor = UIColor.green.cgColor
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
            let objetCartItem = CartItem(name: producto.name!,price:producto.price,quantity: producto.quantity,unitVal: producto.unitVal,productId: producto.productId)
            self.productCartItems1.append(objetCartItem)
            self.tableViewCart.reloadData();
            //self.textViewNombreProduct.text = producto.Nombre!
            //self.textViewDetalle.text = producto.Descripcion!
        }
        print("entro",productCartItems.count)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btn_mas_opciones(_ sender: Any) {
        
        var MYpopupView:AlertEmailViewController!
        MYpopupView = AlertEmailViewController(nibName:"AlertEmailViewController", bundle: nil)
        self.view.alpha = 1.0
       // MYpopupView.closePopupProductos = self
        self.presentpopupViewController(popupViewController: MYpopupView, animationType: .BottomTop, completion: {() -> Void in
        })
        
        
    }
    func closeTappedDescuento()
    {
        self.dismissPopupViewController(animationType: SLpopupViewAnimationType.Fade)
        
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
    
    func registerTbaleViewCells()
    {
        let textFieldCell = UINib(nibName: "CartTableViewCell", bundle: nil);
        self.tableViewCart.register(textFieldCell, forCellReuseIdentifier: "CartTableViewCell")
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
        let productos = self.productCartItems1[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as? CartTableViewCell
        {
            cell.labelProductName?.text = productos.name!
            cell.labelPriceProducto?.text = "$"+productos.unitVal
            cell.labelImporte?.text = "$"+String(productos.price)
            cell.labelCount?.text = String(productos.quantity)
            //cell.labelPrice?.text = productos.TarifaAfiiados
            //cell.btn_mas?.tag = indexPath.row
            //cell.btn_mas?.addTarget(self, action: #selector(btnAgregarMas), for: .touchUpInside)
            return cell
        }
        //self.textViewNombreProduct.text = producto.Nombre!
        //self.textViewDetalle.text = producto.Descripcion!
        
        
        /* if let url = NSURL(string: infraestructura.nombre) {
         if let data = NSData(contentsOf: url as URL) {
         //cell?.imageView?.image = UIImage(data: data as Data)
         }
         }*/
        cell!.textLabel?.text = productos.name //
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
