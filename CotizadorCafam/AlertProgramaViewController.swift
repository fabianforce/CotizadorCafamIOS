//
//  AlertProgramaViewController.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 21/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

protocol PopupDelegetPrograma {
    func closeTapped2()
}
class AlertProgramaViewController: UIViewController {
    var closePopup2:PopupDelegetPrograma?
    let preferences = UserDefaults.standard
    @IBOutlet weak var tableViewProgramas: UITableView!
     var items : [ProgramaObject] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewProgramas.dataSource = self
        self.tableViewProgramas.delegate = self
        let idEje = preferences.string(forKey: "idEje")!
        print("hola" , idEje)
        
        let url = "http://3.133.205.205/cafam/webservices/ws.php?request=action"
        AF.request(url, method: .post, parameters:  [
            "apiKey": "58587775f2f54284a4e8b5e92e0b611f",
            "JSON": "1",
            "method":"getProgramasPorEje",
            "eje":idEje
        ]).responseJSON {
            response in
            switch (response.result) {
            case .success:
                
                let json = JSON(response.value!)
                if let arr = json.arrayObject as? [[String:AnyObject]] {
                    for items in arr{
                        let name = items["Nombre"] as? String
                        let idPrograma = items["IDPrograma"] as? String
                        let programa = ProgramaObject(nombre: name!,idPrograma : idPrograma!)
                        self.items.append(programa)
                        self.tableViewProgramas.reloadData();
                        //self.items.append(infraestructura)
                        //self.tableViewPlaces.reloadData();
                    }
                    //print(self.items)
                }
                break
            case .failure:
                print(Error.self)
            }
            //self.tableView.reloadData();
        }
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeModalPrograma(_ sender: Any) {
        
        self.closePopup2?.closeTapped2()
    }
    
    
}
extension AlertProgramaViewController: UITableViewDataSource,UITableViewDelegate
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
        cell!.textLabel?.text = ejeFormacion.Nombre //
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("row: \(indexPath.row)")
        let clickPrograma = self.items[indexPath.row]
        var nombrePrograma : String!
        var idPrograma : String!
        
        nombrePrograma = clickPrograma.Nombre;
        idPrograma = clickPrograma.idPrograma
        
        let preferences = UserDefaults.standard
        preferences.set(nombrePrograma, forKey: "nombrePrograma")
        preferences.set(idPrograma, forKey: "idPrograma")
        //preferences.set(nombreInfra, forKey: "infraNombre") //Bool
        didSave(preferences: preferences)
        print(nombrePrograma!)
        self.closePopup2?.closeTapped2()
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


