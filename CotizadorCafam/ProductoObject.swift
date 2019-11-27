//
//  ProductoObject.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 27/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import Foundation

class ProductoObject {
    
    var Nombre: String!
    var Descripcion: String!;
    var Horas: Int!
    var IDCuso: Int!
    var TarifaAfiiados:String!;
    var TarifaANoafiiados:String!;
    var icon:String!;
    var Cupos:String!;
    
    init(nombre: String, tarifaAfi: String)
    {
        self.Nombre = nombre
        self.TarifaAfiiados = tarifaAfi
    }
}
