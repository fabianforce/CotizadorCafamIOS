//
//  AlertInfraViewController.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 21/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit
protocol PopupDeleget {
    func closeTapped()
}

class AlertInfraViewController: UIViewController {

    @IBOutlet weak var Button: UIButton!
    var closePopup:PopupDeleget?
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }


    @IBAction func closeModal(_ sender: Any) {
        self.closePopup?.closeTapped()
    }
  

}
