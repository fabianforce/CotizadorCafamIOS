//
//  SliderMenuViewController.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 29/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SCLAlertView
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
    var total = 0;
    struct RequestFormat: Encodable {
        var IDCuso:String
        var countUnitario:Int
        var tarifaAfiiados:String
        var nombre:String
        var horas:String
        var cupo:String
        var sumUnitario:Double
    }
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
        var totalString = preferences.string(forKey: "totalCart")
        if totalString?.count == 0 {
            totalString = "0";
        }
        let dd = totalString
        let entero = Int(dd!)
        self.labelTotal?.text = "$" + entero!.formattedWithSeparator
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
            let objetCartItem = CartItem(name: producto.name!,price:producto.price!,quantity: producto.quantity!,unitVal: producto.unitVal!,productId: producto.productId!)
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
    
    @IBAction func btn_enviar_cotizacion(_ sender: Any) {
        var newArray = [RequestFormat]()
        print(self.productCartItems1[0].name!)
        print("dario =>", JSON.rawString(JSON(self.productCartItems1)))
        print( "name :\(self.productCartItems1) \n company \(self.productCartItems1)")
        let checker = JSONSerialization.isValidJSONObject(self.productCartItems1)
        print("SI PUEDO ==>" , checker)
        /*"cursos":[
         "IDCuso":"2",
         "countUnitario":"34",
         "tarifaAfiiados":"123123"
         ]*/
        let encondeA = JSONEncoder()
        //let result = try encondeA.encode(self.productCartItems1)
        for (index, element) in self.productCartItems1.enumerated() {
            
            let requestOject = RequestFormat(IDCuso:"34",
                                             countUnitario:self.productCartItems1[index].quantity,
                                             tarifaAfiiados:self.productCartItems1[index].unitVal, nombre: productCartItems1[index].name,horas: "4", cupo: "2",sumUnitario:productCartItems1[index].price )
            newArray.append(requestOject)
        }
        do {
            let result = try encondeA.encode(newArray)
            if let resultStting = String(data: result, encoding: .utf8)
            {
                print(resultStting)
                let url = "http://3.133.205.205/cafam/webservices/ws.php?request=action"
                     AF.request(url, method: .post, parameters:  [
                         "apiKey": "58587775f2f54284a4e8b5e92e0b611f",
                         "method":"setCotizacion",
                         "IDUsuario":1,
                         "Estado":"1",
                         "CorreoJefe":"prueba5@cafam.com.co",//descuento
                         "CorreoCliente":UserDefaults.standard.string(forKey: "clienteEmail")!,
                         "Descuento":"10",
                         "Pagado":"si",
                         "cursos":resultStting,
                         "IDCliente":1,
                         "ValorTotal":String(total),
                         "FechaCotizacion":"05-12-2019",
                         "correo":"prueba5@cafam.com.co",
                         "nombreCliente":UserDefaults.standard.string(forKey: "clienteName")!,
                         "numDocumento":"8709787",
                         "servicio":"si",
                         "esAfiliado":"si",
                         "tipoAfiliado":"afiliado",
                         "tipoEvento":"ingles",
                         "NomUsuario":"Prueba 5",
                         "mailUsuario":"prueba5@cafam.com.co",
                         "lugar":"Bogota",
                         
                     ]).responseJSON {
                         response in
                         switch (response.result) {
                         case .success:
                             SCLAlertView().showInfo("Correcto", subTitle: "La cotización se guardo correctamente")
                             print("respuesta==>" , response.value!)
                             let json = JSON(response.value!)
                             if let arr = json.arrayObject as? [[String:AnyObject]] {
                                 
                             }
                             self.productCartItems1.removeAll();
                             self.tableViewCart.reloadData();
                             self.labelTotal?.text = "$0"
                             UserDefaults.standard.removeObject(forKey: "cartProduct")
                             break
                         case .failure:
                             print(Error.self)
                         }
                         //self.tableViewProductos.reloadData();
                     }
            }
        } catch  {
            print("error")
        }
        
        
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
    @objc func btnAddCartItem(_ sender: UIButton) {
        
        let productos = self.productCartItems1[sender.tag]
        productos.quantity = productos.quantity + 1;
        let myString = productos.unitVal!
        let myFloat = (myString as NSString).doubleValue
        productos.price = productos.price+myFloat;
        let objetCartItem = CartItem(name: productos.name!,price:productos.price!,quantity: productos.quantity!,unitVal: productos.unitVal!,productId: productos.productId!)
        self.productCartItems1[sender.tag] = objetCartItem
        self.tableViewCart.reloadData();
        let preferences = UserDefaults.standard
        let totalString = preferences.string(forKey: "totalCart")
        let totalInt = Int(totalString!)
        let unitarioString = productos.unitVal
        let unitarioInt = Int(unitarioString!)
        total = totalInt! + unitarioInt!
        let sendCartItems = NSKeyedArchiver.archivedData(withRootObject:  self.productCartItems1)
        UserDefaults.standard.set(sendCartItems, forKey: "cartProduct")
        preferences.set(total, forKey: "totalCart")
        
        self.labelTotal?.text = "$" + total.formattedWithSeparator
        
    }
    @objc func btnLessCartItem(_ sender: UIButton) {
        print(sender.tag)
        let productos = self.productCartItems1[sender.tag]
        let preferences = UserDefaults.standard
        let totalString = preferences.string(forKey: "totalCart")
        let totalInt = Int(totalString!)
        let unitarioString = productos.unitVal
        let unitarioInt = Int(unitarioString!)
        total = totalInt! - unitarioInt!
        
        productos.quantity = productos.quantity - 1;
        let myString = productos.unitVal!
        let myFloat = (myString as NSString).doubleValue
        productos.price = productos.price-myFloat;
        if(productos.quantity == 0)
        {
            self.productCartItems1.remove(at: sender.tag)
            self.tableViewCart.reloadData();
            
        }else
        {
            let objetCartItem = CartItem(name: productos.name!,price:productos.price!,quantity: productos.quantity!,unitVal: productos.unitVal!,productId: productos.productId!)
            self.productCartItems1[sender.tag] = objetCartItem
            self.tableViewCart.reloadData();
        }
        
        
        let sendCartItems = NSKeyedArchiver.archivedData(withRootObject:  self.productCartItems1)
        UserDefaults.standard.set(sendCartItems, forKey: "cartProduct")
        preferences.set(total, forKey: "totalCart")
        self.labelTotal?.text = "$" + total.formattedWithSeparator
        
    }
}

extension Int{
        var formattedWithSeparator1: String {
            return Formatter.withSeparator.string(for: self) ?? ","
        }
    }
extension Formatter {
    static let withSeparator1: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
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
            cell.btn_add?.tag = indexPath.row
            cell.btn_add?.addTarget(self, action: #selector(btnAddCartItem), for: .touchUpInside)
            cell.btn_less?.tag = indexPath.row
            cell.btn_less?.addTarget(self, action: #selector(btnLessCartItem), for: .touchUpInside)
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
