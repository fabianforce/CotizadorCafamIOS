//
//  AlertEmailViewController.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 4/12/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit
protocol PopupDelegetProductosDescu {
    func closeTappedDescuento()
}
class AlertEmailViewController: UIViewController {
    var closePopupMoreOpcions:PopupDelegetProductosDescu?
    var isSelectedDescount = false;
    var is10 = false;
    var is15 = false;
    var is20 = false;
    var isAdd = false;
    var aplicarDescuento = 0;
    @IBOutlet weak var input_descuento: UITextField!
    
    @IBOutlet weak var btn_10: UIButton!
    @IBOutlet weak var btn_15: UIButton!
    @IBOutlet weak var btn_20: UIButton!
    @IBOutlet weak var btn_add: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        input_descuento.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onclick10(_ sender: UIButton) {
        
        if sender.isSelected {
            //is10 = sender.isSelected
            sender.isSelected = false
            btn_10.isSelected = false
            aplicarDescuento = 0;
            //btn_10.isSelected = false
            //is10 = false;
        }else
        {
            sender.isSelected = true
            //btn_10.isSelected = true
            btn_15.isSelected = false
            btn_20.isSelected = false
            btn_add.isSelected = false
            input_descuento.isHidden = true
            aplicarDescuento = 10;
            //is10 = true;
            //is10 = sender.isSelected
            //btn_10.isSelected = true
        }
    }
    @IBAction func onclick15(_ sender: UIButton) {
        print("aqiu")
        
        if sender.isSelected {
            print("pera" , sender.isSelected)
            sender.isSelected = false
             aplicarDescuento = 0;
            //is15 = false
            
        }else
        {
            print(sender.isSelected)
            sender.isSelected = true
            //is15 = true
            btn_10.isSelected = false
            btn_20.isSelected = false
            btn_add.isSelected = false
            input_descuento.isHidden = true
            aplicarDescuento = 15;
        }
    }
    
    @IBAction func onclick20(_ sender: UIButton) {
        if sender.isSelected {
            print("pera" , sender.isSelected)
            sender.isSelected = false
            aplicarDescuento = 0;
            //is15 = false
            
        }else
        {
            print(sender.isSelected)
            sender.isSelected = true
            //is15 = true
            btn_10.isSelected = false
            btn_15.isSelected = false
            btn_add.isSelected = false
            input_descuento.isHidden = true
            aplicarDescuento = 20;
        }
    }
    
    @IBAction func btn_add(_ sender: UIButton) {
    
    if sender.isSelected {
              print("pera" , sender.isSelected)
              sender.isSelected = false
              input_descuento.isHidden = true
              aplicarDescuento = 0;
              //is15 = false
              
          }else
          {
              print(sender.isSelected)
              sender.isSelected = true
              input_descuento.isHidden = false
              btn_10.isSelected = false
              btn_15.isSelected = false
              btn_20.isSelected = false
               aplicarDescuento = Int(self.input_descuento.text!) ?? 0
          }
    
    
    }
    
    
    @IBAction func aplicarDescuento(_ sender: Any) {
        print(aplicarDescuento)
    }
    
    
    
    
    
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */

