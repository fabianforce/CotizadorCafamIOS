//
//  CartTableViewCell.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 2/12/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import UIKit

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var labelCount: UILabel!
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelPriceProducto: UILabel!
    @IBOutlet weak var labelImporte: UILabel!
    @IBOutlet weak var btn_add: UIButton!
    @IBOutlet weak var btn_less: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
