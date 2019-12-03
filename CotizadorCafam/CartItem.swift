//
//  CartItem.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 2/12/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import Foundation
class CartItem:NSObject, NSCoding {
    //var IDEje: String!
    var name: String!;
    var price:Double!;
    var quantity:Int!;
    var productId:String!;
    var unitVal:String!;
    //var subtitle:String!;
    //var variable:String;
    
    init(name: String, price: Double, quantity:Int, unitVal: String, productId:String )
    {
        self.name = name
        self.price = price
        self.quantity = quantity
        self.unitVal = unitVal
        self.productId = productId
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        self.price = aDecoder.decodeObject(forKey: "price") as? Double
        self.quantity = aDecoder.decodeObject(forKey: "quantity") as? Int
        self.unitVal = aDecoder.decodeObject(forKey: "unitVal") as? String ?? ""
        self.productId = aDecoder.decodeObject(forKey: "productId") as? String ?? ""
    
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(price, forKey: "price")
        aCoder.encode(quantity, forKey: "quantity")
        aCoder.encode(unitVal, forKey: "unitVal")
        aCoder.encode(productId, forKey: "productId")
    }
}

