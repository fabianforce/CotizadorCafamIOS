//
//  AlertInfraViewController.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 21/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
protocol PopupDeleget {
    func closeTapped1()
}

class AlertInfraViewController: UIViewController {
    // encargada del modal EJES DE FORMACION ME CONFUNDI DE NOMBRE LUEGO CAMBIAR
    @IBOutlet weak var tableViewEjes: UITableView!
    @IBOutlet weak var Button: UIButton!
    var items : [ejeFormacionObject] = []
    var closePopup1:PopupDeleget?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewEjes.dataSource = self
        self.tableViewEjes.delegate = self
        let url = "http://3.133.205.205/cafam/webservices/ws.php?request=action"
        AF.request(url, method: .post, parameters:  [
            "apiKey": "58587775f2f54284a4e8b5e92e0b611f",
            "JSON": "1",
            "method":"getEjeFormacion"
        ]).responseJSON {
            response in
            switch (response.result) {
            case .success:                
                let json = JSON(response.value!)
                if let arr = json.arrayObject as? [[String:AnyObject]] {
                    var myRadio = [String]()
                    
                    for items in arr{
                        print(items)
                        let name = items["Nombre"] as? String
                        let idEje = items["IDEjeFormacion"] as? String
                        myRadio.append(name!)
                        let mercury = ejeFormacionObject(nombre: name!,idEjeFormacion: idEje!)
                        self.items.append(mercury)
                        self.tableViewEjes.reloadData();
                    }
                    print(self.items)
                }
                break
            case .failure:
                print(Error.self)
            }
            //self.tableView.reloadData();
        }
        
    }
    
    
    @IBAction func closeModal(_ sender: Any) {
        self.closePopup1?.closeTapped1()
    }
    
}
extension AlertInfraViewController: UITableViewDataSource,UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
        }
        let ejeFormacion = self.items[indexPath.row]
        /* if let url = NSURL(string: infraestructura.nombre) {
         if let data = NSData(contentsOf: url as URL) {
         //cell?.imageView?.image = UIImage(data: data as Data)
         }
         }*/
        cell!.textLabel?.text = ejeFormacion.nombre //
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("row: \(indexPath.row)")
        let clickEje = self.items[indexPath.row]
        var nombreEje : String!
        var nombreInfra : String!
        var idEje : String!
        
        nombreEje = clickEje.nombre;
        idEje = clickEje.IDEje
        
        let preferences = UserDefaults.standard
        preferences.set(nombreEje, forKey: "ejeNombre")
        preferences.set(idEje, forKey: "idEje")
        //preferences.set(nombreInfra, forKey: "infraNombre") //Bool
        didSave(preferences: preferences)
        print(nombreEje!)
        self.closePopup1?.closeTapped1()
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

