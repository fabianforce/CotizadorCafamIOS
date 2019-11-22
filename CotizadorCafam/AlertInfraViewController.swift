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
    func closeTapped()
}

class AlertInfraViewController: UIViewController {
    
    @IBOutlet weak var tableViewEjes: UITableView!
    @IBOutlet weak var Button: UIButton!
    var items = [String]()
    var closePopup:PopupDeleget?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewEjes.dataSource = self
        self.tableViewEjes.delegate = self
        let url = "http://3.133.205.205/cafam/webservices/ws.php?request=action"
        AF.request(url, method: .post, parameters:  [
            "apiKey": "58587775f2f54284a4e8b5e92e0b611f",
            "JSON": "1",
            "method":"getInfraestructuras"
        ]).responseJSON {
            response in
            switch (response.result) {
            case .success:
                //print(response)
                //print("Request: \(String(describing: response.request))")   // original url request
                //print("Response: \(String(describing: response.response))") // http url response
                //print("Result: \(response.result)")
                let myJson: JSON = JSON(response.value!)
                //print("Result: \(myJson)")
                
                let json = JSON(response.value!)
                if let arr = json.arrayObject as? [[String:AnyObject]] {
                    var myRadio = [String]()
                    
                    for items in arr{
                        let name = items["Nombre"] as? String
                        myRadio.append(name!)
                        self.items.append(name!)
                        self.tableViewEjes.reloadData();
                    }
                    print(self.items)
                    //self.radio.append(myRadio)
                    //self.tableView.reloadData()
                    
                }
             
                //ﬁlet status = json["Nombre"].stringValue
               // print(json);
                
                //self.items.append(InfraestructuraObject(json: myJson))
                //for entry in json {
                
                //self.items.append(InfraestructuraObject(json: entry))
                //}
                
                break
            case .failure:
                print(Error.self)
            }
            //self.tableView.reloadData();
        }
        
    }
    
    
    @IBAction func closeModal(_ sender: Any) {
        self.closePopup?.closeTapped()
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
       let infraestructura = self.items[indexPath.row]
      /* if let url = NSURL(string: infraestructura.nombre) {
           if let data = NSData(contentsOf: url as URL) {
               //cell?.imageView?.image = UIImage(data: data as Data)
           }
       }*/
       cell!.textLabel?.text = self.items[indexPath.row]; //
       return cell!
   }
    
}

