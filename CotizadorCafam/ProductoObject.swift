//
//  ProductoObject.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 27/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import Foundation

class ProductoObject:NSObject, NSCoding {
   
    
    var Nombre: String!
    var Descripcion: String!;
    var Horas: String!
    var IDCuso: Int!
    var TarifaAfiiados:String!;
    var TarifaANoafiiados:String!;
    var icon:String!;
    var Cupos:String!;
    
    init(nombre: String, tarifaAfi: String, descripcion:String, horas: String, cupos: String )
    {
        self.Nombre = nombre
        self.TarifaAfiiados = tarifaAfi
        self.Descripcion = descripcion
        self.Horas = horas
        self.Cupos = cupos
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.Nombre = aDecoder.decodeObject(forKey: "Nombre") as? String ?? ""
        self.TarifaAfiiados = aDecoder.decodeObject(forKey: "TarifaAfiiados") as? String ?? ""
        self.Descripcion = aDecoder.decodeObject(forKey: "Descripcion") as? String ?? ""
        self.Horas = aDecoder.decodeObject(forKey: "Horas") as? String ?? ""
        self.Cupos = aDecoder.decodeObject(forKey: "Cupos") as? String ?? ""
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(Nombre, forKey: "Nombre")
        aCoder.encode(TarifaAfiiados, forKey: "TarifaAfiiados")
        aCoder.encode(Descripcion, forKey: "Descripcion")
        aCoder.encode(Horas, forKey: "Horas")
        aCoder.encode(Cupos, forKey: "Cupos")
    }
}
