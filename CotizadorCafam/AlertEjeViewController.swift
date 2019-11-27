//
//  AlertEjeViewController.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 21/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

protocol PopupDelegetEje {
    func closeTapped()
}
class AlertEjeViewController: UIViewController {
    
    @IBOutlet weak var tableViewPlaces: UITableView!
    var closePopup:PopupDelegetEje?
    var items : [InfraestructuraObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewPlaces.dataSource = self
        self.tableViewPlaces.delegate = self
        let url = "http://3.133.205.205/cafam/webservices/ws.php?request=action"
        AF.request(url, method: .post, parameters:  [
            "apiKey": "58587775f2f54284a4e8b5e92e0b611f",
            "JSON": "1",
            "method":"getInfraestructuras"
        ]).responseJSON {
            response in
            switch (response.result) {
            case .success:
                
                let json = JSON(response.value!)
                if let arr = json.arrayObject as? [[String:AnyObject]] {
                    for items in arr{
                        let name = items["Nombre"] as? String
                        let idInfraestructura = items["IDInfraestructura"] as? String
                        let infraestructura = InfraestructuraObject(nombre: name!,idInfraestructura : idInfraestructura!)
                        self.items.append(infraestructura)
                        self.tableViewPlaces.reloadData();
                    }
                    //print(self.items)
                }
                break
            case .failure:
                print(Error.self)
            }
            //self.tableView.reloadData();
        }
        
    }
    
    @IBAction func closeModalLugar(_ sender: Any) {
        
        self.closePopup?.closeTapped()
    }
    
}
extension AlertEjeViewController: UITableViewDataSource,UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
        }
        let infraestructura = self.items[indexPath.row]
       
        cell!.textLabel?.text = infraestructura.nombre
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clickInfraestructura = self.items[indexPath.row]
        var idInfraestuctura : String!
        var nombreInfra : String!
        idInfraestuctura = clickInfraestructura.idInfraestructura;
        nombreInfra = clickInfraestructura.nombre
        let preferences = UserDefaults.standard
        preferences.set(idInfraestuctura, forKey: "infra") //Bool
        preferences.set(nombreInfra, forKey: "infraNombre") //Bool
        didSave(preferences: preferences)
        print(nombreInfra!)
        self.closePopup?.closeTapped()
      
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
