//
//  SliderMenuViewController.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 29/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit
protocol SlideMenuDelegate{
    func slideMenuItemSelectArIndex(_ index : Int32)
}

class SliderMenuViewController: UIViewController {
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
    @IBOutlet weak var btnClose: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
  
    @IBAction func btnCloseSliderMenu(_ sender: UIButton) {
        btnClose.tag = 0
    
    if (self.delegate != nil) {
        var index = Int32(sender.tag)
        if(sender == self.btnClose){
            index = -1
        }
        delegate?.slideMenuItemSelectArIndex(index)
    }
    
    UIView.animate(withDuration: 0.3, animations: { () -> Void in
        self.view.frame = CGRect(x: UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
        self.view.layoutIfNeeded()
        self.view.backgroundColor = UIColor.clear
    }, completion: { (finished) -> Void in
        //self.view.removeFromSuperview()
        self.removeFromParent()
        

    })
    
    
    }

    
}
