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
    @IBOutlet weak var labelAfiliado: UILabel!
    @IBOutlet weak var textFiledCorreo: UITextField!
    
    @IBOutlet weak var textFieldNombre: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.removeObject(forKey: "cartProduct")
        //UserDefaults.standard.removeObject(forKey: "totalCart")
        UserDefaults.standard.synchronize()
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 20))
        NombreText.leftView = paddingView
        NombreText.leftViewMode = .always
        esAfiliadoSwitch.addTarget(self, action: #selector(handleSwitch), for: .touchUpInside)
        
        // Do any additional setup after loading the view.
    }
    
    @objc fileprivate func handleSwitch(){
        if self.esAfiliadoSwitch.isOn {
            print("ON")
            self.labelAfiliado.text = "Afiliado"
        }else{
            print("False")
            self.labelAfiliado.text = "No Afiliado"
        }
    }
    
    @IBAction func ingresar(_ sender: Any) {
    UserDefaults.standard.set(self.textFiledCorreo?.text, forKey: "clienteEmail")
    UserDefaults.standard.set(self.textFieldNombre?.text, forKey: "clienteName")
    
    }
    
    
    func initUI() {
        
    }
    
}
