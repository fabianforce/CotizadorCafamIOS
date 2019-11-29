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

class MenuViewController: BaseViewController,PopupDeleget,PopupDelegetEje,PopupDelegetPrograma,PopupDelegetProductos {
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewProductos.dataSource = self
        self.tableViewProductos.delegate = self
        self.registerTbaleViewCells()
        addSlideMenuButton()
        
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
        //print(preferences.string(forKey: "infraNombre")!)
        
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
                            let idProducto = items["IDCuso"] as? String
                            let priceAfi = items["TarifaAfiiados"] as? String
                            let descripcion = items["Descripcion"] as? String
                            let horasPro = items["Horas"] as? String
                            let cupoPro = items["Cupos"] as? String
                            myRadio.append(name!)
                            let producto = ProductoObject(nombre: name!,tarifaAfi: priceAfi!,descripcion: descripcion!,horas: horasPro!,cupos: cupoPro!)
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
            print("hola mundo")
        }
    }
    
    
    
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
            cell.labelNombrePrograma?.text = productos.Nombre
            cell.labelPrice?.text = productos.TarifaAfiiados
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("row: \(indexPath.row)")
        let clickPrograma = self.productItems[indexPath.row]
        var nombrePrograma : String!
        var idPrograma : String!
        var descripcion:String!
        descripcion = clickPrograma.Descripcion
        nombrePrograma = clickPrograma.Nombre;
        
        var people = [ProductoObject]()
        people.append(ProductoObject(nombre: nombrePrograma,tarifaAfi: "fernando",descripcion: descripcion,horas: "dsa",cupos: "dasd"))
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
