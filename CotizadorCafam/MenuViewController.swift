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

class MenuViewController: UIViewController,PopupDeleget {
    
    var tableView:UITableView!
    var button:UIButton!
    
    @IBOutlet weak var btnMostratProgramas: UIButton!
    @IBOutlet var btnShowProgramas: UIView!
    var items = [InfraestructuraObject]()
    let parameters = [
        "apiKey": "58587775f2f54284a4e8b5e92e0b611f",
        "JSON": "1",
        "method":"getInfraestructuras"
    ]
    let url = "http://3.133.205.205/cafam/webservices/ws.php?request=action"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       /*
        var stackedInfoView: UIStackView!
        // show the items in table.
        // when touch the button, get json data and save items. and then show it.
        let frame: CGRect = CGRect(x: 0, y: 100, width: self.view.frame.width, height: 100)
        self.tableView = UITableView(frame: frame)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.view.addSubview(self.tableView)
        
        self.button = UIButton(frame: CGRect(x: 0, y:300, width: self.view.frame.width, height: 50))
        self.button.backgroundColor = UIColor.cyan
        self.button.setTitle("Add new Dummy", for: UIControl.State.normal)
        //self.button.addTarget(self, action: #selector(self.addDummyData), for: UIControl.Event.touchUpInside)
        self.button.addTarget(self, action: #selector(addDummyData(_:)), for: .touchUpInside)
        self.view.addSubview(self.button)

     stackedInfoView = UIStackView(arrangedSubviews: [self.button, self.tableView])
     stackedInfoView.axis = .horizontal
     stackedInfoView.spacing = 3.0
     stackedInfoView.translatesAutoresizingMaskIntoConstraints = false
     self.view.addSubview(stackedInfoView);
        

        stackedInfoView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackedInfoView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true

        */


    }
    func closeTapped() {
           self.dismissPopupViewController(animationType: SLpopupViewAnimationType.Fade)
    }
    
    
    @IBAction func btnOpenModalPorgramas(_ sender: Any) {
     
        var MYpopupView:AlertInfraViewController!
               MYpopupView = AlertInfraViewController(nibName:"AlertInfraViewController", bundle: nil)
               self.view.alpha = 1.0
               MYpopupView.closePopup = self
               self.presentpopupViewController(popupViewController: MYpopupView, animationType: .BottomTop, completion: {() -> Void in
               })

        //self.present
        
    }
    
    @objc func addDummyData(_ sender: UIButton) {
       /* RestApiManager.sharedInstance.getProgramas { (json:JSON) in
            // return json from API
            if let results = json["results"].array { // get results data from json
                print(results)
                for entry in results { // save data to items.
                    self.items.append(InfraestructuraObject(json: entry))
                }
                
                DispatchQueue.main.async { // back to the main que and reload table
                    self.tableView.reloadData()
                }
            }
        }*/
        AF.request(url, method: .post, parameters:  [
         "apiKey": "58587775f2f54284a4e8b5e92e0b611f",
         "JSON": "1",
         "method":"getInfraestructuras"
         ]).responseJSON {
         response in
         switch (response.result) {
         case .success:
         //print(response)
         print("Request: \(String(describing: response.request))")   // original url request
         print("Response: \(String(describing: response.response))") // http url response
         print("Result: \(response.result)")
         let myJson: JSON = JSON(response.value!)
         print("Result: \(myJson)")
         self.items.append(InfraestructuraObject(json: myJson))
         //for entry in json {
         
         //self.items.append(InfraestructuraObject(json: entry))
         //}
         
         break
         case .failure:
         print(Error.self)
         }
         self.tableView.reloadData();
         }
        
    }
    
}
extension MenuViewController: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.items.count)
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "CELL")
        }
        let infraestructura = self.items[indexPath.row]
        if let url = NSURL(string: infraestructura.nombre) {
            if let data = NSData(contentsOf: url as URL) {
                //cell?.imageView?.image = UIImage(data: data as Data)
            }
        }
        cell!.textLabel?.text = infraestructura.nombre
        return cell!
    }
}
