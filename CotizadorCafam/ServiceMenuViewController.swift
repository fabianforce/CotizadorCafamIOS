//
//  ServiceMenuViewController.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 22/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit

class ServiceMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      let logoutBarButtonItem = UIBarButtonItem(title: "Atras", style: .done, target: self, action: #selector(logoutUser))
      self.navigationItem.leftBarButtonItem  = logoutBarButtonItem
    }

    @objc func logoutUser(){
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SoapView") as? SoapViewController
                              self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func abrirCotizador(_ sender: Any) {
    
    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "listProducts") as? MenuViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        self.navigationController?.navigationBar.backItem?.title = "Atras"
    
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
