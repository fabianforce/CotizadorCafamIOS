//
//  AlertEjeViewController.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 21/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit
protocol PopupDelegetEje {
    func closeTapped()
}
class AlertEjeViewController: UIViewController {
    
    var closePopup:PopupDelegetEje?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeModalLugar(_ sender: Any) {
        
        self.closePopup?.closeTapped()
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
