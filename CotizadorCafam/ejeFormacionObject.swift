//
//  ejeFormacionObject.swift
//  CotizadorCafam
//
//  Created by Fabian Humberto Castillo Pineda on 25/11/19.
//  Copyright © 2019 Fabian Humberto Castillo Pineda. All rights reserved.
//

import Foundation

class ejeFormacionObject {
   
    var IDEje: String!
    var nombre: String!
    var icon: String!
    
    init(nombre: String)
    {
        self.nombre = nombre
    }
    init(nombre: String, idEjeFormacion: String)
    {
        self.nombre = nombre
        self.IDEje = idEjeFormacion;
    }
}
