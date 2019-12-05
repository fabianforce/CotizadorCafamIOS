//
//  MenuViewController.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 19/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MenuViewController: UIViewController,PopupDeleget,PopupDelegetEje,PopupDelegetPrograma,PopupDelegetProductos,SlideMenuDelegate{
    
    
    var tableView:UITableView!
    @IBOutlet weak var tableViewProductos: UITableView!
    var button:UIButton!
    @IBOutlet weak var textViewInfra: UITextField!
    @IBOutlet weak var textViewEje: UITextField!
    @IBOutlet weak var textViewPrograma: UITextField!
    @IBOutlet weak var btnMostratProgramas: UIButton!
    @IBOutlet var btnShowProgramas: UIView!
    var idEje = "";
    var idPrograma = ""
    var productItems : [ProductoObject] = []
    var cartItems: [CartItem] = []
    var total = 0;
    var productTotal = 0.0;
    var quantityByProduct = 0;
    var productCartItemsPrueba = Data() as? [CartItem]
    var getProduct = NSData() as? NSData;
    var totalCartMemoria = String()
    
    var exite = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewProductos.dataSource = self
        self.tableViewProductos.delegate = self
        self.registerTbaleViewCells()
        addSlideMenuButton()
        getProduct = UserDefaults.standard.object(forKey: "cartProduct") as? NSData;
        print("hptaa" , getProduct?.length)
        
        //totalCartMemoria = UserDefaults.standard.string(forKey: "totalCart")!
        
        /*productCartItemsPrueba = NSKeyedUnarchiver.unarchiveObject(with: getProduct as! Data) as? [CartItem]
         print("hptaa1" , productCartItemsPrueba!.count)*/
        
        
    }
    func closeTapped() {
        self.dismissPopupViewController(animationType: SLpopupViewAnimationType.Fade)
        let preferences = UserDefaults.standard
        print("daio te amo")
        if preferences.string(forKey: "infra") != nil{
            let access_token = preferences.string(forKey: "infra")
            let infraNombre = preferences.string(forKey: "infraNombre")
            self.textViewInfra.text = infraNombre!
            //print(preferences.string(forKey: "infraNombre")!)
        } else {
            
            
        }
        
    }
    func closeTapped1() {
        self.dismissPopupViewController(animationType: SLpopupViewAnimationType.Fade)
        let preferences = UserDefaults.standard
        print("daio te amo")
        if preferences.string(forKey: "ejeNombre") != nil{
            let ejeNombre = preferences.string(forKey: "ejeNombre")
            idEje = preferences.string(forKey: "idEje")!
            self.textViewEje.text = ejeNombre!
            //print(preferences.string(forKey: "infraNombre")!)
        } else {
            
        }
    }
    //** programas alert close **/
    func closeTapped2() {
        self.dismissPopupViewController(animationType: SLpopupViewAnimationType.Fade)
        let preferences = UserDefaults.standard
        if preferences.string(forKey: "nombrePrograma") != nil{
            let programaNombre = preferences.string(forKey: "nombrePrograma")
            idPrograma = preferences.string(forKey: "IDPrograma")!
            self.textViewPrograma.text = programaNombre
            print("hptaaaaa1",idPrograma)
            let url = "http://3.133.205.205/cafam/webservices/ws.php?request=action"
            AF.request(url, method: .post, parameters:  [
                "apiKey": "58587775f2f54284a4e8b5e92e0b611f",
                "JSON": "1",
                "method":"getCursosPorEje",
                "eje":idEje,
                "programa":idPrograma,
                "infraestructura":"1"
            ]).responseJSON {
                response in
                switch (response.result) {
                case .success:
                    let json = JSON(response.value!)
                    if let arr = json.arrayObject as? [[String:AnyObject]] {
                        var myRadio = [String]()
                        
                        for items in arr{
                            //print(items)
                            let name = items["Nombre"] as? String
                            let idProducto1 = items["IDCuso"] as? String
                            print(idProducto1)
                            let priceAfi = items["TarifaAfiiados"] as? String
                            let descripcion = items["Descripcion"] as? String
                            let horasPro = items["Horas"] as? String
                            let cupoPro = items["Cupos"] as? String
                            myRadio.append(name!)
                            let producto = ProductoObject(nombre: name!,tarifaAfi: priceAfi!,descripcion: descripcion!,horas: horasPro!,cupos: cupoPro!,IDCuso:idProducto1!)
                            self.productItems.append(producto)
                            self.tableViewProductos.reloadData();
                            
                        }
                    }
                    break
                case .failure:
                    print(Error.self)
                }
                //self.tableViewProductos.reloadData();
            }
            
        } else {
            
        }
    }
    
    @IBAction func btnOpenModalPorgramas(_ sender: Any) {
        
        
        //EJES DE FORMACION
        var MYpopupView:AlertInfraViewController!
        MYpopupView = AlertInfraViewController(nibName:"AlertInfraViewController", bundle: nil)
        self.view.alpha = 1.0
        MYpopupView.closePopup1 = self
        self.presentpopupViewController(popupViewController: MYpopupView, animationType: .BottomTop, completion: {() -> Void in
        })
        
        //self.present
        
    }
    
    
    func closeTappedProductos()
    {
        self.dismissPopupViewController(animationType: SLpopupViewAnimationType.Fade)
        
    }
    
    @IBAction func btnOpenModalInfra(_ sender: Any) {
        
        var MYpopupView:AlertEjeViewController!
        MYpopupView = AlertEjeViewController(nibName:"AlertEjeViewController", bundle: nil)
        self.view.alpha = 1.0
        MYpopupView.closePopup = self
        self.presentpopupViewController(popupViewController: MYpopupView, animationType: .BottomTop, completion: {() -> Void in
        })
    }
    
    func registerTbaleViewCells()
    {
        let textFieldCell = UINib(nibName: "CustomTableViewCell", bundle: nil);
        self.tableViewProductos.register(textFieldCell, forCellReuseIdentifier: "CustomTableViewCell")
    }
    func convertDoubleToCurrency(amount: Double) -> String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        return numberFormatter.string(from: NSNumber(value: amount))!
    }
    
    @IBAction func btnShowModalProgramas(_ sender: Any) {
        
        self.productItems = []
        var MYpopupView:AlertProgramaViewController!
        MYpopupView = AlertProgramaViewController(nibName:"AlertProgramaViewController", bundle: nil)
        self.view.alpha = 1.0
        MYpopupView.closePopup2 = self
        self.presentpopupViewController(popupViewController: MYpopupView, animationType: .BottomTop, completion: {() -> Void in
            print("hola mundo")
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if (self.isBeingDismissed || self.isMovingFromParent) {
            print("hola mundo pgl")
        }
    }
    
    //SE PASO TODO LO DE BASEVIEWCONTROLLER EN MENUVIEWCONTROLLER PARA HACER EL getproduct DENTRO DE slideMenuItemSelectArIndex MIRAR luego como pasar a como estaba para no dejar mucho codigo aqui!!--
    
    func slideMenuItemSelectArIndex(_ index: Int32) {
        getProduct = UserDefaults.standard.object(forKey: "cartProduct") as? NSData;
        print("hola mundoxxxxx");
        self.navigationItem.hidesBackButton = false
        //getProduct = UserDefaults.standard.object(forKey: "cartProduct") as? NSData;
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        switch(index){
        case 0:
            print("Home\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("Home")
            
            break
        case 1:
            print("Play\n", terminator: "")
            
            self.openViewControllerBasedOnIdentifier("PlayVC")
            
            break
        default:
            print("default\n", terminator: "")
            /*productCartItemsPrueba = NSKeyedUnarchiver.unarchiveObject(with: getProduct! as Data) as? [CartItem]*/
        }
    }
    
    func openViewControllerBasedOnIdentifier(_ strIdentifier:String){
        let destViewController : UIViewController = self.storyboard!.instantiateViewController(withIdentifier: strIdentifier)
        
        let topViewController : UIViewController = self.navigationController!.topViewController!
        
        if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
            print("Same VC")
        } else {
            self.navigationController!.pushViewController(destViewController, animated: true)
        }
    }
    
    func addSlideMenuButton(){
        let image = UIImage(named: "Checkbox.png") as UIImage?
        let btnShowMenu = UIButton(type: UIButton.ButtonType.custom) as UIButton
        btnShowMenu.setImage(image, for: UIControl.State.normal)
        btnShowMenu.imageView?.contentMode = .scaleAspectFit
        btnShowMenu.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        btnShowMenu.addTarget(self, action: #selector(onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.rightBarButtonItem = customBarItem;
        
    }
    
    func defaultMenuImage() -> UIImageView {
        //var defaultMenuImage = UIImage()
        let imgView = UIImageView()
        imgView.frame = CGRect(x: 0, y: 2, width: 30, height: 30)
        imgView.image = UIImage(named: "yourimagename")//Assign image to ImageView
        
       /* UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
        
        UIColor.black.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
        
        UIColor.white.setFill()
        UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
        UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
        
        defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()*/
        
        return imgView;
    }
    
    @objc func onSlideMenuButtonPressed(_ sender : UIButton){
        print("open ")
        self.navigationItem.hidesBackButton = true
        if (sender.tag == 10)
        {
            // To Hide Menu If it already there
            self.slideMenuItemSelectArIndex(-1);
            
            sender.tag = 0;
            
            let viewMenuBack : UIView = view.subviews.last!
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frameMenu : CGRect = viewMenuBack.frame
                frameMenu.origin.x = 1 * UIScreen.main.bounds.size.width
                viewMenuBack.frame = frameMenu
                viewMenuBack.layoutIfNeeded()
                viewMenuBack.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                viewMenuBack.removeFromSuperview()
            })
            
            return
        }
        
        sender.isEnabled = false
        sender.tag = 10
        
        let menuVC : SliderMenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "SliderMenuViewController") as! SliderMenuViewController
        //menuVC.btnMenu = sender
        //menuVC.delegate = self
        self.view.addSubview(menuVC.view)
        self.addChild(menuVC)
        menuVC.view.layoutIfNeeded()
        
        
        menuVC.view.frame=CGRect(x: 0 + UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            sender.isEnabled = true
        }, completion:nil)
    }
    
    
    
}
extension Int{
        var formattedWithSeparator: String {
            return Formatter.withSeparator.string(for: self) ?? ","
        }
    }
extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension MenuViewController: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
        }
        let productos = self.productItems[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell") as? CustomTableViewCell
        {
            let currencyFormatter = NumberFormatter()
            currencyFormatter.usesGroupingSeparator = true
            currencyFormatter.numberStyle = .currency
            // localize to your grouping and decimal separator
            currencyFormatter.locale = Locale.current

            // We'll force unwrap with the !, if you've got defined data you may need more error checking
            let myString1 = productos.TarifaAfiiados!
            let myInt1 = Int(myString1)
            let priceString = currencyFormatter.string(from:myInt1 as! NSNumber)!
            print(priceString)
            //withSeparator.string(for: self) ?? ""
            cell.labelNombrePrograma?.text = productos.Nombre
            cell.labelPrice?.text = "$"+myInt1!.formattedWithSeparator
            cell.btn_mas?.tag = indexPath.row
            cell.btn_mes?.tag = indexPath.row
            cell.btn_mes?.addTarget(self, action: #selector(btnQuitar), for: .touchUpInside)
            cell.btn_mas?.addTarget(self, action: #selector(btnAgregarMas), for: .touchUpInside)
            return cell
        }
        
        /*if let url = NSURL(string: productos.nombre) {
         if let data = NSData(contentsOf: url as URL) {
         //cell?.imageView?.image = UIImage(data: data as Data)
         }
         }*/
        cell!.textLabel?.text = productos.Nombre
        return cell!
    }
    @objc func btnQuitar(_ sender: UIButton) {
        if(getProduct==nil)
        {
            var indice = 0;
            var existeEnQuitar = false;
            let producto = self.productItems[sender.tag]
            let tarifaAfiliados = (producto.TarifaAfiiados as NSString).integerValue
            total = total - tarifaAfiliados;
            if(total < 0)
            {
                total = 0;
            }
            if(cartItems.count > 0)
            {
                for (index, element) in cartItems.enumerated() {
                    print(index, ":", cartItems[index].productId!)
                    if(cartItems[index].productId! == producto.IDCuso!)
                    {
                        existeEnQuitar = true;
                        indice = index
                    }
                }
                if (existeEnQuitar)
                {
                    if cartItems[indice].quantity! == 1 {
                        print("ESTA EN 0")
                        cartItems.remove(at: indice)
                    }else
                    {
                        productTotal = cartItems[indice].price - (producto.TarifaAfiiados as NSString).doubleValue
                        quantityByProduct = cartItems[indice].quantity - 1;
                        let objetCartItem = CartItem(name: producto.Nombre!,price: productTotal ,quantity: quantityByProduct,unitVal: producto.TarifaAfiiados,productId: producto.IDCuso)
                        cartItems[indice] = objetCartItem
                    }
                }
                
            }else
            {
                print("CARRITO VACIO")
            }
            let preferences = UserDefaults.standard
            let sendCartItems = NSKeyedArchiver.archivedData(withRootObject: cartItems)
            preferences.set(total, forKey: "totalCart")
            preferences.set(sendCartItems, forKey: "cartProduct")
        }else
        {
            productCartItemsPrueba = NSKeyedUnarchiver.unarchiveObject(with: getProduct as! Data) as? [CartItem]
            print("hptaa1" , productCartItemsPrueba!.count)
            cartItems = productCartItemsPrueba!
            let totalCartString = UserDefaults.standard.string(forKey: "totalCart")
            let totalCartInt = Int(totalCartString!)
            total = totalCartInt!
            var indice = 0;
            var existeEnQuitar = false;
            let producto = self.productItems[sender.tag]
            let tarifaAfiliados = (producto.TarifaAfiiados as NSString).integerValue
            total = total - tarifaAfiliados;
            if(total < 0)
            {
                total = 0;
            }
            if(cartItems.count > 0)
            {
                for (index, element) in cartItems.enumerated() {
                    print(index, ":", cartItems[index].productId!)
                    if(cartItems[index].productId! == producto.IDCuso!)
                    {
                        existeEnQuitar = true;
                        indice = index
                    }
                }
                if (existeEnQuitar)
                {
                    if cartItems[indice].quantity! == 1 {
                        print("ESTA EN 0")
                        cartItems.remove(at: indice)
                    }else
                    {
                        productTotal = cartItems[indice].price - (producto.TarifaAfiiados as NSString).doubleValue
                        quantityByProduct = cartItems[indice].quantity - 1;
                        let objetCartItem = CartItem(name: producto.Nombre!,price: productTotal ,quantity: quantityByProduct,unitVal: producto.TarifaAfiiados,productId: producto.IDCuso)
                        cartItems[indice] = objetCartItem
                    }
                }
                
            }else
            {
                print("CARRITO VACIO")
            }
            let preferences = UserDefaults.standard
            let sendCartItems = NSKeyedArchiver.archivedData(withRootObject: cartItems)
            preferences.set(total, forKey: "totalCart")
            preferences.set(sendCartItems, forKey: "cartProduct")
            
        }
        getProduct = UserDefaults.standard.object(forKey: "cartProduct") as? NSData;
        
    }
    
    @objc func btnAgregarMas(_ sender: UIButton) {
        if(getProduct==nil)
        {
            var indice = 0;
            let productos = self.productItems[sender.tag]
            let tarifaAfiliados = (productos.TarifaAfiiados as NSString).integerValue
            total = total + tarifaAfiliados;
            let preferences = UserDefaults.standard
            preferences.set(total, forKey: "totalCart")
            productTotal = (productos.TarifaAfiiados as NSString).doubleValue
            print("FERNANDO",productos.IDCuso!)
            if cartItems.count > 0 {
                //productTotal = 0;
                for (index, element) in cartItems.enumerated() {
                    print(index, ":", cartItems[index].productId!)
                    if(cartItems[index].productId! == productos.IDCuso!)
                    {
                        //print("ESTA")
                        exite = true;
                        indice = index
                    }
                }
            }
            
            if (exite)
            {
                print("EXISTE")
                productTotal = productTotal + cartItems[indice].price
                quantityByProduct = 1 + cartItems[indice].quantity
                let objetCartItem = CartItem(name: productos.Nombre!,price: productTotal ,quantity: quantityByProduct,unitVal: productos.TarifaAfiiados,productId: productos.IDCuso)
                cartItems[indice] = objetCartItem
                
            }else
            {
                quantityByProduct  = 1;
                let objetCartItem = CartItem(name: productos.Nombre!,price: productTotal,quantity:quantityByProduct,unitVal:productos.TarifaAfiiados!,productId: productos.IDCuso)
                cartItems.append(objetCartItem)
            }
            
            print(cartItems.count)
            let sendCartItems = NSKeyedArchiver.archivedData(withRootObject: cartItems)
            UserDefaults.standard.set(sendCartItems, forKey: "cartProduct")
            exite = false;
            
        }else
        {
            print("ya no es null")
            productCartItemsPrueba = NSKeyedUnarchiver.unarchiveObject(with: getProduct as! Data) as? [CartItem]
            print("hptaa1" , productCartItemsPrueba!.count)
            cartItems = productCartItemsPrueba!
            let totalCartString = UserDefaults.standard.string(forKey: "totalCart")
            let totalCartInt = Int(totalCartString!)
            total = totalCartInt!
            var indice = 0;
            let productos = self.productItems[sender.tag]
            let tarifaAfiliados = (productos.TarifaAfiiados as NSString).integerValue
            total = total + tarifaAfiliados;
            let preferences = UserDefaults.standard
            preferences.set(total, forKey: "totalCart")
            productTotal = (productos.TarifaAfiiados as NSString).doubleValue
            print("FERNANDO",productos.IDCuso!)
            if cartItems.count > 0 {
                //productTotal = 0;
                for (index, element) in cartItems.enumerated() {
                    print(index, ":", cartItems[index].productId!)
                    if(cartItems[index].productId! == productos.IDCuso!)
                    {
                        //print("ESTA")
                        exite = true;
                        indice = index
                    }
                }
            }
            
            if (exite)
            {
                print("EXISTE")
                productTotal = productTotal + cartItems[indice].price
                quantityByProduct = 1 + cartItems[indice].quantity
                let objetCartItem = CartItem(name: productos.Nombre!,price: productTotal ,quantity: quantityByProduct,unitVal: productos.TarifaAfiiados,productId: productos.IDCuso)
                cartItems[indice] = objetCartItem
                
            }else
            {
                quantityByProduct  = 1;
                let objetCartItem = CartItem(name: productos.Nombre!,price: productTotal,quantity:quantityByProduct,unitVal:productos.TarifaAfiiados!,productId: productos.IDCuso)
                cartItems.append(objetCartItem)
            }
            print("cantidad ===> ", cartItems[indice].quantity)
            print(cartItems.count)
            let sendCartItems = NSKeyedArchiver.archivedData(withRootObject: cartItems)
            UserDefaults.standard.set(sendCartItems, forKey: "cartProduct")
            exite = false;
            
        }
        getProduct = UserDefaults.standard.object(forKey: "cartProduct") as? NSData;
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("row: \(indexPath.row)")
        let clickPrograma = self.productItems[indexPath.row]
        var nombrePrograma : String!
        var idPrograma : String!
        var descripcion:String!
        var idCudo:String!
        descripcion = clickPrograma.Descripcion
        nombrePrograma = clickPrograma.Nombre;
        idCudo = clickPrograma.IDCuso
        
        var people = [ProductoObject]()
        //pasar informacion real
        people.append(ProductoObject(nombre: nombrePrograma,tarifaAfi: "fernando",descripcion: descripcion,horas: "dsa",cupos: "dasd",IDCuso: idCudo))
        let placesData = NSKeyedArchiver.archivedData(withRootObject: people)
        UserDefaults.standard.set(placesData, forKey: "detalleProducto")
        
        var MYpopupView:AlertInfoProgramaViewController!
        MYpopupView = AlertInfoProgramaViewController(nibName:"AlertInfoProgramaViewController", bundle: nil)
        self.view.alpha = 1.0
        MYpopupView.closePopupProductos = self
        self.presentpopupViewController(popupViewController: MYpopupView, animationType: .BottomTop, completion: {() -> Void in
        })
        
        //preferences.set(people, forKey: "detalleProducto")
        //preferences.set(idPrograma, forKey: "IDPrograma")
        //preferences.set(nombreInfra, forKey: "infraNombre") //Bool
        //didSave(preferences: preferences)
        print(nombrePrograma!)
        //self.closePopup2?.closeTapped2()
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
