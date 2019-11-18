//
//  SoapViewController.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 18/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit

class SoapViewController: UIViewController {
    
    @IBOutlet weak var NombreText: UITextField!
    @IBOutlet weak var esAfiliadoSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        NombreText.leftView = paddingView
        NombreText.leftViewMode = .always
        esAfiliadoSwitch.addTarget(self, action: #selector(handleSwitch), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    @objc fileprivate func handleSwitch(){
        if self.esAfiliadoSwitch.isOn {
            print("ON")
        }else{
            print("False")
        }
    }
    func initUI() {
        
    }
    
}
